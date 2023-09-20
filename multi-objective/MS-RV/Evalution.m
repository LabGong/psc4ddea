function IGD = Evalution(solution1,solution2,fname)

switch fname
    case 1
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = (1-truepoint1(:,1).^2).^0.5;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^2;
    case 2
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = 1-truepoint1(:,1).^2;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = (1-truepoint2(:,1).^2).^0.5;
    case 3
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = (1-truepoint1(:,1).^2).^0.5;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^0.5;
    case 4
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = 1-truepoint1(:,1).^0.5;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^0.5;
    case 5
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = (1-truepoint1(:,1).^2).^0.5;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^2;
    case 6
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = (1-truepoint1(:,1).^2).^0.5;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = (1-truepoint2(:,1).^2).^0.5;      
    case 7
        truepoint1(:,1) =  linspace(0,1,100);
        truepoint1(:,2) = (1-truepoint1(:,1).^2).^0.5;
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^0.5;
    case 8
        truepoint1 = UniformWeight(120,3);
        for n = 1 : size(truepoint1,1)
            truepoint1(n,:) = truepoint1(n,:)./norm(truepoint1(n,:));
        end
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^2;
    case 9
        truepoint1 = UniformWeight(120,3);
        for n = 1 : size(truepoint1,1)
            truepoint1(n,:) = truepoint1(n,:)./norm(truepoint1(n,:));
        end
        truepoint2(:,1) =  linspace(0,1,100);
        truepoint2(:,2) = 1-truepoint2(:,1).^2;
end
IGD(1)  =IGD_eval(solution1,truepoint1);
IGD(2)  =IGD_eval(solution2,truepoint2);
%          GD(1)  =GD_eval(solution1,truepoint1);
%          GD(2)  =GD_eval(solution2,truepoint2);
end

function W = UniformWeight(SampleNum,M)
H = floor((SampleNum*prod(1:M-1))^(1/(M-1)));
while nchoosek(H+M-1,M-1) >= SampleNum && H > 0
    H = H-1;
end
if nchoosek(H+M,M-1) <= 2*SampleNum || H == 0
    H = H+1;
end
SampleNum = nchoosek(H+M-1,M-1);
Temp = nchoosek(1:H+M-1,M-1)-repmat(0:M-2,nchoosek(H+M-1,M-1),1)-1;
W = zeros(SampleNum,M);
W(:,1) = Temp(:,1)-0;
for m = 2 : M-1
    W(:,m) = Temp(:,m)-Temp(:,m-1);
end
W(:,end) = H-Temp(:,end);
W = W/H;
end

function GD_obj = GD_eval(solution,truepoint)
[r,~]=size(solution);
t = size(truepoint,1);
dmin=[];
for i=1:r
    b=solution(i,:);
    for j=1:t
        a=truepoint(j,:);
        d(j)=sqrt(sum((b-a).^2));
    end
    dmin(i)=min(d);
    d=[];
end
GD_obj=sum(dmin)/r;
end

function IGD_obj = IGD_eval(solution,truepoint)
[r,~]=size(solution);
t = size(truepoint,1);
dmin=[];
for i=1:t
    b=truepoint(i,:);
    for j=1:r
        a=solution(j,:);
        d(j)=sqrt(sum((b-a).^2));
    end
    dmin(i)=min(d);
    d=[];
end
IGD_obj=sum(dmin)/t;
end
