function metric = P_evaluate(operation,functionvalue,parameter1)
% ■P_evaluate 返回对于解集functionvalue在不同评价指标下的评价值
%              包含收敛性(CM),转化代间距离(IGD),覆盖率(C),超体积(HV),间距指标(SM),代间距离(GD)和平均Hausdorff距离(delta)
%              CM和GD用于评价解的收敛性
%              SM用于评价解的分布性
%              IGD,HV和delta用于综合评价解的收敛性和分布性
%              C用于评价此解集相对于另一个解集的好坏
%              其中CM,IGD,SM,GD,delta值越小越好,C和HV值越大越好
%
% 输入:
%       ■operation:     字符串.用来指定操作的类型,其取值如下:
%                        1.'CM',用来评价收敛性
%                        2.'IGD',用来评价转化代间距离
%                        3.'C',用来评价覆盖率
%                        4.'HV',用来评价超体积
%                        5.'SM',用来评价间距指标
%                        6.'GD',用来评价代间距离
%                        7.'delta',用来评价平均Hausdorff距离
%       ■functionvalue: 二维矩阵.待评价的解集,其中每一行对应一个个体,每一列对应一维目标函数值
%       ■parameter1:    一维向量或二维矩阵.含义如下:
%                        1.当operation取值为'CM'时,为真实前沿面上的均匀取样点集合(二维矩阵),其中每一行对应一个个体,每一列对应一维目标函数值
%                        2.当operation取值为'IGD'时,同1
%                        3.当operation取值为'C'时,为另一个解集(二维矩阵),其中每一行对应一个个体,每一列对应一维目标函数值
%                        4.当operation取值为'HV'时,为参考点坐标(一维向量),其中每一位对应一维坐标值
%                        5.当operation取值为'SM'时,省略
%                        6.当operation取值为'GD'时,同1
%                        7.当operation取值为'delta'时,同1
%
% 输出:
%       ■metric:        数值.含义如下:
%                        1.当operation取值为'CM'时,为解集functionvalue相对于真实前沿面parameter1的收敛性值
%                        2.当operation取值为'IGD'时,为解集functionvalue相对于真实前沿面parameter1的转化代间距离值
%                        3.当operation取值为'C'时,为解集functionvalue支配解集parameter1中个体的百分比
%                        4.当operation取值为'HV'时,为解集functionvalue相对于参考点parameter1的超体积值
%                        5.当operation取值为'SM'时,为解集functionvalue的解间距指标值
%                        6.当operation取值为'GD'时,为解集functionvalue相对于真实前沿面parameter1的代间距离
%                        7.当operation取值为'delta'时,为解集functionvalue相对于真实前沿面parameter1的平均Hausdorff距离

    switch operation
        %收敛性
        case 'CM'
            popnum=size(functionvalue,1);
            truenum=size(parameter1,1);
            dis=zeros(popnum,truenum);
            fmax=max(parameter1);
            fmin=min(parameter1);
            for i=1:popnum
                for j=1:truenum
                    dis(i,j)=sqrt(sum(((functionvalue(i,:)-parameter1(j,:))./(fmax-fmin)).^2));
                end
            end
            dis=min(dis,[],2);
            metric=mean(dis);
        %转化代间距离
        case 'IGD'
            popnum=size(functionvalue,1);
            truenum=size(parameter1,1);
            dis=zeros(truenum,popnum);
            for i=1:truenum
                for j=1:popnum
                    dis(i,j)=sqrt(sum((functionvalue(j,:)-parameter1(i,:)).^2));
                end
            end
            dis=min(dis,[],2);
            metric=mean(dis);
        %覆盖率
        case 'C'
            temp=zeros(1,size(parameter1,1));
            for i=1:size(parameter1,1)
                for j=1:size(functionvalue,1)
                    k=any(functionvalue(j,:)-parameter1(i,:)<0)-any(functionvalue(j,:)-parameter1(i,:)>0);
                    if k==1
                        temp(i)=1;
                        break
                    end
                end
            end
            metric=sum(temp)/size(parameter1,1);
        %超体积
        case 'HV'
            functionvalue(sum(functionvalue-repmat(parameter1,size(functionvalue,1),1)<=0,2)<size(functionvalue,2),:)=[];
            if isempty(functionvalue)
                metric=0;
                return
            end
            if size(functionvalue,2)<5
                n = size(functionvalue,2);
                pl = sortrows(functionvalue,1);
                S(1,1) = {1};
                S(1,2) = {pl};
                for k =1:n-1
                    S_ = {};
                    j = size(S,1);
                    for l = 1:j
                        S_l = cell2mat(S(l,2));
                        S_temp = Slice(S_l,k,parameter1);
                        p = size(S_temp,1);
                        for q=1:p
                            cell_(1,1) = {cell2mat(S_temp(q,1))*cell2mat(S(l,1))};
                            cell_(1,2) = S_temp(q,2);
                            S_ = Add(cell_,S_);
                        end
                    end
                    S = S_;
                end
                vol = 0;
                k = size(S,1);
                for l = 1 : k
                    p = Head(cell2mat(S(l,2)));
                    num = abs(p(n)-parameter1(n));
                    vol = vol + cell2mat(S(l,1))*num;
                end
            else
                k=1000000;
                maxvalue=parameter1;
                minvalue=min(functionvalue,[],1);
                samples=repmat(minvalue,k,1)+rand(k,size(functionvalue,2)).*repmat((maxvalue-minvalue),k,1);
                m=zeros(1,k);
                for i=1:size(functionvalue,1)
                    m(sum(repmat(functionvalue(i,:),k,1)-samples<=0,2)==size(functionvalue,2))=1;
                end
                vol=prod(maxvalue-minvalue)*sum(m)/k;
            end
            metric=vol;
        %间距指标
        case 'SM'
            popnum=size(functionvalue,1);
            dis=zeros(popnum);
            for i=1:popnum
                dis(i,i)=inf;
                for j=i+1:popnum
                    dis(i,j)=sum(abs(functionvalue(i,:)-functionvalue(j,:)));
                    dis(j,i)=dis(i,j);
                end
            end
            dis=min(dis,[],2);
            metric=sqrt(1/(popnum-1)*sum((mean(dis)-dis).^2));
        %代间距离
        case 'GD'
            metric=P_evaluate('IGD',parameter1,functionvalue);
        %平均Hausdorff距离
        case 'delta'
            metric=max(P_evaluate('IGD',functionvalue,parameter1),P_evaluate('GD',functionvalue,parameter1));
    end
