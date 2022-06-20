%% Author : Ravi Ashok Pashchapur

clc
clear all;
close all;
% Load Mat file
load result.mat

% Plot the true and predicted jammer state 'x' and 'y'
figure
yline(x_t_vec(1),'r--');
hold on
plot(x_state(1,:),'r');
yline(x_t_vec(2),'b--');
plot(x_state(2,:),'b');
xlim([50 1800])
legend('x True position','x Estimate position','y True position','y Estimate position')
xlabel('Time step')
ylabel('Jammer position [m]')
title('True and Predicted Jammer State x and y')

% Plot of True and Estimate Measurement 
figure
plot(P_r_filt_ratio(:,1),'r');
hold on
plot(h(1,:),'b--');
xlim([50 1800])
legend('True Measurement','Estimate Measurement')
xlabel('Time step')
ylabel('Measurement')
title('True and Predicted Measurement')

%Plot Innovation
figure
plot(Innovation(1,:))
hold on
yline(0)
xlim([50 1800])
legend('UKF Innovation')
xlabel('Time step')
ylabel('Innovation')
title('Innovation for Particle Filter')


