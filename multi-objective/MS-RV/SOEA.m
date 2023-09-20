function SOEA_data = SOEA(pop,gen,FModel,L,U,dim,Mat,problem,M,K)
%SOEA function: implementation of SOEA algorithm
clc
tic


for i=1:pop
    population(i)=Chromosome;
    population(i)=initialize(population(i),dim);
    population(i).skill_factor=2;
end
for i = 1 : pop
    population(i)=evaluate(population(i),FModel,FModel,Mat,M);
end
[population,frontnumbers]=SolutionComparison.nondominatedsort(population,pop,M);
[population,~]=SolutionComparison.diversity(population,frontnumbers,pop,M);
ATY = [];
TX=[];
muc = 20;     % Index of Simulated Binary Crossover (tunable)
mum = 20;    % Index of polynomial mutation
RBFval = [];
for generation = 1: gen
    
    T_data=[];
    Vec=[];
    
    for i=1:pop
        T_data = [T_data;population(i).objs_T2];
        Vec =  [Vec;population(i).rnvec];
    end
    RBFval = [RBFval;T_data];
    Tx = Vec;
    TX = [TX;Tx];
    TY=Bench_Func('value',Tx, problem);
    ATY = [ATY;TY];
% %     [FrontValue,~] = P_sort(Aval,'fixed', size(Aval,1));
%     output=Aval(FrontValue==1,:);
%     truepoint=Bench_Func('true',100, problem);
%     FIGD(generation)=P_evaluate('IGD',output,truepoint);
    
    rndlist=randperm(pop);
    population=population(rndlist);
    for i = 1:pop % Performing binary tournament selection to create parent pool
        parent(i)=Chromosome();
        p1=1+round(rand(1)*(pop-1));
        p2=1+round(rand(1)*(pop-1));
        if population(p1).rank < population(p2).rank
            parent(i) = population(p1);
        else
            parent(i) = population(p2);
        end
    end
    
    Dparent1 = randperm(pop);
    count=1;
    for i = 1 : 2: pop
        child(count)=Chromosome;
        child(count+1)=Chromosome;
        p1=Dparent1(i);
        p2=Dparent1(i+1);
        [child(count).rnvec,child(count+1).rnvec]=Evolve.crossover(parent(p1).rnvec,parent(p2).rnvec,muc,dim,0);
        child(count).rnvec = Evolve.mutate(child(count).rnvec,mum,1/dim,dim);
        child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,mum,1/dim,dim);
        child(count).skill_factor=parent(p1).skill_factor;
        child(count+1).skill_factor=parent(p2).skill_factor;
        count=count+2;
    end
    cpop = length(child);
    for i = 1 : cpop
        child(i)=evaluate(child(i),FModel,FModel,Mat,M);
    end
    
    population=reset(population,pop);
    intpopulation(1:pop)=population;
    intpopulation(pop+1:cpop+pop)=child;
    
    [intpopulation,frontnumbers]=SolutionComparison.nondominatedsort(intpopulation,cpop+pop,M);
    [intpopulation,~]=SolutionComparison.diversity(intpopulation,frontnumbers,cpop+pop,M);
    population = intpopulation(1:pop);
    
    disp(['SOO Generation ', num2str(generation)])
    
end
% plot(FIGD,'-*g')
SOEA_data.RBFval = RBFval;
SOEA_data.ATY = ATY;
SOEA_data.TX = TX;
end