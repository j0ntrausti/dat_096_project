clc
clf
clear all
close all

%block mixing frequencies @4M
f_b0 = 1.125e6;
f_b1 = 1.375e6;
f_b2 = 1.625e6;
f_b3 = 1.875e6;

%channel mixing frequencies @250k
f_c0 = -125e3;
f_c1 = -93.75e3;
f_c2 = -62.5e3;
f_c3 = -31.25e3;
f_c5 =  31.25e3;
f_c6 =  62.5e3;
f_c7 =  93.75e3;

Fs_1 = 5e6;
stop = 0.023;
t_delta_1 = 1/Fs_1;
t_1 = 0:t_delta_1:stop;
l_1 = length(t_1);

Fs_2 = 312500;
t_delta_2 = 1/Fs_2;
t_2 = 0:t_delta_2:stop;
l_2 = length(t_2);


s_b0 = exp(-1i*2*pi*f_b0.*t_1);
s_b1 = exp(-1i*2*pi*f_b1.*t_1);
s_b2 = exp(-1i*2*pi*f_b2.*t_1);
s_b3 = exp(-1i*2*pi*f_b3.*t_1);


s_c0 = exp(-1i*2*pi*f_c0.*t_1);
s_c1 = exp(-1i*2*pi*f_c1.*t_1);
s_c2 = exp(-1i*2*pi*f_c2.*t_1);
s_c3 = exp(-1i*2*pi*f_c3.*t_1);
s_c5 = exp(-1i*2*pi*f_c5.*t_1);
s_c6 = exp(-1i*2*pi*f_c6.*t_1);
s_c7 = exp(-1i*2*pi*f_c7.*t_1);

s_c0_2 = exp(-1i*2*pi*f_c0.*t_2);
s_c1_2 = exp(-1i*2*pi*f_c1.*t_2);
s_c2_2 = exp(-1i*2*pi*f_c2.*t_2);
s_c3_2 = exp(-1i*2*pi*f_c3.*t_2);
s_c5_2 = exp(-1i*2*pi*f_c5.*t_2);
s_c6_2 = exp(-1i*2*pi*f_c6.*t_2);
s_c7_2 = exp(-1i*2*pi*f_c7.*t_2);

 testvector = transpose(xlsread('sim_out_19_5M','F:F'));
 ch_0_r = transpose(xlsread('sim_out_19_5M','AM:AM')); %Channel 0
 ch_0_i = transpose(xlsread('sim_out_19_5M','AL:AL')); %Channel 0
 ch_1_r = transpose(xlsread('sim_out_19_5M','AK:AK')); %Channel 1
 ch_1_i = transpose(xlsread('sim_out_19_5M','AJ:AJ')); %Channel 1
 ch_2_r = transpose(xlsread('sim_out_19_5M','AI:AI')); %Channel 2
 ch_2_i = transpose(xlsread('sim_out_19_5M','AH:AH')); %Channel 2
 ch_3_r = transpose(xlsread('sim_out_19_5M','AG:AG')); %Channel 3
 ch_3_i = transpose(xlsread('sim_out_19_5M','AF:AF')); %Channel 3
 ch_4_r = transpose(xlsread('sim_out_19_5M','AE:AE')); %Channel 4
 ch_4_i = transpose(xlsread('sim_out_19_5M','AD:AD')); %Channel 4
 ch_5_r = transpose(xlsread('sim_out_19_5M','AC:AC')); %Channel 5
 ch_5_i = transpose(xlsread('sim_out_19_5M','AB:AB')); %Channel 5
 ch_6_r = transpose(xlsread('sim_out_19_5M','AA:AA')); %Channel 6
 ch_6_i = transpose(xlsread('sim_out_19_5M','Z:Z')); %Channel 6
 ch_7_r = transpose(xlsread('sim_out_19_5M','Y:Y')); %Channel 7
 ch_7_i = transpose(xlsread('sim_out_19_5M','X:X')); %Channel 7
