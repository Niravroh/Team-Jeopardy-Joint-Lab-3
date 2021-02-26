%Linda Zaragoza
%Joint Lab 3 Webots Simulation
% 2/21/21

%desktop;
%keyboard;

%Use timestep from analytical sim
TIME_STEP = 10; %10 ms

%create instances of motor sensors, nodes
motor_R = wb_robot_get_device('motor_R'); % device names must be char, not string
motor_L = wb_robot_get_device('motor_L');

compass = wb_robot_get_device('compass');
gyro = wb_robot_get_device('gyro');
lidar_R = wb_robot_get_device('lidar_R');
lidar_F = wb_robot_get_device('lidar_F');

robot = wb_supervisor_node_get_from_def('robot'); %for ground truth access
rotation = wb_supervisor_node_get_field(robot,'rotation');
%enable sensors (instance, sampling period (ms)
wb_compass_enable(compass, TIME_STEP);
wb_gyro_enable(gyro,TIME_STEP);
wb_distance_sensor_enable(lidar_R,TIME_STEP);
wb_distance_sensor_enable(lidar_F,TIME_STEP);
%make the motors non-position control mode
wb_motor_set_position(motor_R, inf);
wb_motor_set_position(motor_L,inf);

time = 0;
k = 1;

%need to call wb_robot_step periodically to communicate to the simulator
while wb_robot_step(TIME_STEP) ~= -1
  %run a motor by velocity rad/s
  wb_motor_set_velocity(motor_R,-4);%right motor
  wb_motor_set_velocity(motor_L,-10);%left motor
  %read motor velocities
  lv = wb_motor_get_velocity(motor_L);
  rv = wb_motor_get_velocity(motor_R);
  %read sensor data
  compass_data = wb_compass_get_values(compass);
  gyro_data = wb_gyro_get_values(gyro);
  lidar_R_data = wb_distance_sensor_get_value (lidar_R);
  lidar_F_data = wb_distance_sensor_get_value (lidar_F);
  %get ground truth data
  position = wb_supervisor_node_get_position(robot);
  angle = wb_supervisor_field_get_sf_rotation(rotation);
  velocity = wb_supervisor_node_get_velocity(robot);
  
  timearr(k,1) = time;
  lidarRarr(k,1) = lidar_R_data;
  lidarFarr(k,1) = lidar_F_data;
  compassarr(k,:) = compass_data; 
  gyroarr(k,:) = gyro_data;
  lvarr(k,:) = lv;
  rvarr(k,:) = rv; 
  positionarr(k,:) = position;
  anglearr(k,:) = angle;
  velocityarr(k,:) = velocity; 
  
  %wb_console_print(sprintf('%8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f \n', size(timearr,1), size(lidarRarr,1), size(lidarFarr,1),size(compassarr,1), size(gyroarr,1), size(positionarr,1), size(anglearr,1), size(velocityarr,1)), WB_STDOUT);
  
  time = time + TIME_STEP;
  k = k + 1;
  
  if time == 10000 + TIME_STEP % in ms, can change to desired length of sim
    filename = 'C:\Users\OWNER1\Documents\lab3controllerresults.xlsx';
    T = table(timearr, lidarFarr, lidarRarr, gyroarr, compassarr, lvarr, rvarr, positionarr, anglearr, velocityarr);
    writetable(T,filename,'Sheet',1); %change sheet number according to trajectory
  end  
 
end

%close your controller
wb_robot_cleanup();
