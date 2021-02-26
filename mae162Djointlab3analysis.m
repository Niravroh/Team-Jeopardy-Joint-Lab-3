clear all; close all; clc;

%% Trajectory Analysis for Joint Lab 3
% What's left to do as of 2/25/21 10.37 PM: Need to figure out where to
% pull left and right wheel angular velocities. Need to check units of sim data and do
% conversions. Once data is gathered, make sure format matches & change
% field and duration to suit sim (segway v paperbot). Other than that,i think the comparison & plots
% should be good.

%Set up parameters
sampleFrequency = 0.01;
fontSize = 20;
lineWidth = 5;
duration = 10;  %change per sim
field = 10000; % in mm
set(groot, 'defaultTextInterpreter','latex');

%Get data from excel files
truetable = readtable('analytical.xls'); %replace filename with correct file path
simtable = readtable('webots.xls');
true = table2array(truetable);
sim = table2array(simtable);

%Specify data sets
true_t = true(:,1);
true_lv = true(:,2);
true_rv = true(:,3);
true_x = true(:,4)*10;
true_y = true(:,5)*10;
true_theta = true(:,6);

r_true_x = resample(true_x, true_t, 1/sampleFrequency, 1, 1);
r_true_y = resample(true_y, true_t, 1/sampleFrequency, 1, 1);
r_true_theta = resample(true_theta, true_t, 1/sampleFrequency, 1, 1);
r_true_t = (sampleFrequency*(0:size(r_true_x,1)-1))';
r_true_x = r_true_x(1:size(r_true_x,1)-1);
r_true_y = r_true_y(1:size(r_true_y,1)-1);
r_true_t = r_true_t(1:size(r_true_t,1)-1);
r_true_theta = r_true_theta(1:size(r_true_theta,1)-1);
r_true_theta = wrapTo2Pi(r_true_theta)-3*pi/2;

sim_t = sim(:,1);
sim_lv = sim(:,   )  %not sure how to get lv rv from sim data
sim_rv = sim(:,   )
sim_x = sim(:,10);  %component 1 of position, global x
sim_y = sim(:,12);  %component 3 of position, global y
sim_theta = sim(:,16);
sim_lidarF = sim(:,2);
sim_lidarR = sim(:,3);
sim_gyro = sim(:,5);    %component 2 of gyro, global z
sim_compassx = sim(:,7); %component 1 of compass, global x
sim_compassy = sim(:,9);    %component 3 of compass, global y

%Plot results
figure(1)
subplot(1,3,1)
plot(r_true_t,r_true_x,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("X Displacement (mm)");
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,2);
plot(sim_T,sim_X,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Webots Simulation");
xlabel("Time (s)");
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,3);
percent_error_X = abs(r_true_x - sim_X([1:size(r_true_x,1)]))./r_true_x;
plot(r_true_t,percent_error_X,'LineWidth', lineWidth);
xlim([0,duration]);
%ylim([0,20]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
set(gca,'Fontsize',fontSize);

set(gcf,'position',[0,0,1200,400])

figure(2);
subplot(1,3,1);
plot(r_true_t,r_true_y,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("Y Displacement (mm)");
grid on;
set(gca,'Fontsize',fontSize);
set(gcf,'position',[0,0,1200,400])

subplot(1,3,2);
plot(sim_T,sim_Y,'LineWidth', lineWidth);
xlim([0,duration]);
ylim([0,field]);
title("Webots Simulation");
xlabel("Time (s)");
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,3);
percent_error_Y = abs(r_true_y - sim_Y([1:size(r_true_y,1)]))./r_true_y;
plot(r_true_t,percent_error_Y,'LineWidth', lineWidth);
xlim([0,duration]);
%ylim([0,20]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
set(gca,'Fontsize',fontSize);


figure(3);
subplot(1,3,1);
plot(r_true_t,rad2deg(r_true_theta),'LineWidth', lineWidth);
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
plot(sim_T,rad2deg(sim_Theta),'LineWidth', lineWidth);
xlim([0,duration]);
ylim([-180,180]);
title("Webots Simulation");
xlabel("Time (s)");
yticks([-180,-135,-90,-45,0,45,90,135,180]);
grid on;
set(gca,'Fontsize',fontSize);

subplot(1,3,3);
percent_error_lv = abs(abs(r_true_theta - sim_Theta([1:size(r_true_theta,1)]))./r_true_theta);
plot(r_true_t,percent_error_lv,'LineWidth', lineWidth);
xlim([0,duration]);
%ylim([0,20]);
title("Percent Error");
xlabel("Time (s)");
ylabel("Percent Error (\%)");
grid on;
set(gca,'Fontsize',fontSize);

figure(4)
subplot(1,3,1);
plot(true_t, -true_lv,'g','LineWidth', lineWidth);
hold on;
plot(true_t, -true_rv,'r','LineWidth', lineWidth);
title("Analytical Simulation");
xlabel("Time (s)");
ylabel("Angular Velocity (degrees/s)");
legend('Left Wheel', 'Right Wheel');
grid on;

subplot(1,3,2);
plot(sim_t, -sim_lv,'g','LineWidth', lineWidth);
hold on;
plot(sim_t, -sim_rv,'r','LineWidth', lineWidth);
title("Webots Simulation");
xlabel("Time (s)");
ylabel("Angular Velocity (degrees/s)");
legend('Left Wheel', 'Right Wheel');
grid on;
set(gcf,'position',[0,0,1000,400])

subplot(1,3,3);
percent_error_lv = abs(abs(r_true_lv - sim_lv([1:size(r_true_lv,1)]))./r_true_lv);
percent_error_rv = abs(abs(r_true_rv - sim_rv([1:size(r_true_rv,1)]))./r_true_rv);
plot(r_true_t,percent_error_lv,'LineWidth', lineWidth);
hold on;
plot(r_true_t,percent_error_rv,'LineWidth', lineWidth);
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
plot(sim_t, sim_lidarF)
title('Front Lidar Output')
xlabel('Time (s)');

subplot(2,3,2)
plot(sim_t, sim_lidarR)
title('Right Lidar Output')
xlabel('Time (s)');

subplot(2,3,3)
plot(sim_t, sim_gyro)
title('Gyro Output')
xlabel('Time (s)');

subplot(2,3,4)
plot(sim_t, sim_compassx)
title('Compass X Output')
xlabel('Time (s)');

subplot(2,3,5)
plot(sim_t, sim_compassy)
title('Compass Y Output')
xlabel('Time (s)');
