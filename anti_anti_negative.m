function [out] = anti_anti_negative(in)



lengd = length(in);
k = in;

for a = 1:lengd
   
    if (in(a) == '1')
            middle = 1; array(a) = middle;
    else 
            middle = 0; array(a) = middle;
    end
    
end

   out = array; 
   