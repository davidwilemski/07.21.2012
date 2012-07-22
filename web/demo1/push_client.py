
from tornado import httpclient, gen, escape

@gen.engine
def send_push(device_token, appname, domain, callback):
    d = {'appname': appname, 'domain': domain, 'device_token': device_token}

    request = httpclient.HTTPRequest('http://23.21.143.75:8888/push', method='POST', body=escape.json_encode(d))
    http = httpclient.AsyncHTTPClient(request)
    yield gen.Task(http.fetch)
