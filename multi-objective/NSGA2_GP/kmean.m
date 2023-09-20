function [Centers, nn]=kmean(chromosome, tr_x, N)

global V Ke;
%去除chromosome中重复的点，和与训练数据重复的点
Q=[];P=[];
for i=1:N
    PandQ=[tr_x;Q];
    matrix=dist(chromosome(i,1:V),PandQ');%1*size(PandQ,1)矩阵
    if isempty(find(matrix<=2*10^-02))
        Q=[Q;chromosome(i,1:V)];
        P=[P;chromosome(i,:)];
    end
end
if size(Q,1)<Ke
    Centers=[];nn=100;
else
    Centers=Q(1:Ke,1:V);n=1;si=size(Q,1);
    %按照决策变量的距离聚类
    while n<100,
        
        NumberInClusters = zeros(Ke,1); % 各类中的样本数量，初始化为零
        IndexInClusters = zeros(Ke,N); % 各类所含样本的索引号
        % 按最小距离原则对所有样本进行分类
        for i = 1:si
            AllDistance = dist(Centers,Q(i,1:V)');%计算第i个weight vector与所有聚类中心的距离
            [MinDist,Pos] = min(AllDistance);   %最小距离，该训练输入所属的聚类中心索引
            NumberInClusters(Pos) = NumberInClusters(Pos) + 1;
            IndexInClusters(Pos,NumberInClusters(Pos)) = i;%将属于该类的训练输入索引依次存入
        end
        % 保存旧的聚类中心
        OldCenters = Centers;
        %重新计算聚类中心
        for i = 1:Ke
            Index = IndexInClusters(i,1:NumberInClusters(i));%提取属于该类的训练输入索引
            Centers(i,:) = mean(Q(Index,1:V),1);    %取各类的平均作为新的聚类中心
        end
        % 判断新旧聚类中心是否一致，是则结束聚类
        EqualNum = sum(sum(Centers==OldCenters));%Centers与OldCenters所有对应位相减之后求总和
        if EqualNum ==V*Ke,%表明新旧聚类中心一致
            break,
        end
        n=n+1;
    end
    nn=n;fprintf('k-means clustering %d\n',n);
end