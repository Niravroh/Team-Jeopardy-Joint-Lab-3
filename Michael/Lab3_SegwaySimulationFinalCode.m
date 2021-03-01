%% Segway Simulation
%% Initialization of Devices, Nodes, Variables, and Constants
TIME_STEP = wb_robot_get_basic_time_step();
currentTime = 0;
i = 1;
motor_R = wb_robot_get_device('motor_R');
motor_L = wb_robot_get_device('motor_L'); % Device names have to be char, not string;
compass = wb_robot_get_device('compass');
gyro = wb_robot_get_device('gyro');
lidar_R = wb_robot_get_device('lidar_R');
lidar_F = wb_robot_get_device('lidar_F');
robot = wb_supervisor_node_get_from_def('robot'); % For ground truth access;
rotation = wb_supervisor_node_get_field(robot,'rotation');


%% Enabling Sensors and Motors
wb_compass_enable(compass, TIME_STEP);
wb_gyro_enable(gyro,TIME_STEP);
wb_distance_sensor_enable(lidar_R,TIME_STEP);
wb_distance_sensor_enable(lidar_F,TIME_STEP);
wb_motor_set_position(motor_R, inf);
wb_motor_set_position(motor_L, inf);

%% Trajectory Specifications
while wb_robot_step(TIME_STEP) ~=-1
time_data_array(i, 1) = currentTime;
% Run a motor by velocity rad/sec;
if currentTime < 2500;
wb_motor_set_velocity(motor_R, 0);
wb_motor_set_velocity(motor_L, 2);
elseif currentTime < 5000
wb_motor_set_velocity(motor_R, -2);
wb_motor_set_velocity(motor_L, -2);
elseif currentTime < 7500
wb_motor_set_velocity(motor_R, 2);
wb_motor_set_velocity(motor_L, 0);
elseif currentTime < 10000
wb_motor_set_velocity(motor_R, 1);
wb_motor_set_velocity(motor_L, -1);
end

velocity_L = wb_motor_get_velocity(motor_L);
velocity_R = wb_motor_get_velocity(motor_R);

% Or run a motor by torque N/m (Unused)
%wb_motor_set_torque(motor_R,-1);
%wb_motor_set_torque(motor_L,-1);

%% Obtain Data from Sensors and Robot
compass_data = wb_compass_get_values(compass);
gyro_data = wb_gyro_get_values(gyro);
lidar_R_data = wb_distance_sensor_get_value(lidar_R);
lidar_F_data = wb_distance_sensor_get_value(lidar_F);
position = wb_supervisor_node_get_position(robot);
angle = wb_supervisor_field_get_sf_rotation(rotation);
velocity = wb_supervisor_node_get_velocity(robot);

%% Store Data
lidar_R_data_array(i, 1) = lidar_R_data;
lidar_F_data_array(i, 1) = lidar_F_data;
compass_data_array(i, :) = compass_data;
gyro_data_array(i, :) = gyro_data;
velocity_L_data_array(i, :) = velocity_L;
velocity_R_data_array(i, :) = velocity_R;
position_array(i, :) = position;
angle_array(i, :) = angle;
velocity_array(i, :) = velocity;


currentTime = currentTime + TIME_STEP; %Continue to Next Iteration
i = i + 1;

if currentTime == 10000 + TIME_STEP %Store Data Into Spreadsheet
    filename = 'C:\Users\micha\Documents\JointLab3_SegwaySimulationResults\SegwaySimResults.xlsx';
    T = table(time_data_array, lidar_R_data_array, lidar_F_data_array, gyro_data_array, compass_data_array, velocity_L_data_array, velocity_R_data_array, position_array, angle_array, velocity_array);
    writetable(T,filename,'Sheet',3)
  end  

end
wb_robot_cleanup();