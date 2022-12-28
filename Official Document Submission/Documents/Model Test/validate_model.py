import glob
import torch
import cv2
import os
import pandas as pd
from paddleocr import PaddleOCR


weight_path = '../yolov5/runs/train/exp/weights/best.pt'

plate_model = torch.hub.load(
    '../yolov5', 'custom', path=weight_path, source='local')

order = []
image_dir = glob.glob('val/*.png')
detect_dir = []
plate = []
directory = os.path.abspath(os.curdir)
result_path = os.path.join(directory, 'detect_results')
ocr_model = PaddleOCR(lang='en', use_angle_cls=True)


def plate_detection():
    for i, v in enumerate(image_dir):
        img = cv2.imread(v)
        img_name = v.replace('val\\', '')
        img_name = img_name.replace('.png', '')
        # ------- License plate detection ---------
        results = plate_model(img)
        if ('no detections' in str(results)):
            detect_name = 'No license plate found'
            text = 'None'
        else:
            results_df = results.pandas().xyxy[0].loc[0]
            x_min = int(results_df['xmin'])
            x_max = int(results_df['xmax'])
            y_min = int(results_df['ymin'])
            y_max = int(results_df['ymax'])
            number_plate = img[y_min:y_max, x_min:x_max]
            detect_name = 'plate_{}.png'.format(img_name)
            os.chdir(result_path)
            cv2.imwrite(detect_name, number_plate)
            os.chdir(directory)
        # -----------------End detection--------------------
        # --------------- Linces plate reading -------------
            # --- Preprocess
            # Gray image
            # gray = cv2.cvtColor(number_plate, cv2.COLOR_BGR2GRAY)
            # # histogram equalization
            # equ = cv2.equalizeHist(gray)
            # th2 = 110  # this threshold might vary!
            # equ[equ >= th2] = 255
            # equ[equ < th2] = 0
            text = ocr_model.ocr(number_plate)
            # Extract string from deteced result
            if len(text[0]) > 1:
                text = text[0][0][-1][0] + ' ' + text[0][1][-1][0]
            elif len(text[0]) > 0:
                text = text[0][0][-1][0]
        # ----------------End Reading --------------------
        order.append(i)
        detect_dir.append(detect_name)
        plate.append(text)


def write_excel(name):
    df = pd.DataFrame(
        {'No.': order, 'Image': image_dir, 'Plate Image': detect_dir, 'Plate Reading': plate})
    writer = pd.ExcelWriter('Detect_Results_1.xlsx',
                            engine='xlsxwriter')
    # Write a dataframe to the worksheet.
    df.to_excel(writer, sheet_name=name)
    # Close the Pandas Excel writer
    # object and output the Excel file.
    writer.save()


if __name__ == "__main__":
    plate_detection()
    write_excel('Model_test')
