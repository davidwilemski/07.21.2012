import tornado.ioloop
import tornado.web
import os
from tornado import gen
import push_client
import logging

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        logger = logging.getLogger('demo1')
        logger.info("at /")
        self.render("index.html")

class PushHandler(tornado.web.RequestHandler):
    @tornado.web.asynchronous
    @tornado.gen.engine
    def get(self, device_token):
        yield gen.Task(push_client.send_push, device_token, 'demo1', 'http://23.21.143.75:8889')
        self.finish('ok')


settings = {
    'template_path': os.path.join(os.path.dirname(__file__), "templates"),
    
}
application = tornado.web.Application([
    (r"/", MainHandler),
    (r"/sendpush/([a-zA-Z0-9]+)", PushHandler),
], **settings)

if __name__ == "__main__":
    application.listen(8889)
    tornado.ioloop.IOLoop.instance().start()

