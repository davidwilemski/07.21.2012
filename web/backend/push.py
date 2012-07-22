
from tornado import web, escape

import base
import util

class PushHandler(base.BaseHandler):
    """ 
    Recieves a HTTP request and sends a push notification on behalf of
    the calling web app
    """

    @web.asynchronous
    def post(self):
        data = self.get_json()

        if 'appname' not in data or 'domain' not in data or 'device_token' not in data:
            raise web.HTTPError(400)

        appname = data['appname']
        domain = data['domain']
        device_token = data['device_token']

        props = {
                'appname': appname,
                'domain': domain,
        }
        if 'title' in data:
            props['title'] = data['title']
        if 'msg' in data:
            props['msg'] = data['msg']
        
        util.do_push(
                device_token, 
                "{} has a push".format(appname), 
                props, sandbox=self.debug)

        self.finish()

        

