
% clear all

clear IGD
filename = sprintf('./FTLresults10/MFEA_data');
mineresult = load(filename);


mineresult = mineresult.MFEA_data;

%% ----------------------------------------- %%
% clear all

samplenum = 20;

CK = 100;

M = 3;
D = 30;
Boundary = ones(2,D);
Boundary(2,:) = zeros(1,D);
Fnum = 4;
stnum = 20;  %每个类选择的个数
problems = {'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10'};


for fname = 1:Fnum
    
    problem = problems{fname};
    [M, D, lb, ub] = F_funcinit(fname);
    univec = F_univec(CK, M);             %uniform reference vectors
    CK = size(univec, 1);                 %number of reference vectors
    
    truepoint = Bench_Func('true',500,problem);
    Samlen = samplenum*D;
    
    Amdatax=[];
    for run = 1:30

        minedata = mineresult{fname,run};
        minepf = minedata.ATY2;
        minerbf = minedata.RBFval;      
        minex = minedata.TX;
        
        minex = roundn(minex,-3);
        [~,uind] = unique(minex,'rows');
        minex = minex(uind,:);
        minepf = minepf(uind,:);
        minerbf = minerbf(uind,:);
        
        minf = min(minerbf,[],1);
        maxf = max(minerbf,[],1);
        len = size(minerbf,1);
        sminerbf = (minerbf-repmat(minf,len,1))./(repmat(maxf-minf,len,1));
        [partition] = F_partitiont(sminerbf, univec);   %参考点聚类方法
        for i = 1:CK
            index = partition(i).c;
            if (~isempty(index))
                sx = minex(index,:);
                sy = sminerbf(index,:);
                w = univec(i,:);
                sumy = [];
                for j = 1:length(index)
                    sumy(j)=norm(sy(j,:));
                end
                [~,rank] = sort(sumy);
                sstnum = min(stnum,length(rank));
                sindex = rank(1:sstnum);
                mx = mean(sx(sindex,:),1);
                Amdatax  = [Amdatax;mx];
            end
        end
        mnum(run+1) = 100;

    end

    Amdatay = Bench_Func('value',Amdatax, problem);
    Refsample(fname).Amdatay = Amdatay;
    
end

save Refsample Refsample

