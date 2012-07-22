
import mongoengine
import time

class User(mongoengine.Document):
    username = mongoengine.StringField(required=True, unique=True)
    device_token = mongoengine.StringField(required=True)

class Chat(mongoengine.Document):
    users = mongoengine.StringField(required=True)

    # messages format:
    # timestamp => {author: username, msg: msg}uired=True)
    messages = mongoengine.DictField() 

    @classmethod
    def get_chat(cls, user1, user2):
        users = sorted([user1, user2])
        users = '.'.join(users)

        chat = cls.objects(users=users).first()
        if not chat:
            chat = cls(users=users)

        return chat

    def add_msg(self, author, msg):
        self.messages[str(time.time())] = {
            'author': author,
            'msg': msg
        }
        self.save()

