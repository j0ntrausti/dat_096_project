function [out] = anti_negative(in)



lengd = length(in);
k = in;

for k = 1:lengd
   
    if (in(k) == '1')
            middle = 0; array(k) = middle;
    else 
            middle = 1; array(k) = middle;
    end
    
end

   out = array; 
   