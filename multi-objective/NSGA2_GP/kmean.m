function [Centers, nn]=kmean(chromosome, tr_x, N)

global V Ke;
%ȥ��chromosome���ظ��ĵ㣬����ѵ�������ظ��ĵ�
Q=[];P=[];
for i=1:N
    PandQ=[tr_x;Q];
    matrix=dist(chromosome(i,1:V),PandQ');%1*size(PandQ,1)����
    if isempty(find(matrix<=2*10^-02))
        Q=[Q;chromosome(i,1:V)];
        P=[P;chromosome(i,:)];
    end
end
if size(Q,1)<Ke
    Centers=[];nn=100;
else
    Centers=Q(1:Ke,1:V);n=1;si=size(Q,1);
    %���վ��߱����ľ������
    while n<100,
        
        NumberInClusters = zeros(Ke,1); % �����е�������������ʼ��Ϊ��
        IndexInClusters = zeros(Ke,N); % ��������������������
        % ����С����ԭ��������������з���
        for i = 1:si
            AllDistance = dist(Centers,Q(i,1:V)');%�����i��weight vector�����о������ĵľ���
            [MinDist,Pos] = min(AllDistance);   %��С���룬��ѵ�����������ľ�����������
            NumberInClusters(Pos) = NumberInClusters(Pos) + 1;
            IndexInClusters(Pos,NumberInClusters(Pos)) = i;%�����ڸ����ѵ�������������δ���
        end
        % ����ɵľ�������
        OldCenters = Centers;
        %���¼����������
        for i = 1:Ke
            Index = IndexInClusters(i,1:NumberInClusters(i));%��ȡ���ڸ����ѵ����������
            Centers(i,:) = mean(Q(Index,1:V),1);    %ȡ�����ƽ����Ϊ�µľ�������
        end
        % �ж��¾ɾ��������Ƿ�һ�£������������
        EqualNum = sum(sum(Centers==OldCenters));%Centers��OldCenters���ж�Ӧλ���֮�����ܺ�
        if EqualNum ==V*Ke,%�����¾ɾ�������һ��
            break,
        end
        n=n+1;
    end
    nn=n;fprintf('k-means clustering %d\n',n);
end