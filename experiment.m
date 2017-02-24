 clear all;
A = 0.54;
B = 0.26;

a_bin = Fr_dec2bin(A);
b_bin = Fr_dec2bin(B);
notfinished = 1; notfinished2 = 1; j = 0; k = 0;
while(notfinished)
if ((2^(-j) < A) )%&& (notfinished > 0))
    b = mod(A,2^(-j));
    shifts = j;
    display('b')
    notfinished = 0;   
else 
    j = j+1;
end
end


while(notfinished2)
if ((2^(-k) < b) )%&& (notfinished > 0))
    b2 = mod(b,2^(-k));
    shifts2 = k;
    display('b2')
    notfinished2 = 0;   
else 
    k = k+1;
end
end

display(shifts);
    display('b_bin')
        display(shifts2)
            display('b_bin')


    
