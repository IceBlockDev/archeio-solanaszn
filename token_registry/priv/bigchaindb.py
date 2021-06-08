from protocol_mkh import Protocol
import json, sys, requests

try:
    from itertools import izip as zip
except ImportError:
    pass
import logging, os

from bigchaindb_driver import BigchainDB
bdb_root_url = 'http://bchaindb:9984'
bdb = BigchainDB(bdb_root_url)

#if "PORT_DEBUG" in os.environ:
#    logging.basicConfig(filename='port.log', level=logging.DEBUG)
logging.basicConfig(filename='port.log', level=logging.DEBUG)


class Beam(Protocol):


    def handler_transactioncreate(self, json_str_parameters):
       try:
            params = json.loads(json_str_parameters)
            logging.debug('create args ----> %s' % params)
            pk = params['public_key']
            logging.debug('0001 %s' % pk)
            asset = params['asset']
            logging.debug('0002 %s' % asset)
            prk = params['private_key']
            logging.debug('0003 %s' % prk)
            metadata = params['metadata']
            logging.debug('0004 %s' % metadata)

            prepared_token_tx = bdb.transactions.prepare(
                operation='CREATE',
                signers=pk,
                metadata=metadata,
                asset={  "data": asset} )
            logging.debug('1111')
            fulfilled_token_tx = bdb.transactions.fulfill(
                prepared_token_tx,
                private_keys=prk)
            logging.debug('2222')
            data = bdb.transactions.send_commit(fulfilled_token_tx)
            logging.debug('3333')

            ret = {'handler':'transactioncreate', 'status':'ok', 'data':data}
            return json.dumps(ret)
       except Exception as e:
            logging.debug('error %s' % str(e))
            return json.dumps({
                    'handler':'transactioncreate', 
                    'status': 'failed',
                    'error': 'port exception %s' % str(e)})

    def handler_transactionupdate(self, json_str_parameters):
       try:
            params = json.loads(json_str_parameters)
            creation_tx = bdb.transactions.retrieve(params['txid'])
            asset_id = creation_tx['id']
            transfer_asset = { 'id': asset_id }
            output_index = 0
            output = creation_tx['outputs'][output_index]
            transfer_input = {
                'fulfillment': output['condition']['details'],
                'fulfills': {
                    'output_index': output_index,
                    'transaction_id': creation_tx['id'],
                },
                'owners_before': output['public_keys'],
            }
            prepared_transfer_tx = bdb.transactions.prepare(
                operation='TRANSFER',
                asset=transfer_asset,
                inputs=transfer_input,
                metadata=params['metadata'],
                recipients=params['recipient_public_key'],
            )
            fulfilled_transfer_tx = bdb.transactions.fulfill(
                prepared_transfer_tx,
                private_keys=params['owner_private_key'],
            )
            data = bdb.transactions.send_commit(fulfilled_transfer_tx)

            ret = {'handler':'transactioncreate', 'status':'ok', 'data':data}
            return json.dumps(ret)
       except Exception as e:
            logging.debug('error %s' % str(e))
            return json.dumps({
                    'handler':'transactioncreate', 
                    'status': 'failed',
                    'error': 'port exception %s' % str(e)})

if __name__ == '__main__': 
    logging.debug('main run')
    Beam().run()


