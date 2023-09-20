function objv_EI=estimate(x, hyp, center, data, tr_x,tr_y)

global M;
inf=@infExact;
cov =  @covSEiso; %cov=@covLIN;
lik = @likGauss;

if isempty(center)
    
    fmin=min(tr_y);
    for i=1:M
        [me(:,i) s2(:,i)] = gp(hyp(i), inf, [], cov, lik, tr_x, tr_y(:,i), x);
        objv_EI(:,i)=-(fmin(i)-me(:,i)).*normcdf((fmin(i)-me(:,i))./sqrt(s2(:,i)))-sqrt(s2(:,i)).*normpdf((fmin(i)-me(:,i))./sqrt(s2(:,i)));
    end
    
else

    N=size(x,1);hang=zeros(N,1);
    for j=1:N
        Ci=[];
        %找到与untested point x距离最小的聚类中心，并用属于该中心的训练数据建立GP
        D=dist(x(j,:),center');
        Ci=find(D==min(D));
        h=size(Ci,2);
        if h==1
            hang(j,:)=Ci;
        else 
            hang(j,:)=Ci(ceil(rand*h));
        end
    end
    objv_EI=[];
    for j=1:size(center,1)
        me=[];s2=[];objv=[];
        indexs=find(hang==j);
        xx=x(indexs,:);
        tr_xx=tr_x(data(j,:),:);tr_yy=tr_y(data(j,:),:);
        fmin=min(tr_yy);
        for i=1:M
            [me(:,i) s2(:,i)] = gp(hyp(i), inf, [], cov, lik, tr_xx, tr_yy(:,i), xx);
            objv(:,i)=-(fmin(i)-me(:,i)).*normcdf((fmin(i)-me(:,i))./sqrt(s2(:,i)))-sqrt(s2(:,i)).*normpdf((fmin(i)-me(:,i))./sqrt(s2(:,i)));
        end
        objv_EI(indexs,:)=objv;
    end
    
end