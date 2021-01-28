function [out] = anti_negative(in)

%in = binarybucket1;

lengd = length(in);
k = in;

for a = 1:lengd
   
    if (in(a) == '1')
            middle = 0; array(a) = middle;
    else 
            middle = 1; array(a) = middle;
    end
    
end

   out = array; 
   