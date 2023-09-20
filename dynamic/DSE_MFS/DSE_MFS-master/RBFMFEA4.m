% This trial version of the Multi-Objective Multifactorial Evolutionary Algorithm (MO-MFEA: which is based on NSGA-II) has been
% developed to handle only two "continuous" multiobjective problems (or tasks) at a time.
% Each problem may comprise upto three objective functions.
% Generalization to many-tasking can be done based on this framework.
function MFEA_data=RBFMFEA4(pop,gen,FModel,L,U,dim,Mat,fun_num,change_instance,item,run,W,Vec,CMAT)

SFnum = length(W)+1;
subpop = ceil(pop/(SFnum-1)/2);
pop = 2*subpop*(SFnum-1);
gpop = pop/2;
if mod(pop,2)==1
    pop = pop-1;
end
RBFval=[];
ATY = [];
TX=[];
rmp = 0.3;

AW = [];
DW = (1-W)/gen/2;
Sumw = zeros(SFnum,1);
Sumw(1:SFnum-1) = 1-W;
for i = 1:SFnum-1
    rw = 1-0.5;
    w = rw.*(W/Sumw(i));
    w(i) = 0.5;
    AW{i} = w;
end
AW{SFnum} = W;

    len = length(Mat);
    
    cmat = CMAT;
    csampley = cmat(:,end);
    csamplex = cmat(:,1:end-1);
    SVMsample = csamplex;

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

for i=1:pop
    population(i)=evaluate_SOO(population(i),FModel,FModel,Mat,W,2,1);
end
RMSE = [];
muc = 20;     % Index of Simulated Binary Crossover (tunable)
mum = 20;     % Index of polynomial mutation
[~,ind] = sort(csampley);
scsamplex = SVMsample(ind(1:floor(size(SVMsample,1)/4)),:);
   GVec = csamplex(ind(1),:); 
   GTy = csampley(ind(1)); 

for generation=1:gen
    
    rndlist=randperm(pop);
    parent=population(rndlist);
    count=1;
    for i=1:2:pop-1    % Create offspring population via mutation and crossover
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
        child(i)=evaluate_SOO(child(i),FModel,FModel,Mat,W,2,1);
    end
    

%     CTY = [];
%     PTY = [];
%     
%     ppop = length(population);
%     PVec = [];
%     for i = 1:ppop
%         if population(i).skill_factor==SFnum
%            PVec = [PVec;population(i).rnvec];
%            PTx = population(i).rnvec*(U-L)+L;
%            PTy=DBG(PTx,fun_num,change_instance,item-1,run,dim);
%            PTY = [PTY;PTy];
%         end
%     end
%   
%     CVec = [];
%     for i = 1:ppop
%         if child(i).skill_factor==SFnum
%            CVec = [CVec;child(i).rnvec];
%            CTx = child(i).rnvec*(U-L)+L;
%            CTy=DBG(CTx,fun_num,change_instance,item-1,run,dim);
%            CTY = [CTY;CTy];
%         end
%     end
%     
    
nu = 0;           % nu -> [0,1] 在支持向量数与错分样本数之间进行折衷
% 支持向量机的 nu 参数(取值越小，异常点就越少)
ker = struct('type','gauss','width',500);
svmmodel = svmTrain('svm_one_class',scsamplex',[],ker,nu);
% [cvmp,cvmpr] = svmSim(svmmodel,CVec');           % 测试输出
% [pvmp,pvmpr] = svmSim(svmmodel,PVec');           % 测试输出
% 
% 
% pind  = find(pvmp==-1);
% cind  = find(cvmp==-1);
% 
%    kk = 1;
%     for i = 1:ppop
%         if population(i).skill_factor==SFnum
%             population(i).factorial_ranks = pvmp(kk)*population(i).factorial_costs;
%             population(i).scalar_fitness = pvmp(kk);
%             kk = kk+1;
%         else
%             population(i).factorial_ranks = population(i).factorial_costs;
%         end
%     end
% 
%     kk = 1;
%     for i = 1:ppop
%         if child(i).skill_factor==SFnum
%             child(i).factorial_ranks = cvmp(kk)*child(i).factorial_costs;
%             child(i).scalar_fitness = cvmp(kk);
%             kk = kk+1;
%         else
%             child(i).factorial_ranks = child(i).factorial_costs;
%         end
%     end
    
%     SVMsample = [SVMsample;SCVec(cvmind,:)];
%     SVMsample = [SVMsample;PVec(pvmind,:)];
    
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
 
CTX = [];
CTY = [];
 for i = gpop+1:pop
%      scsamplex = [scsamplex;population(i+gpop).rnvec];
     Ctx = population(i).rnvec;
     Cty = population(i).factorial_costs;
     CTX = [CTX;Ctx];
     CTY = [CTY;Cty];
 end

% smobj = DBG(CTX(1,:)*(U-L)+L,fun_num,change_instance,item-1,run,dim);

[cpvmp,cpvmpr] = svmSim(svmmodel,CTX');           % 测试输出
cpind  = find(cpvmp==-1);


snum = floor(size(SVMsample,1)/8);
% scsamplex = SVMsample(ind(1:snum),:);
SCTX = CTX(cpind,:);
SCTY = CTY(cpind,:);
[~,tind] = sort(SCTY);
SCTX = SCTX(tind,:);
minlen = min(snum,length(cpind));
% scsamplex = [scsamplex;SCTX(1,:)];

if length(cpind)>0
   scsamplex =  [scsamplex;SCTX(minlen,:)];
   GVec = mean(scsamplex,1); 
   GTy = DBG(GVec(1,:)*(U-L)+L,fun_num,change_instance,item-1,run,dim);
end
   disp(['Item ', num2str(item),' generation = ', num2str(generation),' outliers = ', num2str(length(cpind))])
   
end

MFEA_data.fx = GVec;
MFEA_data.fy = GTy;

end