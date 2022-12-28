import PySimpleGUI as sg
from PIL import Image
import os
from io import BytesIO
import time

def update_image():
    try:
        if os.path.isfile('qr.png'):
            img = Image.open('qr.png').resize((600,600))
            bio = BytesIO()
            img.save(bio, format='PNG')
            window['-IMAGE_LEFT-'].update(data = bio.getvalue())
        else :
            img = Image.open('D:\\fpt\\semester_9\\SWP49X\\model\\apms_imp\\logo\\logo.png').resize((600,600))
            bio = BytesIO()
            img.save(bio, format='PNG')
            window['-IMAGE_LEFT-'].update(data = bio.getvalue())
    except:
        print(os.curdir)

def update_time():
    file = open('D:\\fpt\\semester_9\\SWP49X\\model\\apms_imp\\captures\\plate.txt','r')
    plate = file.readline()
    file.close()
    if len(plate) > 4:
        window['-TIME-'].update(plate)
    else:
        timeVar = time.strftime("%H:%M:%S")
        window['-TIME-'].update(timeVar)

image_col_left = sg.Column([[sg.Image('D:\\fpt\\semester_9\\SWP49X\\model\\apms_imp\\logo\\logo.png', key= '-IMAGE_LEFT-')]])
time_text = sg.Text('Time', justification='center', font='times 160', key='-TIME-')
layout=[[sg.VPush()],[time_text],[image_col_left],[sg.VPush()]]

window = sg.Window('AMPS - Camera Processing', layout, element_justification='c').Finalize()
window.Maximize()

while True:
    event, values = window.read(timeout = 50)
    if event == sg.WIN_CLOSED:
        break
    update_image()
    update_time()
window.close()