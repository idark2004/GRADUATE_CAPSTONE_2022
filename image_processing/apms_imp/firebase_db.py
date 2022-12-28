from distutils.command.config import config
import os
import pyrebase
from api import checkTicket


config = {
    "apiKey": "AIzaSyAuLzZ8MyeFO3Z6OB8SJhF8932cZVnWHvo",
    "authDomain": "apms-48bd5.firebaseapp.com",
    "databaseURL": "https://apms-48bd5-default-rtdb.asia-southeast1.firebasedatabase.app",
    "projectId": "apms-48bd5",
    "storageBucket": "apms-48bd5.appspot.com",
    "messagingSenderId": "1041561578315",
    "appId": "1:1041561578315:web:48e84f8f5dbafda89896ce",
    "measurementId": "G-XTJ80CW8TS"
}

firebase = pyrebase.initialize_app(config=config)
db = firebase.database()
def closeBarrier():
    file = open('plate.txt', 'r')
    plate = file.readline()
    file.close()
    if len(plate) > 4:
        print(plate)
        exist = checkTicket(plate, 'asd')
        print(exist)
        if exist:
            servo = db.child('servo_prev').get()
            print('in')
            if servo.val() != 'CLOSE':
                db.update({"servo": 'CLOSE'})
        else:
            servo = db.child('servoExit_prev').get()
            if servo.val() != 'CLOSE':
                print('out')
                db.update({"servoExit": 'CLOSE'})
