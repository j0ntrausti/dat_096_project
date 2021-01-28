function [store2] = test2pic()


A = textread('test.txt', '%s');
% 
%     
 B = cell2mat(A);
% B2 = cell2mat(A2);
l = length(A);
% 
% 
for ara = 1:l;
     store = bin2dec(B(ara,:));
%     
     if (B(ara,1) == '1')
            store2(ara) = (-1)*store;
     else
        
            store2(ara) = store;
        
    end
   
 end
% 
% %Fr_bin2dec('store')