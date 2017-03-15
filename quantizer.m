function [store2] = quantizer(bits, block)

if block == 1;
    A = textread('binary4block2.txt', '%s');
    A2 = textread('binary4block3.txt', '%s');
elseif block == 2;
     A = textread('binary4channel2.txt', '%s');
    A2 = textread('binary4channel3.txt', '%s');
        
end

    
B = cell2mat(A);
B2 = cell2mat(A2);
l = length(A);


for ara = 1:l;
    store = Fr_bin2dec(B(ara,:));
    
    if (B2((ara*bits)-bits+1,1) == '1');
        if(store == 0)
            store = 0.0000000000000000000001;
            store2(ara) = (-1)*store;
        else
            
            store2(ara) = (-1)*store;
        end
        
        
    else
        if(store == 0)
            store = 0.0000000000000000000001;
        store2(ara) = store;
        else 
            
        store2(ara) = store;
        end
    end
   
end

%Fr_bin2dec('store')