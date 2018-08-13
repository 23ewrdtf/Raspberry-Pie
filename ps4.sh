#Test script for using pygame to read in ds4 controller
#with ds4drv  running as a daemon
#DS4  controller axis maps:
#Axis0: Left stick l-r (-1 left, 1 right)
#Axis1: Left stick u-d (-1 up, 1 down)
#Axis2: Left trigger (-1 unpressed, 1 completely pressed)
#Axis3: Right stick l-r (-1 left, 1 right)
#Axis4: Right stick u-d (-1 up, 1 down)
#Axis5: Right trigger (-1 unpressed, 1 completely pressed)
#
#sudo apt install python3-dev python3-pip
#sudo pip3 install ds4drv
#Then in the file “/home/user/.bashrc” – where user is pi by default – add the following line to the file:
#
#sudo ds4drv --daemon --led 000008 --emulate-xpad-wireless &
#This ensures that the bluetooth driver is initialised every time you log in. Then to connect your ds4 controller hold the share button and the ps button until manic flashing begins and the light bar should turn blue when it’s all connected.
#
#To test this was working I used a program called jstest. You can get this by running the commands:
#
#sudo apt-get install joystick
#jstest /dev/input/js0
 
import pygame
import wiringpi
from time import sleep
import sys
 
#initialise DS4 controller
screen = pygame.display.set_mode([10,10]) #make a 10x10 window
pygame.joystick.init() #find the joysticks
joy = pygame.joystick.Joystick(0)
joy.init()
if(joy.get_name()=='Sony Entertainment Wireless Controller'):
    print("DS4 connected")
else:
    print("Not a DS4")
 
 
Motor1PWM  = 4
Motor1AIN1 = 3
Motor1AIN2 = 2
#MotorStandby = 6 # gpio pin 22 = wiringpi no. 6 (BCM 25)
Motor2PWM = 23
Motor2BIN1 = 7
Motor2BIN2 = 0
 
# Initialize PWM output
wiringpi.wiringPiSetup()
wiringpi.pinMode(Motor1PWM, 2)     # PWM mode
wiringpi.pinMode(Motor1AIN1, 1) #Digital out mode
wiringpi.pinMode(Motor1AIN2, 1) #Digital out mode
#wiringpi.pinMode(MotorStandby, 1) #Ditial out mode
 
wiringpi.pinMode(Motor2PWM, 2)     # PWM mode
wiringpi.pinMode(Motor2BIN1, 1)    #Digital out mode
wiringpi.pinMode(Motor2BIN2, 1)    #Digital out mode
 
 
wiringpi.pwmWrite(Motor1PWM, 0)    # OFF
wiringpi.pwmWrite(Motor2PWM, 0)    # OFF
wiringpi.digitalWrite(Motor1AIN1, 1) #forward mode
wiringpi.digitalWrite(Motor1AIN2, 0) #forward mode
wiringpi.digitalWrite(Motor2BIN1, 1)
wiringpi.digitalWrite(Motor2BIN2, 0)
#wiringpi.digitalWrite(MotorStandby, 1) #enabled
 
 
# Set Motor Speed
def motorspeed(speed1, speed2):
    wiringpi.pwmWrite(Motor1PWM, speed1) #motorspeed from 0 to 1024
    wiringpi.pwmWrite(Motor2PWM, speed2) 
 
while True:
    pygame.event.get()
    rt = joy.get_axis(5)
    #0 left stick
    #1 left stick
    #2 lt
    #3 right stick right
    #4 right stick down
    #5 rt
    #6 
    lt = joy.get_axis(2)
    print(rt)
    print(lt)
    speed1 = (rt+1)*512
    speed2 = (lt+1)*512
    motorspeed(int(speed1),int(speed2))
    sleep(0.1) #limit the frequency to 10Hz
