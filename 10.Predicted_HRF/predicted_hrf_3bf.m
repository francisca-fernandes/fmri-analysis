%% Difference of two gamma functions hrf proposed by Glover (1999)

% Clear all workspaces
clear all;

% Set the parameter values of the hrf
teta1 = 100;
teta2 = -20;
teta3 = -5;


% Define the time axis, i.e., from 0 to 30 sec in .01 sec increments
thrf = 0:0.01:40;

% Create the hrf (one gamma function primarily models the early peak in the
% hrf, another gamma function primarily models the late dip)
b1 = 1/factorial(3)*thrf.^3.*exp(-thrf);
b2 = 1/factorial(7)*thrf.^7.*exp(-thrf);
b3 = 1/factorial(15)*thrf.^15.*exp(-thrf);
hrf = teta1*b1+teta2*b2+teta3*b3;
C = trapz(thrf, hrf); % Integral of the hrf, in order to guarantee that the area under the hrf is 1.
hrf = hrf/C;
% C = trapz(t60, hrf) % Check that hrf is normalized

% Plot the hrf
figure(1); plot(thrf,hrf);

% Define the boxcar function (boxcar models of hypothetical neural
% activation that persist for 10 seconds)
tbox = 0:0.01:60;
box = [ones(1,1001), zeros(1,5000)];

% Compute the convolution. Divide by 100 to set time unit at .01 sec
tBOLD=0:0.01:((length(hrf)+length(box)-1)-1)/100;
BOLD = conv(box,hrf)/100;

% Plot the predicted BOLD response
figure(2); plot(tBOLD,BOLD,tbox,box);