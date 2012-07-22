
import mongoengine

class App(mongoengine.Document):
    name = mongoengine.StringField(required=True, unique=True)
    domain = mongoengine.StringField(required=True, unique=True)
    iphone_icon = mongoengine.URLField()
    ipad_icon = mongoengine.URLField()

    def to_dict(self):
        d = {'appname': self.name, 'domain': self.domain, 
                'iphone_icon': self.iphone_icon, 'ipad_icon': self.ipad_icon}
        return d

class User(mongoengine.Document):
    username = mongoengine.StringField(required=True, unique=True)
    device_token = mongoengine.StringField(required=True)

