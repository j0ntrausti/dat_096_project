 clear all
 close all

% This file was created by the ultimate matmaster JT

A = textread('test.txt', '%s');
B = cell2mat(A);


for i = 1:8196;
    for j = 1:10;
        array = B(i,j); 
        array2 = str2num(array);
        array3(i,j) = array2;
       
    end
end


for k = 1:8196;
    if(array3(k,1) == 1);
        array3(k,1) = 0;
    else
        array3(k,1) = 1;
    end
end


fileID = fopen('testseq.txt','w');
for g = 1:8196;
    %for h = 1:10;
    out4 = num2str(array3(g,:));
    %ArrayBlock(i) = binarybucket1;
    
     fprintf(fileID,'%s \n', out4);
    %end
    
end    
fclose(fileID);

