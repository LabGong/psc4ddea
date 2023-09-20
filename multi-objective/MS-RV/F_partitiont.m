function [partition] = F_partitiont(x, univec)
%function to perform population partition

%input: x - decision vectors
%output: class - the partition of the population

clear partition;
[m n] = size(x);
[unim unin] = size(univec); 

unix = zeros(m,n);
for i = 1:m
    unix(i,:) = x(i,:)./norm(x(i,:));
end;


cosine = zeros(m, unim);

%calculate cosine values
for i = 1:m
    for j = 1:unim
        cosine(i,j) = sum(unix(i,:).*univec(j,:));
    end;
end

%classification
partition = struct('c',cell(1,unim)); 

for i = 1:m
    nearest = find(cosine(i,:) == max(cosine(i,:)), 1);    %返回第一个非0元素的索引
    partition(nearest).c = [partition(nearest).c, i];
end;

for i = 1:unim
    select = partition(i).c;
    if length(select)<2
       dis = cosine(:,i);
       [~,ind] = sort(dis,'descend');
       partition(i).c = ind(1:2);
    end
end

end
    
    