% This trial version of the Multi-Objective Multifactorial Evolutionary Algorithm (MO-MFEA: which is based on NSGA-II) has been
% developed to handle only two "continuous" multiobjective problems (or tasks) at a time.
% Each problem may comprise upto three objective functions.
% Generalization to many-tasking can be done based on this framework.
function MFEA_data=RBFMFEASVDD(pop,gen,FModel,L,U,dim,Mat,fun_num,change_instance,item,run,W,Vec)

SFnum = length(W)+1;
subpop = ceil(pop/(SFnum-1)/2);
pop = 2*subpop*(SFnum-1);
if mod(pop,2)==1
   pop = pop-1; 
end
RBFval=[];
ATY = [];
TX=[];
rmp = 0.3;

AW = [];
DW = (1-W)/gen/2;
% Sumw = zeros(SFnum,1);
% Sumw(1:SFnum-1) = 1+W;
% for i = 1:SFnum-1
%     rw = Sumw(i)-0.5;
%     w = rw.*W;
%     w(i) = 0.5;
%     AW{i} = w;
% end

Sumw = zeros(SFnum,1);
Sumw(1:SFnum-1) = 1-W;
for i = 1:SFnum-1
    rw = 1-0.5;
    w = rw.*(W/Sumw(i));
    w(i) = 0.5;
    AW{i} = w;
end

AW{SFnum} = W;
Subpop = zeros(1,SFnum);
for i=1:pop/2
    population(i)=Chromosome;
    population(i)=initialize(population(i),dim);
    population(i).skill_factor = mod(i,SFnum-1)+1;
    population(i).gen = 0;
    population(i).CW = AW{population(i).skill_factor};
    Subpop(population(i).skill_factor) = Subpop(population(i).skill_factor)+1;
end

for i=1+pop/2:pop
    population(i)=Chromosome;
    population(i)=initialize(population(i),dim);
    population(i).skill_factor = SFnum;
    population(i).gen = 0;
    population(i).CW = AW{population(i).skill_factor};
    Subpop(population(i).skill_factor) = Subpop(population(i).skill_factor)+1;
end

if item>1
    ypop = min(size(Vec,1),pop);
   for i = 1:ypop
       population(i).rnvec = Vec(i,:);
   end
end
len = length(Mat);
    cmat = Mat{len};
    csample = cmat(:,end);
    csamplex = cmat(:,1:end-1);
    
    [~,ind] = sort(csample);
    SVMsample = csamplex(ind(1:floor(0.25*size(csample))),:);

for i=1:pop
    population(i)=evaluate_SOO(population(i),FModel,Mat,W,2);
end
nu = 0;           % nu -> [0,1] 在支持向量数与错分样本数之间进行折衷
% 支持向量机的 nu 参数(取值越小，异常点就越少)
ker = struct('type','gauss','width',500);
svmmodel = svmTrain('svm_one_class',SVMsample',[],ker,nu); 
muc = 20;     % Index of Simulated Binary Crossover (tunable)
mum = 20;    % Index of polynomial mutation
for generation=1:gen
     W1=[];
    for i = 1:SFnum-1
        rw = 0.5+generation*DW(i);
        w = rw.*(W/Sumw(i));
        w(i) = 0.5-generation*DW(i);
        AW{i} = w;
        W1 = [W1;w];
    end

    disp(['MOO Generation ', num2str(generation)])

    rndlist=randperm(pop);
    parent=population(rndlist);
    count=1;
    for i=1:2:pop-1 % Create offspring population via mutation and crossover
        child(count)=Chromosome;
        child(count+1)=Chromosome;
        p1=i;
        p2=i+1;
        if parent(p1).skill_factor==parent(p2).skill_factor
            [child(count).rnvec,child(count+1).rnvec]=Evolve.crossover(parent(p1).rnvec,parent(p2).rnvec,muc,dim,0);
            child(count).rnvec = Evolve.mutate(child(count).rnvec,mum,dim,1/dim);
            child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,mum,dim,1/dim);
            child(count).skill_factor=parent(p1).skill_factor;
            child(count+1).skill_factor=parent(p2).skill_factor;
        else
            if rand(1)<rmp
                [child(count).rnvec,child(count+1).rnvec]= Evolve.crossover(parent(p1).rnvec,parent(p2).rnvec,muc,dim,0);
                child(count).rnvec = Evolve.mutate(child(count).rnvec,mum,dim,1/dim);
                child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,mum,dim,1/dim);
                num1 = Subpop(parent(p1).skill_factor);
                num2 = Subpop(parent(p2).skill_factor);
                cc = num1/(num1+num2);
                if rand(1)<cc 
                   child(count).skill_factor=parent(p1).skill_factor;
                else
                   child(count).skill_factor=parent(p2).skill_factor;
                end
                if rand(1)<cc 
                   child(count+1).skill_factor=parent(p1).skill_factor;
                else
                   child(count+1).skill_factor=parent(p2).skill_factor;
                end
            else
                child(count).rnvec = Evolve.mutate(parent(p1).rnvec,mum,dim,1);
                child(count+1).rnvec=Evolve.mutate(parent(p2).rnvec,mum,dim,1);
                child(count).skill_factor=parent(p1).skill_factor;
                child(count+1).skill_factor=parent(p2).skill_factor;
            end
        end
        count=count+2;
    end
    for i=1:pop
        child(i).gen = generation;
        child(i).CW = AW{child(i).skill_factor};
        child(i)=evaluate_SOO(child(i),FModel,Mat,W,2);
    end
    
    CT_data=[];
    CVec=[];
    CTY = [];
    for i=1:pop
        CT_data = [CT_data;child(i).factorial_costs];
        CVec =  [CVec;child(i).rnvec];
        CTx = child(i).rnvec*(U-L)+L;
        CTy=DBG(CTx,fun_num,change_instance,item-1,run,dim);
        CTY = [CTY;CTy];
    end

    ppop = length(population);
    PSFnum = max([population.skill_factor]);
    PVec = [];
    for i = 1:ppop
        if population(i).skill_factor==PSFnum
           PVec = [PVec;population(i).rnvec];
        end
    end
  
    SCVec = [];
    for i = 1:ppop
        if child(i).skill_factor==SFnum
           SCVec = [SCVec;child(i).rnvec];
        end
    end
    
    
 nu = 0;           % nu -> [0,1] 在支持向量数与错分样本数之间进行折衷
