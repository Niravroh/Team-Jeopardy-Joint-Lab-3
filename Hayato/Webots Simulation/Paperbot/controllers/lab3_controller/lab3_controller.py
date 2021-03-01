"""lab3_controller controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, Motor, DistanceSensor
from controller import *
import algorithm_layer
import math
import csv

saveData = True

# create the Robot(Supervisor) instance.
robot = Supervisor()

# get the time step of the current world.
timestep = int(robot.getBasicTimeStep())

# Robot node for measuring states relative to world
robot_node = robot.getFromDef("Paperbot")
rot_field = robot_node.getField("rotation")

# Sensors
lidar_F = robot.getDevice('lidar_F')
lidar_F.enable(timestep)
lidar_R = robot.getDevice('lidar_R')
lidar_R.enable(timestep)
gyro = robot.getDevice('gyro')
gyro.enable(timestep)
compass = robot.getDevice('compass')
compass.enable(timestep)

# Actuators
motor_L = robot.getDevice('motor_L')
motor_L.setPosition(float('inf'))
motor_R = robot.getDevice('motor_R')
motor_R.setPosition(float('inf'))

a = algorithm_layer.algorithm(timestep)

# Recorded Data
_time  = []
_velL  = []
_velR  = []
_posX  = []
_posY  = []
_theta = []
_sen1  = []
_sen2  = []
_sen3  = []
_sen4  = []
_sen5  = []

status = 0

# Main loop:
# - perform simulation steps until Webots is stopping the controller
while robot.step(timestep) != -1:
    # Read the sensors:
    # Enter here functions to read sensor data, like:
    #  val = ds.getValue()
    
    (left_signal, right_signal) = a.getSignal()
    
    motor_L.setVelocity(-left_signal)
    motor_R.setVelocity(-right_signal)

    lidar_F_value = lidar_F.getValue()
    lidar_R_value = lidar_R.getValue()
    gyro_value = gyro.getValues()[1]
    compass_X_value = compass.getValues()[2]
    compass_Y_value = compass.getValues()[0]
    
    position = robot_node.getPosition()
    pos_X = position[0]
    pos_Y = -position[2]
    theta = (math.degrees(rot_field.getSFRotation()[3])+90)%360
    
    status = status + a.getStatus()
    print(status, a.getInternalTime(), left_signal, right_signal)
    
    if status == 0:
        _time.append(a.getInternalTime())
        _velL.append(motor_L.getVelocity())
        _velR.append(motor_R.getVelocity())
        _posX.append(pos_X)
        _posY.append(pos_Y)
        _theta.append(theta)
        _sen1.append(lidar_F_value)
        _sen2.append(lidar_R_value)
        _sen3.append(gyro_value)
        _sen4.append(compass_X_value)
        _sen5.append(compass_Y_value)
    
    if saveData and status == 1:
        status = 2
        with open('webotsSim_data.csv','w') as file:
            writer = csv.writer(file)
            writer.writerow(["Time Index", "L Velocity", "R Velocity","X Position","Y Position","Theta","LiDAR F","LiDAR R","Gyro","Compass X","Compass Y"])
            for i in range(len(_time)):
                writer.writerow([i, _velL[i], _velR[i],_posX[i], _posY[i], _theta[i], _sen1[i], _sen2[i], _sen3[i], _sen4[i], _sen5[i]])  
    
    #pass
    if status == 2:
        break

print("end")
# Enter here exit cleanup code.