% sim_out_b0_i = transpose(xlsread('sim_out_12_4M','E:E')); %imag part of block 0 from sim
% sim_out_b0_dec_r = transpose(xlsread('sim_out_12_250k','F:F')); %real part of block 0 dec from sim
% sim_out_b0_dec_i = transpose(xlsread('sim_out_12_250k','E:E')); %imag part of block 0 dec from sim
% sim_out_ch5_r = transpose(xlsread('sim_out_12_250k','H:H')); %real part of channel 5 in block 0 from sim
% sim_out_ch5_i = transpose(xlsread('sim_out_12_250k','G:G')); %real part of channel 5 in block 0 from sim
dac_in_r =transpose(xlsread('sim_out_19_5M','C:C'));
dac_in_i =transpose(xlsread('sim_out_19_5M','D:D'));

%block_0 = s_b0.*testvector(1:l_1); %matlab mixing of testvector to block0
%ch_5 = s_c5.*block_0; %matlab mixing of testvector to ch5
%ch_5_2 = (sim_out_b0_dec_r(1:l_2) + 1i*sim_out_b0_dec_i(1:l_2)).*s_c0_2; %matlab mixing of the dec block 0 from questa to ch 5

%% plotting of the testvector @6M
    
F =  testvector(1:l_1);
    
y = fft(F,l_1);
m = abs(y);
f = (0:length(y)-1)*Fs_1/length(y); 

    figure(1)
    subplot(2,1,1); plot(t_1,real(F));
    subplot(2,1,2); plot(f,m);
    title('testvector')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%% plotting of the output @6M
    
F =  dac_in_r(1:l_1) + 1i*dac_in_i(1:l_1);

y = fft(F,l_1);
m = abs(y);
f = (0:length(y)-1)*Fs_1/length(y); 

    figure(2)
    subplot(2,1,1); plot(t_1,real(F));
    subplot(2,1,2); plot(f,m);
    title('Questa final output')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%% plotting of the questa mixed channel 0

F = ch_1_r(1:l_2) + 1i.*ch_1_i(1:l_2);

y = fft(F,l_2);
m = abs(y);
f = (0:length(y)-1)*Fs_2/length(y);  

    figure(3)
    subplot(2,1,1); plot(t_2,real(F));
    subplot(2,1,2); plot(f,m);
    title('channel 0')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    

%% plotting of the matlab mixed block @6M
F = dac_in_r(1:l_1) + 1i*dac_in_i(1:l_1);

y = fft(F,l_1);
m = abs(y);
f = (0:length(y)-1)*Fs_1/length(y); 

    figure(2)
    subplot(2,1,1); plot(t_1,F);
    subplot(2,1,2); plot(f,m);
    title('block 0 Matlab')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%% plotting of the questa mixed block @6M

F = sim_out_b0_r(1:l_1)+ 1i.*sim_out_b0_i(1:l_1);

y = fft(F,l_1);
m = abs(y);
f = (0:length(y)-1)*Fs_1/length(y);  

    figure(3)
    subplot(2,1,1); plot(t_1,real(F));
    subplot(2,1,2); plot(f,m);
    title('block 0 questa')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%% plotting of the questa mixed and dec block @250k

F = sim_out_b0_dec_r(1:l_2)+ 1i.*sim_out_b0_dec_i(1:l_2);

y = fft(F,l_2);
m = abs(y);
f = (0:length(y)-1)*Fs_2/length(y);  

    figure(4)
    subplot(2,1,1); plot(t_2,real(F));
    subplot(2,1,2); plot(f,m);
    title('block 0 dec questa')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%% plotting of the questa mixed ch @250k

F = sim_out_ch5_r(1:l_2)+ 1i.*sim_out_ch5_i(1:l_2);

y = fft(F,l_2);
m = abs(y);
f = (0:length(y)-1)*Fs_2/length(y);  

    figure(5)
    subplot(2,1,1); plot(t_2,real(F));
    subplot(2,1,2); plot(f,m);
    title('ch0 questa')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
%% plotting of the matlab mixed ch5 @6M
F = ch_5;

y = fft(F,l_1);
m = abs(y);
f = (0:length(y)-1)*Fs_1/length(y); 

    figure(6)
    subplot(2,1,1); plot(t_1,F);
    subplot(2,1,2); plot(f,m);
    title('ch0 matlab')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')

%% plotting of the matlab mixed ch5 @250k
F = ch_5_2;

y = fft(F,l_2);
m = abs(y);
f = (0:length(y)-1)*Fs_2/length(y); 

    figure(7)
    subplot(2,1,1); plot(t_2,F);
    subplot(2,1,2); plot(f,m);
    title('ch0 matlab')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
