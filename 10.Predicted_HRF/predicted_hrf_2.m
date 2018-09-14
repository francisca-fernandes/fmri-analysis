%% Difference of two gamma functions hrf proposed by Glover (1999)

%% Clear all workspaces
clear all;
close all;

%% Set the parameter values of the hrf
% a = 0.3; % Constant between 0 and 1, which measures the magnitude of the negative dip.
% n1 = 5; lambda1 = 2; n2 = 7; lambda2 = 2;
a = 0.3; n1 = 2; lambda1 = 0.5; n2 = 2; lambda2 = 1; % 1

a = 0.16; n1 = 2; lambda1 = 0.9; n2 = 13; lambda2 = 0.6; % hrf1
a = 0.187; n1 = 2; lambda1 = 1.15; n2 = 13; lambda2 = 0.615; % hrf2
a = 0.214; n1 = 2; lambda1 = 1.4; n2 = 13; lambda2 = 0.648; % hrf3
% a = 0.239; n1 = 2; lambda1 = 1.65; n2 = 13; lambda2= 0.69; % hrf4
% a = 0.261; n1 = 2; lambda1 = 1.9; n2 = 13; lambda2 = 0.737; % hrf5
% a = 0.280; n1 = 2; lambda1 = 2.15; n2 = 13; lambda2 = 0.788; % hrf6
% a = 0.297; n1 = 2; lambda1 = 2.4; n2 = 13; lambda2 = 0.840; % hrf7
% a = 0.311; n1 = 2; lambda1 = 2.65; n2 = 13; lambda2 = 0.894; % hrf8
% a = 0.324; n1 = 2; lambda1 = 2.9; n2 = 13; lambda2 = 0.95; % hrf9

%% Define the time axis, i.e., from 0 to 20 sec in .01 sec increments
thrf = 0.01:0.01:20;

% Create the hrf (one gamma function primarily models the early peak in the hrf, another gamma function primarily models the late dip)
hrf = (thrf.^(n1-1)).*exp(-thrf/lambda1)/((lambda1^n1)*factorial(n1-1))-a*(thrf.^(n2-1)).*exp(-thrf/lambda2)/((lambda2^n2)*factorial(n2-1));
C = trapz(thrf, hrf); % Integral of the hrf, in order to guarantee that the area under the hrf is 1.
hrf = hrf/C;
% C = trapz(thrf, hrf) % Check that hrf is normalized

% Plot the hrf
figure(1); plot(thrf,hrf); hold on;
xlabel('Time (s)'); ylabel('h(t)');
title('Hemodynamic response function');

%% Define the boxcar function (boxcar models of hypothetical neural activation that persist for 20 seconds)
tbox = 0.01:0.01:340;
box = [zeros(1,4000),ones(1,2000), zeros(1,4000),ones(1,2000), zeros(1,4000),ones(1,2000), zeros(1,4000),ones(1,2000), zeros(1,4000),ones(1,2000), zeros(1,4000)];

% Compute the convolution. Divide by 100 to set time unit at .01 sec
tBOLD=0.01:0.01:(length(thrf)+length(tbox)-1)/100;
BOLD = conv(box,hrf)/100;

% Plot the predicted BOLD response
figure(2);
hold on;plot(tBOLD,BOLD);axis([0 (length(hrf)+length(box)-1)/100 -0.5 1.5]); hold on;
set(gcf,'Position',[1,457,1280,241]);
xlabel('Time (s)');
ylabel('h(t) \ast Paradigm');

%% Calculate peaks and time-of-peak
[~,i]=max(hrf);i*0.01-0.01 % tpeak (hrf)
[h,i]=max(BOLD);i*0.01-0.01-40 % tpeak (BOLD)
h % peak (BOLD)

%% Define the boxcar function (boxcar model of hypothetical neural activation that persists for 20 seconds)
tbox = -20+0.01:0.01:60;
box = [zeros(1,2000),ones(1,2000), zeros(1,4000)];

% Compute the convolution. Divide by 100 to set time unit at .01 sec
tBOLD=-20+0.01:0.01:(length(thrf)+length(tbox)-1)/100-20;
BOLD = conv(box,hrf)/100;

% Plot the predicted BOLD response
figure(3);
hold on;plot(tBOLD,BOLD);axis([-20 60 -0.5 1.5]); hold on;
xlabel('Time Post-Stimulus (s)');
ylabel('h(t) \ast Paradigm');
a1=plot(tbox,box,'Color','k');
legend(a1,{'Paradigm'},'FontSize',12,'Location','northeast');