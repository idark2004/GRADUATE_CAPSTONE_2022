import requests
import os
from dotenv import load_dotenv

load_dotenv()
BASE_URL = os.getenv('API_URL')
CAR_PARK_ID = os.getenv('CAR_PARK_ID')
def checkTicket(plateNumber, picInUrl):
    check_url = BASE_URL + 'check-in'
    res = requests.post(check_url, params={'plateNumber': plateNumber, 'carParkId' : CAR_PARK_ID, 'picInUrl': picInUrl })
    json = res.json()
    return json['data']['exist']
