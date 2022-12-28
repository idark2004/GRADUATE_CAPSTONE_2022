import time
import cv2
import os
import image_processing as ip
import torch
import numpy as np
from datetime import date
from paddleocr import PaddleOCR
from dotenv import load_dotenv
from api import checkTicket
from firebase_image import uploadImage
import re
import math
from firebase_db import closeBarrier

from datetime import datetime


#import serial
import qr_lib

load_dotenv()
CAR_PARK_ID = os.getenv('CAR_PARK_ID')

stand_still = 0
frame_counter = 0
ticket = False
stop = False
captured = False
counter = 0
center_1 = []
center_2 = []
record = []
plateNumber = ''

counter = 0
# Create captures folder
script_path = os.path.abspath(os.curdir) #get current path
folder_path = os.path.join(script_path, 'captures') #join new folder to current path
#check if folder existed
if not os.path.exists(folder_path):
  os.mkdir(folder_path)

# Load plate detection model - yolov5
runs_path = os.path.join('yolov5', 'runs', 'train')
latest_run = os.listdir(runs_path)[-1]
path = os.path.join(runs_path, latest_run, 'weights', 'best.pt')
plate_model = torch.hub.load('./yolov5', 'custom', path=path, source='local')
ocr_model = PaddleOCR(lang='en')

# Car model
car_model = torch.hub.load('./yolov5', 'custom', path='./yolov5/runs/train/exp/weights/yolov5s.pt',source='local')


def getCenter(df):
    return (np.average([df['xmin'].tolist()[0],df['ymin'].tolist()[0]]), np.average([df['xmax'].tolist()[0],df['ymax'].tolist()[0]]))

def checkStringFormat(string):
  return re.search('\d{2}[A-Z]\-\d{4,5}$',string)

#RTSP : rtsp://[USERNAME]:[PASSWORD]@[IP_ADDRESS]:[PORT]/cam/realmonitor?channel=1&subtype=0
# front camera : rtsp://admin:admin123@192.168.20.2:1025/cam/realmonitor?channel=1&subtype=0 - det_cam
# back camera : rtsp://admin:admin123@192.168.20.11:554/cam/realmonitor?channel=1&subtype=0 - cv
det_cam = cv2.VideoCapture('rtsp://admin:admin123@192.168.20.2:1025/cam/realmonitor?channel=1&subtype=0')


while True:
  
    ret2, frame2 = det_cam.read() # Detect cam
# Inference1
    frame2 = cv2.resize(frame2, (720,1000))
    results = car_model(frame2)
    cv2.imshow('YOLO', np.squeeze(results.render()))
    raw = results.pandas().xyxy[0]
    df = raw.loc[raw['class'] == 2]
    empt = df.empty
    k = cv2.waitKey(1)
    if(k==113) : # Hit 'q' to quit
        break

    if not empt:
      # Get center point of bounding box
        center = [np.average([df['xmin'].tolist()[0], df['ymin'].tolist()[0]]), np.average(
            [df['xmax'].tolist()[0], df['ymax'].tolist()[0]])]
        if not center_1:
            center_1 = center
        else:
            center_2 = center
        # Calculate the distance between center point between 2 frames
        if ((len(center_1) > 0) and (len(center_2) > 0)):
            dx = (center_2[0] - center_1[0])**2
            dy = (center_2[1] - center_1[1])**2
            dist = math.sqrt(dx + dy)
            record.append(dist)
            center_1 = []
            center_2 = []

        # After 10 calculation ( 20 frames ) get the average of those numbers
        if len(record) == 10:
            avg = np.average(record)
            if avg <4:
                print('---Ok----')
                stand_still += 1
                print('Counting : ',stand_still)
            else:
                print('-----Moving')
                stand_still =0
            record = []
        if (not captured) and (stand_still == 4) and (not stop):
          #rtsp://admin:admin123@192.168.20.11:554/cam/realmonitor?channel=1&subtype=0
          cv = cv2.VideoCapture('rtsp://admin:admin123@192.168.20.11:554/cam/realmonitor?channel=1&subtype=0')
          ret1, frame1 = cv.read() # Lincense cam
          #frame1 = frame1[80: frame1.shape[0]-70, 0 : frame1.shape[1]]
          cv2.imwrite('frame.png',frame1)
          os.chdir(folder_path) # Change directory to "capture" folder
          # Detect lincese plate
          results = plate_model(frame1)
          if('no detections' in str(results)):
            text = 'No license plate found'
            stand_still =0
          else:
            equ_plate = ip.preprocess(frame1, results)
            cv2.imwrite(str(date.today())+'.png',equ_plate)
            #Read linces plate
            text = ocr_model.ocr(equ_plate)
            #Extract string from deteced result
            if len(text[0]) > 1 :
              plateNumber = text[0][0][-1][0] + '-' + text[0][1][-1][0]
            elif len(text[0])>0:
              plateNumber = text[0][0][-1][0]
            if len(plateNumber) > 0 :
              plateNumber = plateNumber.replace('.','')
              plateNumber = plateNumber.replace(',','')
              plateNumber = plateNumber.replace(',','')
              plateNumber = plateNumber.replace(' ','')
              print(plateNumber)
              if checkStringFormat(plateNumber) :
                print('------Before qr-----')
                now = datetime.now()
                img_name = 'capture_{}_{}.png'.format(plateNumber,now.strftime("%d-%m-%Y_%H-%M-%S"))
                img_path =os.path.join(folder_path,img_name)
                print(img_path)
                cv2.imwrite(img_name,frame1)
                # write file
                file = open('plate.txt','w')
                file.write(plateNumber)
                file.close()
                #Firebase upload
                firebaseUrl = uploadImage(img_name,img_path)
                ticket = checkTicket(plateNumber,firebaseUrl)
                #Generate QR
                qr_img = qr_lib.generate(ticket,plateNumber,CAR_PARK_ID,firebaseUrl)
                qr_img.save('qr.png')
                print(img_path)
                print(plateNumber)
                stand_still = 0
                stop = True
                captured = True
              else:
                stand_still =0

            print(text)
            cv.release()
    else:
        if stop:
            second_results = car_model(frame2)
            print(second_results)
            nd_raw = second_results.pandas().xyxy[0]
            nd_df_car = nd_raw.loc[nd_raw['class'] == 2]
            nd_nf_truck = nd_raw.loc[nd_raw['class'] == 7]
            if nd_df_car.empty and nd_nf_truck.empty :
              time.sleep(2)
              closeBarrier()
              file = open('plate.txt','w')
              file.write('')
              file.close()
              os.remove('qr.png')# If no car detect close barrier
              print('----Closing Barrier----')
              stand_still = 0
              stop = False
              captured = False


cv2.destroyAllWindows()