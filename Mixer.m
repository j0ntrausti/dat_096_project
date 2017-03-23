clc
clf
clear all
close all

f_b0 = 1.125e6;
f_b1 = 1.375e6;
f_b2 = 1.625e6;
f_b3 = 1.875e6;

t_delta = 1.71611e-8;

t = 0:t_delta:0.0009369825;

s_b0 = exp(1i*f_b0*t);
s_b1 = exp(1i*f_b1*t);
s_b2 = exp(1i*f_b2*t);
s_b3 = exp(1i*f_b3*t);

plot(t,real(s_b0))
hold on
plot(t,imag(s_b0), 'm')

num = xlsread(Svens_extended_vector)
