% Design a lowpass filter with a passband-edge frequency of 1500Hz, a 
 %      stopband-edge of 2000Hz, passband ripple of 0.01, stopband ripple 
 %      of 0.1, and a sampling frequency of 8000Hz:
 clear all;
 close all;
 
k = 1000; % factors
M = 1000000; % factors
R = 48; % sampling vs. message freq. ratio

ap = 0.5; % dB peak passband ripple max amount
as = 65; % dB stopband attenuation min amount

dp = 1 - 10^(-ap/20); %ripple in passband, need to find good figure
ds = 10^(-as/20); %dB suppresion in the stop band

ft = 6*M ; %R*f_c; % at least....
ft2 = 250*k;

fs = 200*k;
fs2 = 18.75*k;
    
fp = 125*k ;
fp2 = 12.5*k; %  rate(Hz) possible 118.75
 
 
% Pretty straightforward, dno what the [1 0] means, prob if the filter is
% recursive :S
[n,fo,mo,w] = firpmord( [fp fs], [1 0], [dp ds], ft );
[n2,fo2,mo2,w2] = firpmord( [fp2 fs2], [1 0], [dp ds], ft2 );


% The n + 12, means that we need 12 additional coeff. to what the function
% calculated to fulfill our specs. b1 = block filter, b2 = channel filter
b = firpm(n+20,fo,mo,w);
b2 = firpm(n2+7,fo2,mo2,w2);

N_block = n+20;
N_channel = n2+7;

fvtool(b);
fvtool(b2);

fileID = fopen('binary4block.txt','w');
for i = 1:length(b) 
    binarybucket1 = Fr_dec2bin(b(i));
    if b(i) < 0 
                out = anti_negative(binarybucket1);
    end
    if b(i) > 0 
        out = anti_anti_negative(binarybucket1);
    end
    
    out1 = num2str(out);
    %ArrayBlock(i) = binarybucket1;
    fprintf(fileID,'%s\n', out1);
end
fclose(fileID);


fileID2 = fopen('binary4channel.txt','w');

for j = 1:length(b2) 
    binarybucket2 = Fr_dec2bin(b2(j));
    if b2(j) < 0 
        out3 = anti_negative(binarybucket2);
    end
    if b2(j) > 0 
        out3 = anti_anti_negative(binarybucket2);
    end
    
    out4 = num2str(out3);
    %ArrayBlock(i) = binarybucket1;
    
    fprintf(fileID2,'%s \n', out4);
end    
fclose(fileID2);

 [pathstr,name,ext] = fileparts('binary4channel.txt') 