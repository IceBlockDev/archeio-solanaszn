# -*- coding:utf-8 -*-

import os
import sys
import errno

from struct import pack, unpack


class ErlangTermsMixin(object):

    def decode(self, term):
        version = ord(term[0])
        if version != 131:
            raise ValueError('unknown protocol version: {}'.format(version))
        return self._decode_term(term[1:])

    def _decode_term(self, term):
        tag = ord(term[0])
        tail = term[1:]

        if tag == 97:
            # SMALL_INTEGER_EXT
            return ord(tail[:1]), tail[1:]
        elif tag == 107:
            # STRING_EXT
            length, = unpack('>H', tail[:2])
            tail = tail[2:]
            #return [ord(i) for i in tail[:length]], tail[length:]
            return tail[:length], tail[length:]
        elif tag == 109:
            # BINARY_EXT
            length, = unpack('>H', tail[:2])
            tail = tail[2:]
            return [ord(i) for i in tail[:length]], tail[length:]
        elif tag == 100:
            # ATOM_EXT
            length, = unpack('>H', tail[:2])
            tail = tail[2:]
            name = tail[:length]
            tail = tail[length:]
            return name, tail
        elif tag == 104:
            # SMALL_TUPLE_EXT, LARGE_TUPLE_EXT
            arity = ord(tail[0])
            tail = tail[1:]

            lst = []
            while arity > 0:
                term, tail = self._decode_term(tail)
                lst.append(term)
                arity -= 1
            return tuple(lst), tail
        raise ValueError('unsupported data tag: {}'.format(tag))

    def encode(self, term):
        encoded_term = self._encode_term(term)
        return '\x83' + encoded_term

    def _encode_term(self, term):
        if isinstance(term, tuple):
            arity = len(term)
            if arity <= 255:
                header = 'h%c' % arity
            elif arity <= 4294967295:
                header = pack('>BI', 105, arity)
            else:
                raise ValueError('invalid tuple arity')
            return header + ''.join(self._encode_term(t) for t in term)
        elif isinstance(term, unicode):
            try:
                bytes_data = term.encode('latin1')
            except UnicodeEncodeError:
                pass
            return pack('>BH', 107, len(term)) + bytes_data
        elif isinstance(term, str):
            length = len(term)
            if length > 4294967295:
                raise ValueError('invalid binary length')
            return pack('>BI', 109, length) + term
        # must be before int type
        elif isinstance(term, (int, long)):
            if 0 <= term <= 255:
                return 'a%c' % term
            elif -2147483648 <= term <= 2147483647:
                return pack('>Bi', 98, term)
            raise ValueError('invalid integer value')
        raise ValueError('unsupported data type: {}'.format(term))


class Port(ErlangTermsMixin):

    #PACK_FORMAT = '>H'
    #PACKET_BYTE = 2
    PACK_FORMAT = '!I'
    PACKET_BYTE = 4

    def __init__(self):
        self.in_d = sys.stdin.fileno()
        self.out_d = sys.stdout.fileno()

    def read(self):
        data = self._read_data(self.PACKET_BYTE)
        length, = unpack(self.PACK_FORMAT, data)
        data = self._read_data(length)
        return self.decode(data)[0]

    def _read_data(self, length):
        data = ''
        while len(data) != length:
            try:
                buf = os.read(self.in_d, length)
            except IOError as e:
                if e.errno == errno.EPIPE:
                    raise EOFError('read error, EPIPE')
                raise IOError('read error, io error')
            if not buf:
                raise EOFError('read error, buffer')
            #data += buf.decode('utf-8')
            data += buf
        return data

    def write(self, message):
        data = self.encode(message)
        data = pack(self.PACK_FORMAT, len(data)) + data
        length = len(data)
        if not length:
            return

        try:
            n = os.write(self.out_d, data)
        except IOError as e:
            if e.errno == errno.EPIPE:
                raise EOFError('write error, EPIPE')
            raise IOError('write error, io error')
        if n == 0:
            raise EOFError('write error, no data')

    def close(self):
        os.close(self.in_d)
        os.close(self.out_d)


class Protocol(object):

    def __init__(self):
        self.port = Port()

    def handle(self, message):
        name = message[0]
        args = message[1:]

        handler = getattr(self, 'handler_{}'.format(name), None)
        if handler is None:
            return 'Error', 'Dose not exsit handler'

        try:
            response = handler(*args)
        except TypeError:
            response = 'TypeError', 'function_clause'
        return response

    def run(self):
        while True:
            try:
                message = self.port.read()
                response = self.handle(message)
                self.port.write(response)
            except ValueError as e:
                response = 'ValueError', e.message
                self.port.write(response)
            except EOFError as e:
                response = 'EOFError', e.message
                self.port.write(response)
                break


