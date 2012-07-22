
import base

import twilio
import voip_settings


conf = voip_settings.VoipSettings()

class TwimlHandler(base.BaseHandler):
    def get(self):
        number = self.get_argument('number', '')
        self.set_header('Content-Type', 'text/xml')
        self.write(
                '<Response><Dial callerid="{}">{}</Dial></Response>'.format(
                    conf.callerid, number))
