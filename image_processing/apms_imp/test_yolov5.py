import torch
import cv2
import os
import image_processing as ip
from paddleocr import PaddleOCR


# Model
runs_path = os.path.join('yolov5', 'runs', 'train')
latest_run = os.listdir(runs_path)[-1]
path = os.path.join(runs_path, latest_run, 'weights', 'best.pt')
plate_model = torch.hub.load('./yolov5', 'custom', path=path, source='local') # or yolov5n - yolov5x6, custom
ocr_model = PaddleOCR(lang='en')


# Images
# img = './car.png'  # or file, Path, PIL, OpenCV, numpy, list
stand_still = 0
stop = False
captured = False
counter = 0
center_1 = []
center_2 = []
record = []

img = cv2.imread('D:\\fpt\\semester_9\\SWP49X\\model\\apms_imp\\captures\\capture_51H-14532_15-12-2022_11-37-12.png')
results = plate_model(img)
i = ip.preprocess(img,results)
print(ocr_model.ocr(i))