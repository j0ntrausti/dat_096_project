%% MATLAB Simulations for DAT096 project course
% Made by: Jón Trausti Kristmundsson
% Date: 29.01.2017
% Purpose: To see if multi stage filter can
%          give higher SNR ratio vs. Single stage.
%          Also possible examine other filter types.  

% ideas: Look into tunable LP filters?? CIC filters???


%% JANITOR
clear all
close all
%% FACTORS
k = 1000;
M = 1000000;
R = 48; %(sampling vs. message freq. 
%% SPECS
f_c = 125*k; % sampling rate(Hz)
f_sampling = 6*M; %R*f_c; % at least....
d_1 =10^(-4); %ripple in passband, need to find good figure
d_2 =10^(-6);  % -70 dB suppresion in the stop band
delta_f= f_c / 2; %transition width

bits = 1;
downplay_single_stage = [24];
downplay_multi_stage = [4 2 2]; % or 8 2 

%% For linear phase FIR filter
% lolz
N_LP = 2/3*log10(1/(10*d_1 * d_2)) * (f_sampling/delta_f);

Tabs_LP_ss = N_LP / downplay_single_stage;
f_samplingnew_ss = f_sampling/downplay_single_stage;

% not sure how to implement the multi-stage calc. this is the first attempt
% the sampling frq. is correct, though all the other part might be
% incorrect!!!! fx. I would assume having mpl filters the transition width
% might be bigger, or that the ripple effects are morely neglectable then
% before. 





    display('true')
    display('Without decimation tabs')
    display(N_LP)
    display('With single-stage decimation')
    display(Tabs_LP_ss)