end

%以下是用于计算超体积(精确)的辅助函数
function [ S ] = Slice( pl , k ,refPoint)
    % 计算每个切片上的点集
    p = Head(pl);
    pl = Tail(pl);
    ql = [];
    S = {};
    while ~isempty(pl)
        ql = Insert(p , k+1 ,ql);
        p_ = Head(pl);
        cell_(1,1) = {abs(p(k) - p_(k))};
        cell_(1,2) = {ql};
        S = Add(cell_,S);
        p = p_;
        pl = Tail(pl);
    end
    ql = Insert(p , k+1 , ql);
    cell_(1,1) = {abs(p(k) - refPoint(k))};
    cell_(1,2) = {ql};
    S = Add(cell_,S);
end

function [ ql ] = Insert( p,k,pl )
    % 点集的整理过程
    flag1 = 0;
    flag2 = 0;
    ql = [];
    hp = Head(pl);
    while ~isempty(pl) && hp(k) < p(k)
        ql = Append( hp , ql );
        pl = Tail(pl);
        hp = Head(pl);
    end
    ql = Append( p , ql );
    m = length(p);
    while ~isempty(pl)
        q = Head(pl);
        for i = k:m
            if p(i) < q(i)
                flag1 = 1;
            else
                if p(i) > q(i)
                    flag2 = 1;
                end
            end
        end
        if ~(flag1 == 1 && flag2 == 0)
            ql = Append(Head(pl) , ql);
        end
        pl = Tail(pl);
    end  
end

function [ p ] = Head( pl )
    % 获取点集中第一个点
    if isempty(pl)
        p = [];
    else
        p = pl(1,:);
    end
end

function [ ql ] = Tail( pl )
    % 获取点集中除第一个点外所有的点集合
    m = size(pl,1);
    if m == 0 || m == 1
        ql = [];
    else
        ql = pl(2:m,:);
    end
end

function [ S_ ] = Add( cell_ , S )
    % 将新的S值插入并整理
    n = size(S,1);
    m = 0;
    for k=1:n
        if isequal(cell_(1,2),S(k,2))
            S(k,1) = {cell2mat(S(k,1)) + cell2mat(cell_(1,1))};
            m = 1;
            break;
        end
    end
    if m == 0
        S(n+1,:) = cell_(1,:);
    end
    S_ = S;     
end

function [ pl ] = Append( p , ql )
    % 点的序列中追加新点
    m = size(ql,1);
    ql(m+1,:) = p;
    pl = ql;
end