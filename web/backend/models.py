
import mongoengine

class App(mongoengine.Document):
    name = mongoengine.StringField(required=True, unique=True)
    domain = mongoengine.StringField(required=True, unique=True)
    iphone_icon = mongoengine.URLField()
    ipad_icon = mongoengine.URLField()

    def to_dict(self):
        return self.__dict__
