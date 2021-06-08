# pip install --trusted-host pypi.org --trusted-host files.pythonhosted.org websocket-client

import websocket,json
import datetime

try:
    import thread
except ImportError:
    import _thread as thread
import time


def on_message(ws, message):
    print("on message")
    print(str(message))
    m = json.loads(str(message))
    print(m)

def on_error(ws, error):
    print("on error")
    print(error)

def on_close(ws):
    print("### closed ###")
    print("errors nnum: %s" % seqerrs)

def on_open(ws):
    def run(*args):
        ws.send(json.dumps({"topic": "notification:all", "event":"phx_join", "payload":{"fetch": True}, "ref": 0}))
    def heartbeat(*args):
        while(1):
           time.sleep(30)
           print("HB!")
           ws.send(json.dumps({"topic": "phoenix", "event": "heartbeat", "payload": {},"ref": 0}))

    thread.start_new_thread(run, ())
    thread.start_new_thread(heartbeat, ())

if __name__ == "__main__":
    #websocket.enableTrace(True)
    ws = websocket.WebSocketApp("ws://localhost:4000/socket/websocket",
                              on_message = on_message,
                              on_error = on_error,
                              on_close = on_close)
    ws.on_open = on_open
    ws.run_forever()
