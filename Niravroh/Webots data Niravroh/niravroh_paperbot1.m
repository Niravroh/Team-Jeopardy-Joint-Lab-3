% MATLAB controller for Webots
% File:          niravroh_paperbot1.m
% Date:
% Description:
% Author:
% Modifications:

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
%desktop;
%keyboard;

 % Get simulation time step;
  TIME_STEP = wb_robot_get_basic_time_step();

% get and enable devices, e.g.:
%  camera = wb_robot_get_device('camera');
%  wb_camera_enable(camera, TIME_STEP);

 % Create instances of motors sensors, nodes;
  motor_R = wb_robot_get_device('motor_R');
  motor_L = wb_robot_get_device('motor_L');
  compass = wb_robot_get_device('compass');
  gyro = wb_robot_get_device('gyro');
  lidar_F = wb_robot_get_device('lidar_F');
  lidar_R = wb_robot_get_device('lidar_R');
  robot = wb_supervisor_node_get_from_def('robot');
  rotation = wb_supervisor_node_get_field(robot,'rotation');
  
 % Enable sensors (instance, sampling period[ms]);
  wb_compass_enable(compass, TIME_STEP);
  wb_gyro_enable(gyro, TIME_STEP);
  wb_distance_sensor_enable(lidar_F, TIME_STEP);
  wb_distance_sensor_enable(lidar_R, TIME_STEP);
 % Make the motors non-position control mode;
  wb_motor_set_position(motor_R, inf);
  wb_motor_set_position(motor_L, inf);



% Allocate arrays and increment variable
 N = 1;
 T = 20; % number of seconds desired for allocation
 
 time = zeros(T*1000/TIME_STEP,1);
 gyro_data = zeros(T*1000/TIME_STEP,3);
 compass_data = zeros(T*1000/TIME_STEP,3);
 lidar_F_data = zeros(T*1000/TIME_STEP,1);
 lidar_R_data = zeros(T*1000/TIME_STEP,1);
 position_data = zeros(T*1000/TIME_STEP,3);
 angle_data = zeros(T*1000/TIME_STEP,1);
 %velocity_data = zeros(T*1000/TIME_STEP,6);
 motor_L_velocity = zeros(T*1000/TIME_STEP,1);
 motor_R_velocity = zeros(T*1000/TIME_STEP,1);
 
 
% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
%
% Need to call wb robot step periodically to communicate to the simulator;
while wb_robot_step(TIME_STEP) ~= -1
  
   time(N) = wb_robot_get_time();
   
  % Run a motor by velocity rad/sec;
   if time(N) < 5
       wb_motor_set_velocity(motor_R, -3);
       wb_motor_set_velocity(motor_L, -3);
   elseif time(N) < 10
       wb_motor_set_velocity(motor_R, -3);
       wb_motor_set_velocity(motor_L, 0);
   elseif time(N) < 15
       wb_motor_set_velocity(motor_R, 1);
       wb_motor_set_velocity(motor_L, 2);
   else
       wb_motor_set_velocity(motor_R, -1);
       wb_motor_set_velocity(motor_L, -3);
   end
  
  % Read sensor data;
   compass_value = wb_compass_get_values(compass);
   compass_data(N,:) = compass_value;
   
   gyro_value = wb_gyro_get_values(gyro);
   gyro_data(N,:) = gyro_value;
   
   lidar_F_data(N) = wb_distance_sensor_get_value(lidar_F);
   lidar_R_data(N) = wb_distance_sensor_get_value(lidar_R);
   
  
  
  % Get ground truth data;
   position = wb_supervisor_node_get_position(robot);
   position_data(N,:) = position;
   
   angle = wb_supervisor_field_get_sf_rotation(rotation);
   angle_data(N,:) = angle(4);
   
   %velocity = wb_supervisor_node_get_velocity(robot);
   %velocity_data(N,:) = velocity;
   
   motor_L_velocity(N) = wb_motor_get_velocity(motor_L);
   motor_R_velocity(N) = wb_motor_get_velocity(motor_R);
   
  % End loop 20 seconds into simulation
   if time(N) > 20
       break;
   end
   
   
   N = N + 1;
  
  
end



% Save data to file
filename = 'D:\Documents\Webots data Niravroh\lab3 paperbot path 1 Niravroh attempt 3.csv';
TT = table(time,lidar_F_data,lidar_R_data,compass_data,gyro_data,position_data,angle_data,motor_L_velocity,motor_R_velocity);
writetable(TT,filename);



 
% cleanup code goes here: write data to files, etc.
wb_robot_cleanup();

