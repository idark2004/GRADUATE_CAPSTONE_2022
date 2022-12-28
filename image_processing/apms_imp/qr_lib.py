import qrcode

def generate(checkin, plate, carParkId, firebaseUrl):
    data = {
        "checkin" : checkin,
        "plate" : plate,
        "carParkId" : carParkId,
        "firebaseUrl" : firebaseUrl
    }
    img = qrcode.make(data=data)

    return img