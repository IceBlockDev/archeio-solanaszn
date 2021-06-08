import os
import sys
import errno
import erlang, json
from struct import pack, unpack
import logging

if "CCXT_POOL_PORTDEBUG" in os.environ:
    logging.basicConfig(filename='port.log',level=logging.DEBUG)

if sys.version_info[0] >= 3:
    TypeLong = int
else:
    TypeLong = long

class Port(object):
    PACK_FORMAT = '!I'
    PACKET_BYTE = 4

    def __init__(self):
        self.in_d = sys.stdin.fileno()
        self.out_d = sys.stdout.fileno()

    def read(self):
        header = os.read(self.in_d, self.PACKET_BYTE)
        if len(header) != 4:
            return None
        length, = unpack(self.PACK_FORMAT, header)
        data = os.read(self.in_d, length)
        if len(data) != length:
            return None

        term = erlang.binary_to_term(data)
        return term

    def write(self, message):
        payload = erlang.term_to_binary(message)
        header = pack(self.PACK_FORMAT, len(payload))
        data = header + payload
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
        logging.debug("handle!!!!!")
        logging.debug(message)
        if message is None:
            return "{}"
        name = message[0]
        args = message[1:]

        handler = getattr(self, 'handler_{}'.format(name), None)
        if handler is None:
            return json.dumps({'Error':'Dose not exsit handler'})

        try:
            response = handler(*args)
        except TypeError:
            response = json.dumps({'TypeError': 'function_clause'})
        return response

    def decode(self, term):
        if isinstance(term, bytes):
            return term.decode('utf-8')
        elif isinstance(term, erlang.OtpErlangAtom):
            return term.value.decode('utf-8')
        elif isinstance(term, int) or isinstance(term, TypeLong):
            return term
        elif isinstance(term, float):
            return term 
        else:
            raise Exception(term)
            

    def run(self):
        while True:
            try:
                logging.debug('---->')
                msg = self.port.read()
                logging.debug(msg)
                if msg is None:
                    break
                response = self.handle([self.decode(i) for i in msg])
                #raise Exception(response)
                self.port.write(response)
            except ValueError as e:
                response = 'ValueError', e.message
                self.port.write(response)
            except EOFError as e:
                response = 'EOFError', e.message
                self.port.write(response)
                break