% 支持向量机的 nu 参数(取值越小，异常点就越少)
ker = struct('type','gauss','width',500);
[~,ind] = sort(csample);

svmmodel = svmTrain('svm_one_class',scsamplex',[],ker,nu);
[cvmp,cvmpr] = svmSim(svmmodel,SCVec');           % 测试输出
[pvmp,pvmpr] = svmSim(svmmodel,PVec');           % 测试输出
[tsvmp,tvmpr] = svmSim(svmmodel,csamplex');           % 测试输出

mina = min(cvmpr);
maxa = max(cvmpr);
cvmpr = 2*(cvmpr-mina)/(maxa-mina)-1;

mina = min(pvmpr);
maxa = max(pvmpr);
pvmpr = 2*(pvmpr-mina)/(maxa-mina)-1;

mindis = min(tvmpr);
cvmind = find(cvmpr<mindis);
pvmind = find(pvmpr<mindis);
sind  = find(cvmp==-1);
tind  = find(tsvmp==1);

   kk = 1;
    for i = 1:ppop
        if population(i).skill_factor==PSFnum
            population(i).factorial_costs = (1+pvmpr(kk))*population(i).factorial_costs;
            kk = kk+1;
        end
    end

    kk = 1;
    for i = 1:ppop
        if child(i).skill_factor==PSFnum
            child(i).factorial_costs = (1+cvmpr(kk))*child(i).factorial_costs;
            kk = kk+1;
        end
    end

    intpopulation(1:pop)=population;
    intpopulation(pop+1:2*pop)=child;

    kk = 1;
    for i = 1:SFnum
        population_T = [];
        population_T=intpopulation([intpopulation.skill_factor]==i);
        len = Subpop(i);
        [xxx,y]=sort([population_T.factorial_costs]);
        population_T=population_T(y);
        population(kk:kk+len-1) = population_T(1:len);
        kk = kk+len;
    end
    
    for i=1:pop
        population(i).CW = AW{population(i).skill_factor};
    end
    
end

    T_data=[];
    Vec=[];
    TY=[];
    for i=1:pop
        T_data = [T_data;population(i).factorial_costs];
        Vec =  [Vec;population(i).rnvec];
        Tx = population(i).rnvec*(U-L)+L;
        Ty=DBG(Tx,fun_num,change_instance,item-1,run,dim);
        TY = [TY;Ty];
    end
    RBFval = [RBFval;T_data];
    ATY = [ATY;TY];
    TX = [TX;Vec];


    GRBFval=[];
    GVec=[];
    GTY = [];
    for i=1:len
        GRBFval = [GRBFval;population_T(i).factorial_costs];
        GVec =  [GVec;population_T(i).rnvec];
        GTx = population_T(i).rnvec*(U-L)+L;
        GTy=DBG(GTx,fun_num,change_instance,item-1,run,dim);
        GTY = [GTY;GTy];
    end

    MFEA_data.RBFval = RBFval;
    MFEA_data.GRBFval = GRBFval;
    MFEA_data.ATY = ATY;
    MFEA_data.GTY = GTY;
    MFEA_data.TX = TX;
    MFEA_data.Vec = GVec;
end