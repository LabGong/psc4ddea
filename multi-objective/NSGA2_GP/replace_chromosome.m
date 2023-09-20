function f  = replace_chromosome(intermediate_chromosome,pop)
%% replace_chromosome(intermediate_chromosome,pro,pop)
% This function replaces the chromosomes based on rank and crowding
% distance. Initially until the population size is reached each front is
% added one by one until addition of a complete front which results in
% exceeding the population size. At this point the chromosomes in that
% front is added subsequently to the population based on crowding distance.

[N,L] = size(intermediate_chromosome);
rank = L - 1;   
distance = L;

% Get the index for the population sort based on the rank
[temp,index] = sort(intermediate_chromosome(:,rank));

% Now sort the individuals based on the index
for i = 1 : N
    sorted_chromosome(i,:) = intermediate_chromosome(index(i),:);
end

% Find the maximum rank in the current population
max_rank = max(intermediate_chromosome(:,rank));

% Start adding each front based on rank and crowing distance until the
% whole population is filled.
previous_index = 0;
for i = 1 : max_rank                                                        %find�����ҵ���Ӧ��ֵ����i�����и�����ţ��Ӷ�max�ɵù��ж���
    current_index = max(find(sorted_chromosome(:,rank) <= i));         %�����㷨��������Ӧ�øĳ�current_index = max(find(sorted_        
    if current_index > pop                                                  %                         chromosome(:,M + V + 1) <= i))                                                
        remaining = pop - previous_index;
        temp_pop = ...
            sorted_chromosome(previous_index + 1 : current_index, :);
        [temp_sort,temp_sort_index] = ...
            sort(temp_pop(:, distance),'descend');
        for j = 1 : remaining
            f(previous_index + j,:) = temp_pop(temp_sort_index(j),:);
        end
        return;
    elseif current_index < pop                                    
        f(previous_index + 1 : current_index, :) = ...                      %���С����Ⱥ����pop���ù�����f���������
            sorted_chromosome(previous_index + 1 : current_index, :);       %���㷨�����⣬���뱣֤��һ������current_index������һ�����ò���
    else
        f(previous_index + 1 : current_index, :) = ...                     
            sorted_chromosome(previous_index + 1 : current_index, :);       
        return;
    end
    previous_index = current_index;
end