
%% ----------------------------------------- %%
NP=100; % Population size for task 1
rmp=0.7; % Random mating probability
gen = 40; % Maximum Number of generations
TL = 15;
samplenum = 10;
Runs = 30;

M = 3;
Fnum = 4;
LMresult = cell(Fnum,Runs);
Mresult = cell(Fnum,Runs);
Sresult = cell(Fnum,Runs);

problems = {'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10'};


    clear MFEA_data
    for fname = [1,2,3,4]
        
        problem = problems{fname};
        [M, D, lb, ub] = F_funcinit(fname);
        
        FModel = cell(1,M);
        GModel = cell(1,M);
        CLModel = cell(1,M);        %收敛性评估 local 模型
        DLModel = cell(1,M);        %多样性评估 local模型
        CLdata = cell(1);
        
        D = length(ub);
        Samlen = samplenum*D;

        for run = 1:20
            TX = lhsdesign(Samlen,D);
            TTX = TX.*repmat((ub-lb),Samlen,1)+repmat(lb,Samlen,1);
            TY=Bench_Func('value',TTX, problem);
            
            Mat=[TX,TY];
            for m = 1:M
                PRmodel=POLY(TX,TY(:,m),'quad');
                [RBFmodel, time] = rbfbuild(TX,TY(:,m), 'TPS');
                GModel{m}   = PRmodel;
                FModel{m}   = RBFmodel;
            end
            
            K = 10;
            MFEA_data{fname,run}=MOMFEA_v01(NP,rmp,gen,GModel,FModel,lb,ub,D,Mat,problem,M,TX,TY,TL);
            SOEA_data{fname,run} = SOEA(NP/2,gen,FModel,lb,ub,D,Mat,problem,M,K);
        end
    end
     filename = sprintf('./FTLresults10/SOEA_data');
     save (filename, 'SOEA_data','-v7');
     filename = sprintf('./FTLresults10/MFEA_data');
     save (filename, 'MFEA_data','-v7');
