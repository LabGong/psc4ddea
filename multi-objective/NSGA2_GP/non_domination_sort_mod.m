%% Non-Donimation Sort
% This function sort the current popultion based on non-domination. All the
% individuals in the first front are given a rank of 1, the second front
% individuals are assigned rank 2 and so on. After assigning the rank the
% crowding in each front is calculated.
                                                                            
function f = non_domination_sort_mod(x)       
global M;
[N,V] = size(x);
V=V-M;
                                                            
front = 1;

% There is nothing to this assignment, used only to manipulate easily in
% MATLAB.
F(front).f = [];
individual = [];
for i = 1 : N                                                               %N是种群个数
    % Number of individuals that dominate this individual
    individual(i).n = 0;                                                    %individual(i).n为该个体i的被支配数
    % Individuals which this individual dominate
    individual(i).p = [];                                                   %individual(i).p为该个体i所支配的个体集
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M                                                       %一共有M个目标值，越小越好，只有所有目标都小于j时才说支配j
            if (x(i,V + k) < x(j,V + k))                                    %即支配集并上j，只有所有目标都大于j时，才说被j支配即被支配数才加1
                dom_less = dom_less + 1;
            elseif (x(i,V + k) == x(j,V + k))                               %而且需要保证所有目标不是都相等的，如果两个个体所有目标完全
                dom_equal = dom_equal + 1;                                  %相等，或者两个个体互不支配则不改变两个参数，直接往下运行。                                
            else                                                      
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 & dom_equal ~= M                                   
            individual(i).n = individual(i).n + 1;                          %第i个体的被支配数(弱)
        elseif dom_more == 0 & dom_equal ~= M
            individual(i).p = [individual(i).p j];                          %第i个体的支配集
        end
    end   
    if individual(i).n == 0
        x(i,M + V + 1) = 1;                                                 %赋予该第一层i个体适应度值，越小越好
        F(front).f = [F(front).f i];                                        %第一层的个体集合
    end             
end                                                                         %如果第一非支配层为空怎么办？？？？？？没有考虑。加上一条：
% Find the subsequent front                                                 %如果isempty(F(front).f)，则初始化种群失败，重新初始化。
while ~isempty(F(front).f)              %该语句保证直到最后一层为空时，才停止继续分层，否则循环执行                                                  
   Q = [];                                                                  
   for i = 1 : length(F(front).f)                                           %第front非支配层有多少个体i，就循环执行多少次
       if ~isempty(individual(F(front).f(i)).p)                             %individual(F(front).f(i)).p为第front非支配层的第i个体元素的支配集
        	for j = 1 : length(individual(F(front).f(i)).p)                 %第front非支配层的个体中第i个个体有多少支配集元素，就循环执行多少次
            	individual(individual(F(front).f(i)).p(j)).n = ...          %第front非支配层中第i个体的支配集中的第j个元素（个体）的被支配数减1，
                individual(individual(F(front).f(i)).p(j)).n - 1;           %F(front).f(i)表示第front非支配层的第i个元素（即某个体序号）
        	   	if individual(individual(F(front).f(i)).p(j)).n == 0        %选择减1后被支配个数等于0的支配集元素个体作为下一层
               		x(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];                 %构成下一非支配层，注意这里的元素个体都是初始种群的个体序号，而不是原个体
                end
            end                                                             %直至第i个体所有的支配集元素被支配数减1
       end
   end                                                                      %直至第front非支配层所有的个体i被处理
   front =  front + 1;
   F(front).f = Q;
end
[temp,index_of_fronts] = sort(x(:,M + V + 1));                              %将所有个体的适应度值（最小化）按由小到大顺序排列
for i = 1 : length(index_of_fronts)                                         %得到的index向量，其第i个元素为a，表示原第a个元素排列后的顺序号为i 
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);                   %从而得到适应度值由小到大排列的所有个体行，每一行包含代表该个体的                                
end                                                                         %各决策向量值、多个目标函数的估值以及适应度评价值
current_index = 0;
% Find the crowding distance for each individual in each front
for front = 1 : (length(F) - 1)                                             %一共可以构成length(F) - 1个非支配层，有多少个front就有多少个
    objective = [];                                                         %length（F），因为最后一个空，所以减去1
    distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)                                          %第front层中共length(F(front).f)个元素个体
        y(i,:) = sorted_based_on_front(current_index + i,:);                
    end
    current_index = current_index + i;
    % Sort each individual based on the objective
    sorted_based_on_objective = [];
    for i = 1 : M                                                           %一共M个目标函数
        [sorted_based_on_objective, index_of_objectives] = ...
            sort(y(:,V + i));                                               %该front层所有个体的第V+i目标值排序
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);   %得到第front层所有个体在第V+i目标上的排序
        end
        f_max = ...                                                         %第i个目标的最大估计值
            sorted_based_on_objective(length(index_of_objectives), V + i); 
        f_min = sorted_based_on_objective(1, V + i);                        %第i个目标的最小估计值
        y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i) = Inf;                                                          
        y(index_of_objectives(1),M + V + 1 + i) = Inf;                      %将在某目标函数上具有最大、最小目标值的个体在该目标i上拥挤度值付无穷大
         for j = 2 : length(index_of_objectives) - 1                        %M+V+1为适应度值，M+V+1+i是第i个目标对应的拥挤度值
            next_obj  = sorted_based_on_objective(j + 1,V + i);
            previous_obj  = sorted_based_on_objective(j - 1,V + i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + V + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + V + 1 + i) = ...
                     (next_obj - previous_obj)/(f_max - f_min);             %该目标上其他个体的拥挤度值
            end
         end
    end                                                                     %计算出所有M个目标
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
    end
    y(:,M + V + 2) = distance;
    y = y(:,1 : M + V + 2);                                                 %别的列都没用了，只留前V列决策变量值，第V+1到V+M列共M列目标函数值
    z(previous_index:current_index,:) = y;                                  %第V+M+1为该个体（第front层从previous_index到current_index个
end                                                                         %个体）适应度值，第V+M+2为该个体拥挤度值
f = z();