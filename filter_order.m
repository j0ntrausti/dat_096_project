%% different formulas, for estimation of filter order
% writer: Jon Trausti Kristmundsson (jontrausti22@gmail.com)
clear all
close all
%stuff
prompt = 'How much decimation for block?';
x = input(prompt);
prompt = 'How much decimation for channel?';
y = input(prompt);

k = 1000; % factors
M = 1000000; % factors
R = 48; % sampling vs. message freq. ratio

ap = 0.5; % dB peak passband ripple max amount
as = 65; % dB stopband attenuation min amount

dp = 1 - 10^(-ap/20); %ripple in passband, need to find good figure
ds = 10^(-as/20); %dB suppresion in the stop band
ft = [6*M/x 6*M/(y)]; %R*f_c; % at least....
fs = [125*k 18.75*k] ;
    
fp = [118.75*k 12.5*k];  %  rate(Hz) possible 118.75



% Keiser

N_kay = (-20*log10(sqrt(dp*ds))-13)./(14.6.*(fs-fp)./(ft));

% Bellanger

N_Bell = (-(2*log10(10*ds*dp))./(3.*(fs-fp)./(ft)))-1;

% Hartmann (slighty more accurate)

a1 = 0.005309; a2 = 0.07114; a3 = -0.4761;
a4 = 0.00266; a5 = 0.5941; a6 = 0.4278;

b1 = 11.01217; b2 = 0.51244;

%to make sure the statement is always true
if(ds > dp)
    i = dp;
    dp = ds;
    ds = i;
end

D = (a1*log10(dp)^2 + a2*log10(dp) + a3)*log10(ds) - (a4*log10(dp)^2 + a5*log10(dp) + a6);


F = b1 + b2*( log10(dp) - log10(ds) );
N_hard = (D-F.*((fs-fp)./(ft)).^2)./((fs-fp)./(ft));




    display('Keiser')
    display(N_kay)
    display('Bellanger')
    display(N_Bell)
    display('Hartmann')
    display(N_hard)

    

   
