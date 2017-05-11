clc
clear all
close all

%% Up part 
f_b0 = 1.125e6; % Block 0 mixing frequency
f_c5 = 31250; % Channel 5 mixing frequency

%G = D + 1i * E;

Fs = 5.88e6; % Sampling rate
t_delta = 1/Fs;
l=2^15; %32748 samples
t = (0:l-1)*t_delta;

s_b5  = cos(2*pi*f_b0*t); %exp(1i*2*pi*f_b0*t); % Mix up by 1.125 MHz, block 0
s_c5 = cos(2*pi*f_c5*t); %exp(1i*2*pi*f_c5*t); % Mix up by 31250 kHz, channel 5

F = 3125+717.7734/2+ 717.7734*11;% signal frequency, 11379 Hz, ch 5, bl 0

block_0 = s_b5.*cos(2*pi*t.*F); % Block Mix


d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',600,0.3901360544217,0.394557823129,0.3996598639455,0.40816326);
Hd = design(d,'equiripple');
y = filter(Hd,block_0);





channel_5 = s_c5.*y; % Channel Mix

% d = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',600,0.3901360544217,0.394557823129,0.3996598639455,0.40816326);
% Hd = design(d,'equiripple');
% y = filter(Hd,block_0);
dd = fdesign.bandpass('N,Fst1,Fp1,Fp2,Fst2,C',600,0.377360544217,0.394557823129,0.40816326,0.50816326);
Hdd = design(dd,'equiripple');
yy = filter(Hdd,channel_5);


X = fft(yy);

% plotting the up part
f = (0:l-1)*(Fs/l);     %frequency range
power = abs(X).^2/l;    %power
figure(1)
subplot(2,1,1)
plot(t,yy)
title('Up mixing')
xlabel('t (s)')
ylabel('|x(t)|')
subplot(2,1,2)
plot(f,power)
xlabel('f (Hz)')
ylabel('|X(f)|')
%%

output = yy(2769:l);
l2 = length(output)
X = fft(output);

f2 = (0:length(output)-1)*(Fs/l2);     %frequency range
t2 = (0:length(output)-1)*t_delta;
power = abs(X).^2/l2;    %power
figure(2)
subplot(2,1,1)
plot(t2,output)
title('Up mixing')
xlabel('t (s)')
ylabel('|x(t)|')
subplot(2,1,2)
plot(f2,power)
xlabel('f (Hz)')
ylabel('|X(f)|')

channel_i5 = round((0.9* 2^10 -1).*real(output)); %abs(channel_5.^2/2);

%% convert to vector to binary
% binary 1 is to be used as input to vivado
% binary 2 and 3 is to be used for further MATLAB analyse

%broh = '.';
bits = 10;
fileID11 = fopen('binary4.txt','w'); % use this for coeff
% fileID22 = fopen('binary2.txt','w');
% fileID33 = fopen('binary3.txt','w');
for j = 1:length(channel_i5) 
    %binarybucket2 = dec2bin(channel_i5(1,j));
    
    if channel_i5(1,j) < 0 
        binarybucket2 = dec2bin(-1*channel_i5(1,j),10);
        out3 = anti_negative2(binarybucket2);      
    end
    
    if channel_i5(1,j) >= 0 
        binarybucket2 = dec2bin(channel_i5(1,j),10);
        out3 = anti_anti_negative2(binarybucket2);
    end
    
    out4 = num2str(out3(1:bits));
%     out71 = binarybucket2(1);
%     out72 = binarybucket2(2:bits);
    %ArrayBlock(i) = binarybucket1;
    
     fprintf(fileID11,'%s \n', out4);
%      fprintf(fileID22,'%s%s%s%s%s\n%','',out71,broh,out72,'');
end    
fclose(fileID11);
% fclose(fileID22);
% fclose(fileID33);


%AS = textread('newtestseq.txt','%s');




%% Down part - theoretical part
Fs = 5.88e6; % Sampling rate
t_delta = 1/Fs;
l=30000; %32748 samples
t2 = (0:l2-1)*t_delta;

d_b0 = exp(-1i*2*pi*f_b0*t2); % Mix down by 1.125 MHz, block 0
d_c5 = exp(-1i*2*pi*31250*t2); % Mix down by 31250 kHz, channel 5

block_d0 = d_b0.*channel_i5; % Block Mix
channel_d5 = d_c5.*block_d0; % Channel Mix

Y = fft(channel_d5);

% plotting  the down theoretical part part
f2 = (0:l2-1)*(Fs/l2);     %frequency range
powerd = abs(Y).^2/l2;    %power
figure(3)
subplot(3,1,1)
plot(t2,channel_d5)
xlabel('t (s)')
ylabel('|y(t)|')
title('Theoretical down mixing')
subplot(3,1,2)
plot(f2,powerd)
xlabel('f (Hz)')
ylabel('|Y(f)|')
subplot(3,1,3)
plot(t2,channel_i5)

%% down part from Vivado (takes in decimal)



D = textread('real.txt', '%d')';
E = textread('img.txt', '%d')';
l = length(D);

Fs = 5.88e6; % Sampling rate
t_delta = 1/Fs;
l=8195; %32748 samples
t = (0:l-1)*t_delta;



G = D + 1i * E;

dd_b0 = exp(1i*2*pi*f_b0*t);
dd_c5 = exp(-1i*2*pi*f_c5*t);

block_dd0 = dd_b0.*G(1:l);
channel_dd5 = dd_c5.*G(1:l);


F = G(1:l);
    
YF = fft(F);
YQ = fft(G(1:l));
f = (0:l-1)*(Fs/l);     %frequency range
power = abs(YF).^2/l;    %power
power2 = abs(YQ).^2/l;
figure(3)
plot(f,power) 
hold on
plot(f,power2) 
hold off
Y = fftshift(YF);
Y2 = fftshift(YQ);
fshift = (-l/2:l/2-1)*(Fs/l); % zero-centered frequency range
powershift = abs(Y).^2/l;     % zero-centered power
powershift2 = abs(Y2).^2/l;
figure(4)
plot(fshift,powershift) 
hold on
plot(fshift,powershift2) 
hold off
legend('Jons testvector mixed in Vivado');
xlabel('f (Hz)')
ylabel('|P1(f)|')


F = channel_dd5;
YF = fft(F);
f = (0:l-1)*(Fs/l);     %frequency range
power = abs(YF).^2/l;    %power
figure(5)
plot(f,power)
    xlabel('f (Hz)')
ylabel('|X(f)|')



