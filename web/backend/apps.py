
from tornado import web, escape

import base
import models

class CreateHandler(base.BaseHandler):
    def get(self):
        self.render('app-create.html')

    @web.asynchronous
    def post(self):
        appname = self.get_argument('appname')
        domain = self.get_argument('domain')
        iphone_icon = self.get_argument('iphone_icon')
        ipad_icon = self.get_argument('ipad_icon')

        app = models.App(name=appname, domain=domain)
        app.iphone_icon = iphone_icon
        app.ipad_icon = ipad_icon
        app.save()

        self.finish()


class InfoHandler(base.BaseHandler):
    @web.asynchronous
    def get(self, appname):
        app = models.App.objects(appname=appname).first()
        if app is None:
            raise web.HTTPError(404)
        self.finish(app.to_dict())

class ListHandler(base.BaseHandler):
    @web.asynchronous
    def get(self):
        apps = models.App.objects

        applist = [app.to_dict() for app in apps]
        result = {'apps': applist}
        self.finish(result)
