% This trial version of the Multi-Objective Multifactorial Evolutionary Algorithm (MO-MFEA: which is based on NSGA-II) has been
% developed to handle only two "continuous" multiobjective problems (or tasks) at a time.
% Each problem may comprise upto three objective functions.
% Generalization to many-tasking can be done based on this framework.
function MFEA_data=ERBFMFEA(pop,gen,FModel,L,U,dim,Mat,fun_num,change_instance,item,run,W,OldVec)

SFnum = length(W)+1;
subpop = ceil(pop/(SFnum-1)/2);
pop = 2*subpop*(SFnum-1);
gpop = pop/2;
if mod(pop,2)==1
    pop = pop-1;
end
RBFval=[];
ATY = [];
ATX=[];
rmp = 0.3;

AW = [];
fy = [];

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

% 历史知识移民
if item>1
    ypop = min(size(OldVec,1),pop);
    for i = 1:ypop
        population(i).rnvec = OldVec(i,:);
    end
end

for i=1:pop
    population(i)=evaluate_SOO(population(i),FModel,FModel,Mat,W,2,1);
end

muc = 20;     % Index of Simulated Binary Crossover (tunable)
mum = 20;     % Index of polynomial mutation
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
    

   disp(['ERBFMFEA', ' Item ', num2str(item), ' Run ', num2str(run), ' MOO Generation ', num2str(generation)])

   GVec=[];
    for i=1:pop
        GVec =  [GVec;population(i).rnvec];
    end
   fx = mean(GVec,1);
   [f,~] = DBG(fx*(U-L)+L,fun_num,change_instance,item-1,run,dim);
   fy = [fy,f];

    MFEA_data.ATY = ATY;
    MFEA_data.ATX = ATX;
    MFEA_data.fx = fx;
    MFEA_data.fy = fy;
   
end








end