import tornado.ioloop
import tornado.web
import os
from tornado import gen
import push_client
import logging
import mongoengine

import models

class BaseHandler(tornado.web.RequestHandler):
    def get_current_user(self):
        user = self.get_secure_cookie('username', None)

        user = models.User.objects(username=user).first()
        return user

class MainHandler(BaseHandler):
    """handles login"""
    def get(self):
        self.render("index.html")

    def post(self):
        username = self.get_argument('username')
        device_token = self.get_argument('device_token')

        # if user exists, update device token
        user = models.User.objects(username=username).first()
        if not user:
            # else create user
            user = models.User(username=username, device_token=device_token)
        user.device_token = device_token
        user.save()

        self.set_secure_cookie('username', username)
        self.redirect('/chat')

class ChatHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        """ returns list of chat contacts"""
        user = self.get_current_user()
        users = models.User.objects
        self.render('contacts.html', users=users)

class ChatRoomHandler(BaseHandler):
    @tornado.web.authenticated
    @tornado.web.asynchronous
    @tornado.gen.engine
    def get(self, user):
        #yield gen.Task(push_client.send_push, device_token, 'demo2', 'http://23.21.143.75:8899')
        pass


settings = {
    'template_path': os.path.join(os.path.dirname(__file__), "templates"),
    'cookie_secret': 'ins3cur3',
    'debug': True,
    
}
application = tornado.web.Application([
    (r"/", MainHandler),
    (r"/chat", ChatHandler),
    (r"/chat/([a-zA-Z0-9]+)", ChatRoomHandler),
], **settings)

if __name__ == "__main__":
    mongoengine.connect('chat')    
    application.listen(9999)
    tornado.ioloop.IOLoop.instance().start()

