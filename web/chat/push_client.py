
from tornado import httpclient, gen, escape

@gen.engine
def send_push(device_token, appname, domain, msg, callback):
    d = {
            'appname': appname, 
            'domain': domain, 
            'title': 'New Chat Message',
            'msg': msg,
    }

    request = httpclient.HTTPRequest('http://23.21.143.75:8888/push', method='POST', body=escape.json_encode(d))
    http = httpclient.AsyncHTTPClient()
    yield gen.Task(http.fetch, request)
    callback()

