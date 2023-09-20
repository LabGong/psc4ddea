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
for i = 1 : N                                                               %N����Ⱥ����
    % Number of individuals that dominate this individual
    individual(i).n = 0;                                                    %individual(i).nΪ�ø���i�ı�֧����
    % Individuals which this individual dominate
    individual(i).p = [];                                                   %individual(i).pΪ�ø���i��֧��ĸ��弯
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M                                                       %һ����M��Ŀ��ֵ��ԽСԽ�ã�ֻ������Ŀ�궼С��jʱ��˵֧��j
            if (x(i,V + k) < x(j,V + k))                                    %��֧�伯����j��ֻ������Ŀ�궼����jʱ����˵��j֧�伴��֧�����ż�1
                dom_less = dom_less + 1;
            elseif (x(i,V + k) == x(j,V + k))                               %������Ҫ��֤����Ŀ�겻�Ƕ���ȵģ����������������Ŀ����ȫ
                dom_equal = dom_equal + 1;                                  %��ȣ������������廥��֧���򲻸ı�����������ֱ���������С�                                
            else                                                      
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 & dom_equal ~= M                                   
            individual(i).n = individual(i).n + 1;                          %��i����ı�֧����(��)
        elseif dom_more == 0 & dom_equal ~= M
            individual(i).p = [individual(i).p j];                          %��i�����֧�伯
        end
    end   
    if individual(i).n == 0
        x(i,M + V + 1) = 1;                                                 %����õ�һ��i������Ӧ��ֵ��ԽСԽ��
        F(front).f = [F(front).f i];                                        %��һ��ĸ��弯��
    end             
end                                                                         %�����һ��֧���Ϊ����ô�죿����������û�п��ǡ�����һ����
% Find the subsequent front                                                 %���isempty(F(front).f)�����ʼ����Ⱥʧ�ܣ����³�ʼ����
while ~isempty(F(front).f)              %����䱣ֱ֤�����һ��Ϊ��ʱ����ֹͣ�����ֲ㣬����ѭ��ִ��                                                  
   Q = [];                                                                  
   for i = 1 : length(F(front).f)                                           %��front��֧����ж��ٸ���i����ѭ��ִ�ж��ٴ�
       if ~isempty(individual(F(front).f(i)).p)                             %individual(F(front).f(i)).pΪ��front��֧���ĵ�i����Ԫ�ص�֧�伯
        	for j = 1 : length(individual(F(front).f(i)).p)                 %��front��֧���ĸ����е�i�������ж���֧�伯Ԫ�أ���ѭ��ִ�ж��ٴ�
            	individual(individual(F(front).f(i)).p(j)).n = ...          %��front��֧����е�i�����֧�伯�еĵ�j��Ԫ�أ����壩�ı�֧������1��
                individual(individual(F(front).f(i)).p(j)).n - 1;           %F(front).f(i)��ʾ��front��֧���ĵ�i��Ԫ�أ���ĳ������ţ�
        	   	if individual(individual(F(front).f(i)).p(j)).n == 0        %ѡ���1��֧���������0��֧�伯Ԫ�ظ�����Ϊ��һ��
               		x(individual(F(front).f(i)).p(j),M + V + 1) = front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];                 %������һ��֧��㣬ע�������Ԫ�ظ��嶼�ǳ�ʼ��Ⱥ�ĸ�����ţ�������ԭ����
                end
            end                                                             %ֱ����i�������е�֧�伯Ԫ�ر�֧������1
       end
   end                                                                      %ֱ����front��֧������еĸ���i������
   front =  front + 1;
   F(front).f = Q;
end
[temp,index_of_fronts] = sort(x(:,M + V + 1));                              %�����и������Ӧ��ֵ����С��������С����˳������
for i = 1 : length(index_of_fronts)                                         %�õ���index���������i��Ԫ��Ϊa����ʾԭ��a��Ԫ�����к��˳���Ϊi 
    sorted_based_on_front(i,:) = x(index_of_fronts(i),:);                   %�Ӷ��õ���Ӧ��ֵ��С�������е����и����У�ÿһ�а�������ø����                                
end                                                                         %����������ֵ�����Ŀ�꺯���Ĺ�ֵ�Լ���Ӧ������ֵ
current_index = 0;
% Find the crowding distance for each individual in each front
for front = 1 : (length(F) - 1)                                             %һ�����Թ���length(F) - 1����֧��㣬�ж��ٸ�front���ж��ٸ�
    objective = [];                                                         %length��F������Ϊ���һ���գ����Լ�ȥ1
    distance = 0;
    y = [];
    previous_index = current_index + 1;
    for i = 1 : length(F(front).f)                                          %��front���й�length(F(front).f)��Ԫ�ظ���
        y(i,:) = sorted_based_on_front(current_index + i,:);                
    end
    current_index = current_index + i;
    % Sort each individual based on the objective
    sorted_based_on_objective = [];
    for i = 1 : M                                                           %һ��M��Ŀ�꺯��
        [sorted_based_on_objective, index_of_objectives] = ...
            sort(y(:,V + i));                                               %��front�����и���ĵ�V+iĿ��ֵ����
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);   %�õ���front�����и����ڵ�V+iĿ���ϵ�����
        end
        f_max = ...                                                         %��i��Ŀ���������ֵ
            sorted_based_on_objective(length(index_of_objectives), V + i); 
        f_min = sorted_based_on_objective(1, V + i);                        %��i��Ŀ�����С����ֵ
        y(index_of_objectives(length(index_of_objectives)),M + V + 1 + i) = Inf;                                                          
        y(index_of_objectives(1),M + V + 1 + i) = Inf;                      %����ĳĿ�꺯���Ͼ��������СĿ��ֵ�ĸ����ڸ�Ŀ��i��ӵ����ֵ�������
         for j = 2 : length(index_of_objectives) - 1                        %M+V+1Ϊ��Ӧ��ֵ��M+V+1+i�ǵ�i��Ŀ���Ӧ��ӵ����ֵ
            next_obj  = sorted_based_on_objective(j + 1,V + i);
            previous_obj  = sorted_based_on_objective(j - 1,V + i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + V + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + V + 1 + i) = ...
                     (next_obj - previous_obj)/(f_max - f_min);             %��Ŀ�������������ӵ����ֵ
            end
         end
    end                                                                     %���������M��Ŀ��
    distance = [];
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + V + 1 + i);
    end
    y(:,M + V + 2) = distance;
    y = y(:,1 : M + V + 2);                                                 %����ж�û���ˣ�ֻ��ǰV�о��߱���ֵ����V+1��V+M�й�M��Ŀ�꺯��ֵ
    z(previous_index:current_index,:) = y;                                  %��V+M+1Ϊ�ø��壨��front���previous_index��current_index��
end                                                                         %���壩��Ӧ��ֵ����V+M+2Ϊ�ø���ӵ����ֵ
f = z();