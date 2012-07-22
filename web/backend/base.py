
from tornado import web, auth, escape

class BaseHandler(web.RequestHandler):
    def get_json(self):
        return escape.json_decode(self.request.body)

    @property
    def debug(self):
        return self.application.settings['debug']
