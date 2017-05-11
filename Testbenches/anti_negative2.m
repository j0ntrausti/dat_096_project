function [out] = anti_negative2(in)


%in = binarybucket1;

lengd = length(in);
k = in;

for a = 1:lengd
   
    if a == 1
        array(a) = 1;
        if(in(a) == '1')
            array(a+1) = 0;
        else
            array(a+1) = 1;
        end

    elseif (in(a) == '1')
            middle = 0; array(a+1) = middle;
    else 
            middle = 1; array(a+1) = middle;
    end
end



   out = array(1:10); 
   i = 1-1;
   
if array(lengd) == 1
   array(lengd) = 0;
   i = i+1;
   if(array(lengd-1) == 1)
       array(lengd-1) = 0;
        i = i+1;
       if array(lengd-2) == 1;
        array2(lengd-2) = 0;
         i = i+1;
            if(array(lengd-3) == 1);
                 array(lengd-3) = 0;
                  i = i+1;
                 if(array(lengd-4) == 1);
                 array(lengd-4) = 0;
                  i = i+1;
                 if(array(lengd-5) == 1);
                 array(lengd-5) = 0;
                  i = i+1;
                 if(array(lengd-6) == 1);
                 array(lengd-6) = 0;
                  i = i+1;
                 if(array(lengd-7) == 1);
                 array(lengd-7) = 0;
                  i = i+1;
                 if(array(lengd-8) == 1);
                 array(lengd-8) = 0;
                  i = i+1;
                 if(array(lengd-9) == 1);
                 array(lengd-9) = 0;
                  
                 
                 
                 end
                 end
                 end
                 end
                 end
                 end
            end
       end
   end
end


array(lengd-i) = 1;


out2 = array(1:10);
                 
                 
                 
                 
                 
                 
                