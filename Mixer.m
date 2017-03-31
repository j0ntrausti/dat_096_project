clc
clf
clear all
close all

f_b0 = 1.125e6;
f_b1 = 1.375e6;
f_b2 = 1.625e6;
f_b3 = 1.875e6;

t_delta = 1.70012811127392000000e-07;
stop = 0.0009369825;
Fs = 1/t_delta;

t = 0:t_delta:stop;
l = length(t);

s_b0 = exp(-1i*2*pi*f_b0.*t);
s_b1 = exp(1i*2*pi*f_b1.*t);
s_b2 = exp(1i*2*pi*f_b2.*t);
s_b3 = exp(1i*2*pi*f_b3.*t);

testvector = transpose(xlsread('sim_in_6'));
sim_out_b0_r = transpose(xlsread('sim_out_6_bl0_r'));
sim_out_b0_i = transpose(xlsread('sim_out_6_bl0_i'));

block_0 = s_b0.*testvector(1:l); 

F = block_0;

y = fft(F,l);
m = abs(y);
f = (0:length(y)-1)*Fs/length(y); 

    figure(2)
    subplot(2,1,1); plot(t,F);
    subplot(2,1,2); plot(f,m);
    title('Matlab out')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
F = sim_out_b0_r(1:l)+ 1i.*sim_out_b0_i(1:l);

y = fft(F,l);
m = abs(y);
f = (0:length(y)-1)*Fs/length(y);  

    figure(3)
    subplot(2,1,1); plot(t,real(F));
    subplot(2,1,2); plot(f,m);
    title('questa out')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')

F = testvector(1:l);
    
y = fft(F,l);
m = abs(y);
f = (0:length(y)-1)*Fs/length(y); 

    figure(4)
    subplot(2,1,1); plot(t,real(F));
    subplot(2,1,2); plot(f,m);
    title('testvector')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')

