clear all; close all; clc;

%% Trajectory Analysis for Joint Lab 3
% What's left to do as of 2/26/21 9.45 AM: Make sure code/data format matches & change
% field and duration to suit sim (segway v paperbot). 
%Other than that,i think the comparison & plots should be good. All units
%in mm, deg, or unitless

%Set up parameters
sampleFrequency = 0.01;
fontSize = 20;
lineWidth = 5;
duration = 10;  %change per sim
field = 10000; % in mm
set(groot, 'defaultTextInterpreter','latex');

%Get data from excel files
anatable = readtable('analytical.xls'); %replace filename with correct file path
webtable = readtable('webots.xls');
ana = table2array(anatable);
web = table2array(webtable);

%Specify data sets
ana_t = ana(:,1);
ana_lv = ana(:,2);
ana_rv = ana(:,3);
ana_x = ana(:,4)*10;
ana_y = ana(:,5)*10;
ana_theta = ana(:,6);

r_ana_x = resample(ana_x, ana_t, 1/sampleFrequency, 1, 1);
r_ana_y = resample(ana_y, ana_t, 1/sampleFrequency, 1, 1);
r_ana_theta = resample(ana_theta, ana_t, 1/sampleFrequency, 1, 1);
r_ana_t = (sampleFrequency*(0:size(r_ana_x,1)-1))';
r_ana_x = r_ana_x(1:size(r_ana_x,1)-1);
r_ana_y = r_ana_y(1:size(r_ana_y,1)-1);
r_ana_t = r_ana_t(1:size(r_ana_t,1)-1);
r_ana_theta = r_ana_theta(1:size(r_ana_theta,1)-1);
r_ana_theta = wrapTo2Pi(r_ana_theta)-3*pi/2;

web_t = web(:,1)*0.001; %ms to s
web_lv = web(:,10)*180/2/pi;    %rad/s to deg/s
web_rv = web(:,11)*180/2/pi;
web_x = web(:,12)*1000;  %component 1 of position (global x); m to mm
web_y = web(:,14)*1000;  %component 3 of position (global y); m to mm
web_theta = web(:,18); %rad
web_lidarF = web(:,2)*10/4096*1000;  %to mm
web_lidarR = web(:,3)*10/4096*1000; %to mm
web_gyro = web(:,5)*180/2/pi;    %component 2 of gyro (global z); rad/s to deg/s
web_compassx = web(:,7); %component 1 of compass (global x); unitless
web_compassy = web(:,9);    %component 3 of compass (global y); 

%Plot results
figure(1)
subplot(1,3,1)
plot(r_ana_t,r_ana_x,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("X Displacement (mm)");
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,2);
plot(web_t,web_x,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Webots Simulation");
xlabel("Time (s)");
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,3);
percent_error_X = abs(r_ana_x - sim_X([1:size(r_ana_x,1)]))./r_ana_x;
plot(r_ana_t,percent_error_X,'LineWidth', lineWidth);
xlim([0,duration]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
set(gca,'Fontsize',fontSize);

set(gcf,'position',[0,0,1200,400])

figure(2);
subplot(1,3,1);
plot(r_ana_t,r_ana_y,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("Y Displacement (mm)");
grid on;
set(gca,'Fontsize',fontSize);
set(gcf,'position',[0,0,1200,400])

subplot(1,3,2);
plot(web_t,web_y,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Webots Simulation");
xlabel("Time (s)");
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,3);
percent_error_Y = abs(r_ana_y - sim_Y([1:size(r_ana_y,1)]))./r_ana_y;
plot(r_ana_t,percent_error_Y,'LineWidth', lineWidth);
xlim([0,duration]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
set(gca,'Fontsize',fontSize);


figure(3);
subplot(1,3,1);
plot(r_ana_t,rad2deg(r_ana_theta),'LineWidth', lineWidth);
xlim([0,duration]);
ylim([-180,180]);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("Angular Displacement (degrees)");
yticks([-180,-135,-90,-45,0,45,90,135,180]);
grid on;
set(gca,'Fontsize',fontSize);
set(gcf,'position',[0,0,1200,400])

subplot(1,3,2);
plot(web_t,rad2deg(web_theta),'LineWidth', lineWidth);
xlim([0,duration]);
ylim([-180,180]);
title("Webots Simulation");
xlabel("Time (s)");
yticks([-180,-135,-90,-45,0,45,90,135,180]);
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,3);
percent_error_lv = abs(abs(r_ana_theta - web_theta([1:size(r_ana_theta,1)]))./r_ana_theta);
plot(r_ana_t,percent_error_lv,'LineWidth', lineWidth);
xlim([0,duration]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
set(gca,'Fontsize',fontSize);

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
set(gcf,'position',[0,0,1000,400])

subplot(1,3,3);
percent_error_lv = abs(abs(r_true_lv - web_lv([1:size(r_true_lv,1)]))./r_true_lv);
percent_error_rv = abs(abs(r_true_rv - web_rv([1:size(r_true_rv,1)]))./r_true_rv);
plot(r_ana_t,percent_error_lv,'LineWidth', lineWidth);
hold on;
plot(r_ana_t,percent_error_rv,'LineWidth', lineWidth);
xlim([0,duration]);
%ylim([0,20]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
legend('Left Wheel', 'Right Wheel');
grid on;
set(gca,'Fontsize',fontSize);

figure(5)
subplot(2,3,1)
plot(web_t, web_lidarF)
title('Front Lidar Output')
xlabel('Time (s)');
ylabel ('Distance to Wall (mm)')

subplot(2,3,2)
plot(web_t, web_lidarR)
title('Right Lidar Output')
xlabel('Time (s)');
ylabel ('Distance to Wall (mm)')

subplot(2,3,3)
plot(web_t, web_gyro)
title('Gyro Output')
xlabel('Time (s)');
ylabel ('Angular Velocity (deg/s)')

subplot(2,3,4)
plot(web_t, web_compassx)
title('Compass X Output')
xlabel('Time (s)');
ylabel ('Magnitude')

subplot(2,3,5)
plot(web_t, web_compassy)
title('Compass Y Output')
xlabel('Time (s)');
ylabel ('Magnitude')
