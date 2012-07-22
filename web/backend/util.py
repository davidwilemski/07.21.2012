def push_properties(props):
    """
    takes a dictionary and converts it into APNSProperties
    """
    result = []
    for key in props:
        result.append(APNSWrapper.APNSProperty(name=key,data=props[key]))
    return result

def do_push(device_token, alert, properties, sound=True, sandbox=True):
    if not device_token:
        return

    # create wrapper
    if sandbox:
        wrapper = APNSWrapper.APNSNotificationWrapper('aps_cert.pem', True)
    else:
        wrapper = APNSWrapper.APNSNotificationWrapper('apns_cert_prod.pem', True)


    # create message
    message = APNSWrapper.APNSNotification()
    message.tokenHex(device_token)
    message.alert(alert)

    if sound:
        message.sound()

    properties = push_properties(properties)
    for p in properties:
        message.appendProperty(p) 

    # add message to tuple and send it to APNS server
    wrapper.append(message)
    wrapper.notify()


