function f = tournament_selection(chromosome,pool_size,tour_size)

% function selection_individuals(chromosome,pool_size,tour_size) is the
% selection policy for selecting the individuals for the mating pool. The
% selection is based on tournament selection. Argument 'chromosome' is the
% current generation population from which the individuals are selected to 
% form a mating pool of size 'pool_size' after performing tournament 
% selection, with size of the tournament being 'tour_size'. By varying the 
% tournament size the selection pressure can be adjusted

%该函数的目的是通过锦标赛选择（每次从种群中随机抽两个，选较好一个）构成父代群体个数

[pop,variables] = size(chromosome);
rank = variables - 1;                                                       %共variables列，第variables-1列为排序值，第variables列为拥挤度值
distance = variables;

for i = 1 : pool_size                                                       %用于交叉变异的父代群体个数
    for j = 1 : tour_size                                                   %选择个数，一般为2
        candidate(j) = round(pop*rand(1));
        if candidate(j) == 0
            candidate(j) = 1;
        end
        if j > 1
            while ~isempty(find(candidate(1 : j - 1) == candidate(j)))
                candidate(j) = round(pop*rand(1));
                if candidate(j) == 0
                    candidate(j) = 1;                                      %candidate中元素不相等，且不能为0
                end
            end
        end
    end
    for j = 1 : tour_size
        c_obj_rank(j) = chromosome(candidate(j),rank);                      %随机选择的第candidate(j)个个体（即chromosome矩阵的candidate(j)行）
        c_obj_distance(j) = chromosome(candidate(j),distance);              %第rank列表示排序值，第distance列表是拥挤度，见前定义
    end
    min_candidate = ...
        find(c_obj_rank == min(c_obj_rank));           %find函数得到非0元素的序号构成的向量
    if length(min_candidate) ~= 1                      %不等于1说明两个个体排序值（适应度值）相同，此时min_candidate =[1 2]表明第1与2个选择
        max_candidate = ...                            %个体相等，都等于最小排序值
        find(c_obj_distance(min_candidate) == max(c_obj_distance(min_candidate))); %注意得到的max_candidate表示是min_candidate中的指示
        if length(max_candidate) ~= 1
            max_candidate = max_candidate(1);
        end
        f(i,:) = chromosome(candidate(min_candidate(max_candidate)),:);
    else
        f(i,:) = chromosome(candidate(min_candidate(1)),:); %rank值小的优先胜出，如若有相同的，再比拥挤度值；拥挤度值大的，胜出
    end
end