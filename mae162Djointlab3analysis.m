clear all; close all; clc;

%% Trajectory Analysis for Joint Lab 3
%  Make sure code/data format matches, other than that,i think the comparison & plots should be good. All units in m, deg, or unitless

%Set up parameters
lineWidth = 5;

%Get data from excel files
anatable = readtable('C:\Users\OWNER1\Downloads\Hayato_SegwayData\segway_data2_analyticalSim.csv'); %replace filename with correct file path
webtable = readtable('C:\Users\OWNER1\Downloads\Hayato_SegwayData\segway_data2_webotsSim.csv');
ana = table2array(anatable);
web = table2array(webtable);

%Specify data sets
ana_t = ana(:,1)*.001;  %ms to s
ana_lv = ana(:,2)*180/2/pi;  %rad/s to deg/s
ana_rv = ana(:,3)*180/2/pi;
ana_x = ana(:,4);   %m
ana_y = ana(:,5);
ana_theta = ana(:,6);   %deg
ana_lidarF = ana(:,7)*10/4096;  %to m
ana_lidarR = ana(:,8)*10/4096;
ana_gyro = ana(:,9)*180/2/pi;   %rad/s to deg/s
ana_compassx = ana(:,10);
ana_compassy = ana(:,11);

web_t = web(:,1)*.001; %ms to s
web_lv = web(:,2)*180/2/pi;    %rad/s to deg/s
web_rv = web(:,3)*180/2/pi;
web_x = web(:,4);  %component 1 of position (global x); m
web_y = web(:,5);  %component 3 of position (global y); m
web_theta = web(:,6); %deg
web_lidarF = web(:,7)*10/4096;  %to m
web_lidarR = web(:,8)*10/4096; 
web_gyro = web(:,9);    %component 2 of gyro (global z); deg/s
web_compassx = web(:,10); %component 1 of compass (global x); unitless
web_compassy = web(:,11);    %component 3 of compass (global y); 

%Plot results
figure(1)
subplot(2,2,1)
plot(ana_t,ana_x,'LineWidth', lineWidth);
hold on;
plot(web_t,web_x,'LineWidth', lineWidth);
title("X Displacement");
xlabel("Time (s)");
ylabel("Displacement (m)");
legend ('Analytical', 'Webots')
grid on;

subplot(2,2,2);
percent_error_X = abs(abs(ana_x - web_x)./ana_x);
plot(ana_t,percent_error_X,'LineWidth', lineWidth);
title("X Displacement Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

subplot(2,2,3);
plot(ana_t,ana_y,'LineWidth', lineWidth);
hold on;
plot(web_t,web_y,'LineWidth', lineWidth);
title("Y Displacement");
xlabel("Time (s)");
ylabel("Displacement (m)");
legend ('Analytical','Webots')
grid on;

subplot(2,2,4);
percent_error_Y = abs(abs(ana_y - web_y)./ana_y);
plot(ana_t,percent_error_Y,'LineWidth', lineWidth);
title("Y Displacement Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

figure(3);
subplot(1,2,1);
plot(ana_t,ana_theta,'LineWidth', lineWidth);
hold on;
plot(web_t,web_theta,'LineWidth', lineWidth);
title("Angular Displacement");
xlabel("Time (s)");
ylabel("Displacement (degrees)");
yticks([-315,-270,-225,-180,-135,-90,-45,0,45,90,135,180,225,270,315]);
legend('Analytical','Webots')
grid on;

subplot(1,2,2);
percent_error_lv = abs(abs(ana_theta - web_theta)./ana_theta);
plot(ana_t,percent_error_lv,'LineWidth', lineWidth);
title("Angular Displacement Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

figure(4)
subplot(1,3,1);
plot(ana_t, -ana_lv,'g','LineWidth', lineWidth);
hold on;
plot(ana_t, -ana_rv,'r','LineWidth', lineWidth);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("Angular Velocity (degrees/s)");
legend('Left Wheel', 'Right Wheel');
grid on;

subplot(1,3,2);
plot(web_t, -web_lv,'g','LineWidth', lineWidth);
hold on;
plot(web_t, -web_rv,'r','LineWidth', lineWidth);
title("Webots Simulation");
xlabel("Time (s)");
ylabel("Angular Velocity (degrees/s)");
legend('Left Wheel', 'Right Wheel');
grid on;

subplot(1,3,3);
percent_error_lv = abs(abs(ana_lv - web_lv)./ana_lv);
percent_error_rv = abs(abs(ana_rv - web_rv)./ana_rv);
plot(ana_t,percent_error_lv,'LineWidth', lineWidth);
hold on;
plot(ana_t,percent_error_rv,'LineWidth', lineWidth);
title("Wheel Velocity Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
legend('Left Wheel', 'Right Wheel');
grid on;

figure(5)
subplot(2,2,1)
plot(ana_t, ana_lidarF)
hold on;
plot(web_t, web_lidarF)
title('Front Lidar Output')
xlabel('Time (s)');
ylabel ('Distance to Wall (m)')
legend('Analytical','Webots')
grid on;

subplot(2,2,2)
percent_error_lidarF = abs(abs(ana_lidarF - web_lidarF)./ana_lidarF);
plot(ana_t,percent_error_lidarF,'LineWidth', lineWidth);
title("Front Lidar Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

subplot(2,2,3)
plot(ana_t,ana_lidarR)
hold on;
plot(web_t, web_lidarR)
title('Right Lidar Output')
xlabel('Time (s)');
ylabel ('Distance to Wall (m)')
legend('Analytical','Webots')
grid on;

subplot(2,2,4)
percent_error_lidarR = abs(abs(ana_lidarR - web_lidarR)./ana_lidarR);
plot(ana_t,percent_error_lidarR,'LineWidth', lineWidth);
title("Right Lidar Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

figure (6)
subplot(1,2,1)
plot(ana_t, ana_gyro)
hold on;
plot(web_t, web_gyro)
title('Gyro Output')
xlabel('Time (s)');
ylabel ('Angular Velocity (degrees/s)')
legend('Analytical','Webots')
grid on;

subplot(1,2,2)
percent_error_gyro = abs(abs(ana_gyro - web_gyro)./ana_gyro);
plot(ana_t,percent_error_gyro,'LineWidth', lineWidth);
title("Gyro Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

figure (7)
subplot(2,2,1)
plot(ana_t, ana_compassx)
hold on;
plot(web_t, web_compassx)
title('Compass X Output')
xlabel('Time (s)');
ylabel ('Magnitude')
legend('Analytical','Webots')
grid on;

subplot(2,2,2)
percent_error_compassx = abs(abs(ana_compassx - web_compassx)./ana_compassx);
plot(ana_t,percent_error_compassx,'LineWidth', lineWidth);
title("Compass X  Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;

subplot(2,2,3)
plot(ana_t,ana_compassy)
hold on;
plot(web_t, web_compassy)
title('Compass Y Output')
xlabel('Time (s)');
ylabel ('Magnitude')
legend('Analytical','Webots')
grid on;

subplot(2,2,4)
percent_error_compassy = abs(abs(ana_compassy - web_compassy)./ana_compassy);
plot(ana_t,percent_error_compassy,'LineWidth', lineWidth);
title("Compass Y Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
