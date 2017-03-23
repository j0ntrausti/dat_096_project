clc
clf
clear all
close all

f_b0 = 1.125e6;
f_b1 = 1.375e6;
f_b2 = 1.625e6;
f_b3 = 1.875e6;

t_delta = 1.71611e-8;
stop = 0.000009369825;
Fs = 1/t_delta;

l=2^15;
%t = 0:t_delta:stop;
t = (0:l-1)*t_delta;
%l = length(t);

s_b0 = exp(1i*f_b0*t);
s_b1 = exp(1i*f_b1*t);
s_b2 = exp(1i*f_b2*t);
s_b3 = exp(1i*f_b3*t);

% plot(t,real(s_b0))
% hold on


testvector = transpose(xlsread('Svens_extended_vector'));
sim_out_b0_r = transpose(xlsread('sim_out_bl0_r'));

%plot(t,testvector(1:l), 'm')

block_0 = s_b0.*testvector(1:l);

%complex multiplication:
%block_0_r = testvector(1:l).*real(s_b0);

%block_0_i = testvector(1:l).*imag(s_b0);

plot(t(1:l),sim_out_b0_r(1:l))
hold on
plot(t(1:l),block_0, 'm')

F = real(block_0);

YF = fft(F);
    P2 = abs(YF/l);
    P1 = P2(1:l/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(l/2))/(l);
    

    figure(2)
    subplot(2,1,1); plot(t,F);
    subplot(2,1,2); plot(f,P1);
    title('Matlab out')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
F = sim_out_b0_r(1:l);
    
YF = fft(F);
    P2 = abs(YF/l);
    P1 = P2(1:l/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(l/2))/(l);

    figure(3)
    subplot(2,1,1); plot(t,F);
    subplot(2,1,2); plot(f,P1);
    title('Questa out')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')
    
F = testvector(1:l);
    
YF = fft(F);
    P2 = abs(YF/l);
    P1 = P2(1:l/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    f = Fs*(0:(l/2))/(l);

    figure(4)
    subplot(2,1,1); plot(t,F);
    subplot(2,1,2); plot(f,P1);
    title('Svens')
    xlabel('f (Hz)')
    ylabel('|P1(f)|')

