import numpy as np

class algorithm:
    
    left_trajectory_code = [0]
    right_trajectory_code =[0]
    
    left_trajectory_code =  [0,1,2,3,2,1,0,-1,-3,-5,-3,-1,0,1,2,3,2,1,0]
    right_trajectory_code = [0,1,3,5,3,1,0,-1,-2,-3,-2,-1,0,1,3,5,3,1,0]
    
    def __init__(self,ts):
        self.timestep = ts
        self.internal_clock = 0
        self.trajectory_interval = int(1000/self.timestep)
        self.left_smooth_trajectory = self.calcSmoothTrajectory(self.left_trajectory_code,self.trajectory_interval)
        self.right_smooth_trajectory = self.calcSmoothTrajectory(self.right_trajectory_code,self.trajectory_interval)
        self.status = 0
        
        
    def getSignal(self):
        self.status = 0
        left_velocity = 0
        right_velocity = 0
        
        if self.internal_clock < len(self.left_smooth_trajectory):
            left_velocity = self.left_smooth_trajectory[self.internal_clock]
        if self.internal_clock < len(self.right_smooth_trajectory):
            right_velocity = self.right_smooth_trajectory[self.internal_clock]
            
        if self.internal_clock == len(self.left_smooth_trajectory) and self.internal_clock == len(self.right_smooth_trajectory):
            self.status = 1
            print("DONE")
        #print(left_velocity, "\t", right_velocity)
        self.internal_clock = self.internal_clock+1
        return (left_velocity,right_velocity)
        
    def getInternalTime(self):
        return self.internal_clock
        
    def getStatus(self):
        return self.status
        
    def calcSmoothTrajectory(self,code,interval):
        trajectory = []
        for i in np.arange(len(code)-1):
            linearTrajectory = np.linspace(code[i], code[i+1], int(interval)+1)
            trajectory.extend(linearTrajectory[:len(linearTrajectory)-1])
        return trajectory
    
