import requests
import serial
import time


# Define the serial port and baud rate.
# Ensure the 'COM#' corresponds to what was seen in the Windows Device Manager
arduino = serial.Serial('COM9', 9600)

url = 'http://18.136.151.97:6001/api/CarParks/slots/5a181b77-3ff6-4686-8520-a83b06a34454'

while True:
    response = requests.get(url)
    data = response.json()['data']
    print(data)
    slots=str(data)
    time.sleep(0.1)
    arduino.write(slots.encode())
    time.sleep(5)


