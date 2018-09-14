%% Gamma function hrf proposed by Boynton et al. (1996)

% Clear all workspaces
clear all;
close all;

% Set the parameter values of the hrf
T0 = 0; % Lag between stimulus presentation and the initial rise in the BOLD response
n = 4; lambda = 2; % Determine the shape of the hrf

% peak = T0+(n-1)*lambda; % Peak of the hrf

% Define the time axis, i.e., from 0 to 30 sec in .01 sec increments
thrf = 0:0.01:30;

% Create the hrf
hrf = ((thrf-T0).^(n-1)).*exp(-(thrf-T0)/lambda)/((lambda^n)*factorial(n-1));
% C = trapz(thrf, hrf); % Check that hrf is normalized

% Plot the hrf
figure(1); plot(thrf,hrf); axis([0 30 0 0.12]);

% Define the boxcar function (boxcar models of hypothetical neural
% activation that persist for 10 seconds)
tbox = 0:0.01:60;
box = [ones(1,1001), zeros(1,5000)];

% Compute the convolution. Divide by 100 to set time unit at .01 sec
tBOLD=0:0.01:((length(hrf)+length(box)-1)-1)/100;
BOLD = conv(box,hrf)/100;

% Plot the predicted BOLD response
figure(2); plot(tBOLD,BOLD,tbox,box);axis([0 ((length(hrf)+length(box)-1)-1)/100 -0.5 1.5]);

% As the duration of the neural activation increases, the predicted BOLD
% response grows in magnitude. Once saturation is reached, the BOLD
% response remains at this high level as long as the neural activation
% persists. After the neural activation ceases, the BOLD response slowly
% decays back to its baseline level.