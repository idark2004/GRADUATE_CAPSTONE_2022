import cv2

def preprocess(image, results) :
    plate =''
    try:
        # Getting co ordinates of license plate
        results_df = results.pandas().xyxy[0].loc[0]
        x_min = int(results_df['xmin'])
        x_max = int(results_df['xmax'])
        y_min = int(results_df['ymin'])
        y_max = int(results_df['ymax'])
        # Cropping license plate from image
        number_plate = image[y_min:y_max, x_min:x_max]
        # Gray image
        gray = cv2.cvtColor(number_plate,cv2.COLOR_BGR2GRAY)
        # histogram equalization
        equ = cv2.equalizeHist(gray)
        # Gaussian blur
        #blur = cv2.GaussianBlur(equ, (5, 5), 1)

        # manual thresholding
        th2 = 100 # this threshold might vary!
        equ[equ>=th2] = 255
        equ[equ<th2]  = 0
        cv2.imwrite('plate_1.png',equ)
        plate = equ

    except Exception:
        plate = ''
    return plate
