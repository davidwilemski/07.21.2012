
import os
import mongoengine
from tornado import auth, escape, web, ioloop
from tornado.options import define, options
import tornado.options

define("port", default=8888, help="run on the given port", type=int)
define("cookie_secret", help="your web app's cookie secret",
       default="bleh")
define("mongo", help="your mongo connection details",
       default="mongodb://localhost/greylock")

def main():
    print options.cookie_secret
    settings = {
        'cookie_secret': options.cookie_secret,
        'login_url': "/auth/login",
        'template_path': os.path.join(os.path.dirname(__file__), "templates"),
        'static_path': os.path.join(os.path.dirname(__file__), "static"),
        'debug': True,
    }

    application = web.Application([
        (r"/push", 'push.PushHandler'),

        (r"/apps", 'apps.ListHandler'),
        (r"/apps/create", 'apps.CreateHandler'),
        (r"/apps/info/([a-zA-z0-9]+)", 'apps.InfoHandler'),
    ], **settings)

    application.listen(options.port)
    ioloop.IOLoop.instance().start()

if __name__ == '__main__':
    tornado.options.parse_command_line()
    mongoengine.connect(options.mongo)
    main()
