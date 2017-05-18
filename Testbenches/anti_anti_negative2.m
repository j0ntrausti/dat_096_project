function [out] = anti_anti_negative(in)



 


for a = 1:length(in);
   
    if a == 1 
        array(a) = 0;
        if(in(a) == '1')
            array(a+1) = 1;
        else
            array(a+1) = 0;
        end
    elseif(in(a) == '1')
            middle = 1; array(a+1) = middle;
    else 
            middle = 0; array(a+1) = middle;
    end
    
end

   out = array(1:10); 
   