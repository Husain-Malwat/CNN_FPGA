# from matplotlib.image import imread
# import numpy as np
import serial
from time import sleep

a=5
port="COM4"
baud=9600
## panda = imread("32.png")  # covert image in matrix
print(a)
ser = serial.Serial(port, baud)  # Open port with baud rate
while True:
    ser.write(a)
    sleep(3)
    received_data = ser.read()  # read serial port
    data_left = ser.inWaiting()  # check for remaining byte
    received_data += ser.read(data_left)
    print(received_data)  # print received data
    ser.close()