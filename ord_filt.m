clear all
close all

k = 1000; % factors
M = 1000000; % factors
R = 48; % sampling vs. message freq. ratio

ap = 1.0; % dB peak passband ripple max amount
as = 60; % dB stopband attenuation min amount

dp = 1 - 10^(-ap/20); %ripple in passband, need to find good figure
ds = 10^(-as/20); %dB suppresion in the stop band

ft = 100*M/17 ; %R*f_c; % at least....
ft2 = 250*k;

fs = 131.75*k;
fs2 = 18.75*k;

bits = 16;
    
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

% the nr. of oefficients
N_block = n+20;
N_channel = n2+7;

% Few things that make the txt files clearer,
comma = ';';
brackets = '"';
sth = 't(';
brah = ')<=';
broh = '.';

fileID = fopen('binary4block.txt','w'); % use this for coeff. 
fileID2 = fopen('binary4block2.txt','w');

fileID3 = fopen('binary4block3.txt','w');
for i = 1:length(b) 
    binarybucket1 = Fr_dec2bin(b(i));
    if b(i) < 0 
        out = anti_negative(binarybucket1);
    end
    if b(i) >= 0 
        out = anti_anti_negative(binarybucket1);
    end
    
    out1 = num2str(out(1:bits));
    out69 = binarybucket1(1);
    out70 = binarybucket1(2:bits);
    %ArrayBlock(i) = binarybucket1;
    fprintf(fileID,'%s%d%s%s%s%s%s \n', sth, (i-1), brah, brackets,out1,brackets,comma);
    fprintf(fileID3,'%s \n', out1);
    fprintf(fileID2,'%s%s%s%s%s\n%','',out69,broh,out70,'');     
end
fclose(fileID);
fclose(fileID2);
fclose(fileID3);

error = quantizer(bits,1);
fvtool(b,1,error,1);

fileID11 = fopen('binary4channel.txt','w'); % use this for coeff
fileID22 = fopen('binary4channel2.txt','w');
fileID33 = fopen('binary4channel3.txt','w');
for j = 1:length(b2) 
    binarybucket2 = Fr_dec2bin(b2(j));
    if b2(j) < 0 
        out3 = anti_negative(binarybucket2);
    end
    if b2(j) > 0 
        out3 = anti_anti_negative(binarybucket2);
    end
    
    out4 = num2str(out3(1:bits));
    out71 = binarybucket2(1);
    out72 = binarybucket2(2:bits);
    %ArrayBlock(i) = binarybucket1;
    
    fprintf(fileID11,'%s%d%s%s%s%s%s \n', sth, (j-1), brah, brackets,out4,brackets,comma);
     fprintf(fileID33,'%s \n', out4);
     fprintf(fileID22,'%s%s%s%s%s\n%','',out71,broh,out72,'');
end    
fclose(fileID11);
fclose(fileID22);
fclose(fileID33);
error2 = quantizer(bits,2);
fvtool(b2,1,error2,1);
%[pathstr,name,ext] = fileparts('binary4channel.txt')