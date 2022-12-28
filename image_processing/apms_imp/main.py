from threading import Thread

def gui_func(): import gui
Thread(target = gui_func).start()

def camera_func() : import camera_process
Thread(target= camera_func).start()

# Run run.bat file