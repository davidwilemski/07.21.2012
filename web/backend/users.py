
from tornado import web

import base
import models

import twilio
import twilio.util
import voip_settings

def gen_token(name):
    token = twilio.util.TwilioCapability(
            conf.sid,
            conf.auth_token)
    token.allow_client_outgoing(conf.appid)
    return token

class LoginHandler(base.BaseHandler):
    @web.asynchronous
    def get(self):
        username = self.get_argument('username')
        device_token = self.get_argument('device_token')

        # if user exists, update device token
        user = models.User.objects(username=username).first()
        if not user:
            # else create user
            user = models.User(username=username, device_token=device_token)
        user.device_token = device_token
        user.save()

        token = gen_token(username)
        self.finish({'token': token.generate()})
