% This trial version of the Multi-Objective Multifactorial Evolutionary Algorithm (MO-MFEA: which is based on NSGA-II) has been
% developed to handle only two "continuous" multiobjective problems (or tasks) at a time.
% Each problem may comprise upto three objective functions.
% Generalization to many-tasking can be done based on this framework.
function MFEA_data=MOMFEA_v01(pop,rmp,gen,GModel,FModel,L,U,dim,Mat,KIND,M,TX,TY,TL)


muc = 20; % Distribution Index of SBX crossover operator
mum = 20; % Distribution Index of Polynomial Mutation operator

if mod(pop,2)~=0
    pop=pop+1;
end
pop1=pop/2;
pop2=pop1;

for i=1:pop
    population(i)=Chromosome;
    population(i)=initialize(population(i),dim);
    if i<=pop1
        population(i).skill_factor=1;
    else
        population(i).rnvec = population(i-pop1).rnvec;
        population(i).skill_factor=2;
    end
end
for i=1:pop
    population(i)=evaluate(population(i),GModel,FModel,Mat,M,L,U);
end

population_T1=population([population.skill_factor]==1);
population_T2=population([population.skill_factor]==2);
no_of_objs_T1 = length(population_T1(1).objs_T1);
no_of_objs_T2 = length(population_T2(1).objs_T2);
[population_T1,frontnumbers]=SolutionComparison.nondominatedsort(population_T1,pop1,no_of_objs_T1);
[population_T1,~]=SolutionComparison.diversity(population_T1,frontnumbers,pop1,no_of_objs_T1);
[population_T2,frontnumbers]=SolutionComparison.nondominatedsort(population_T2,pop2,no_of_objs_T2);
[population_T2,~]=SolutionComparison.diversity(population_T2,frontnumbers,pop2,no_of_objs_T2);

population(1:pop1) = population_T1;
population(pop1+1:pop) = population_T2;


GTX = TX;
GTY = TY;

FTX = TX;
FTY = TY;
TX = [];

ATY2  =[];
THETA = 5.*ones(M,dim);
RBFval = [];
PRval = [];

population_T2 = population(pop1+1:pop);
Apopulation = population_T2;
poplen = pop2;

Unum = ceil(rmp*dim);
Cnum = dim-Unum;
ind = randperm(dim);
Uind = ind(1:Unum);
Cind = ind(1+Unum:dim);
CTX = FTX(:,Cind);
GModel = cell(M,1);
for m = 1:M
    PRmodel=POLY(CTX,FTY(:,m),'quad');
    GModel{m}   = PRmodel;
end

for generation=1:gen

        Ty = [];
        Tx = [];
        for i = 1:pop2
            x = population_T2(i).rnvec;
            Tx = [Tx;x];
            Ty = [Ty;population_T2(i).objs_T2];
        end
        RBFval = [RBFval;Ty];
        GTX = [GTX;Tx];
        GTY = [GTY;Ty];
        
        TX = [TX;Tx];
        
        TY2=Bench_Func('value',Tx, KIND);
        ATY2 = [ATY2;TY2];
        
    [population_T1,Cind,THETA] = Gsearch(population_T2,GModel,FModel,[FTX,FTY],Cind,Cnum,M,rmp,pop1,TL,L(Cind),U(Cind),THETA);
    population(1:pop1) = population_T2;
    for i = 1:length(population_T2)
        population(i).rnvec(Cind)=population_T1(i).rnvec;
    end
     
    rndlist=randperm(pop);
    population=population(rndlist);
    for i = 1:pop       % Performing binary tournament selection to create parent pool
        parent(i)=Chromosome();
        p1=1+round(rand(1)*(pop-1));
        p2=1+round(rand(1)*(pop-1));
        if population(p1).rank < population(p2).rank
            parent(i) = population(p1);
        elseif population(p1).rank == population(p2).rank
            if rand(1) <= 0.5
                parent(i) = population(p1);
            else
                parent(i) = population(p2);
            end
        else
            parent(i) = population(p2);
        end
    end
    count=1;
    Dparent1 = randperm(pop);
    
    for i=1:2:pop-1 % Create offspring population via mutation and crossover
        child(count)=Chromosome;
        child(count+1)=Chromosome;
        p1=Dparent1(i);
        p2=Dparent1(i+1);
        [child(count).rnvec,child(count+1).rnvec]=Evolve.crossover(parent(p1).rnvec,parent(p2).rnvec,muc,dim,0);
        child(count).rnvec = Evolve.mutate(child(count).rnvec,mum,1/dim,dim);
        child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,mum,1/dim,dim);
        sf1 = round(rand(1));
        sf2 = round(rand(1));

        if sf1==1
            child(count).skill_factor= 1;
            child(count+1).skill_factor= 2;
        else
            child(count).skill_factor=2;
            child(count+1).skill_factor= 1;
        end
        count=count+2;
    end
    
    CRBFval = [];

    count = 1;
    cpop = length(child);
    for i=1:cpop
        if child(i).skill_factor==2
            child(i)=evaluate(child(i),GModel,FModel,Mat,M,L,U);
            CRBFval = [CRBFval;child(i).objs_T2];
            count = count+1;
        end
    end
        cpop2 = count-1;
        child2 = child([child.skill_factor]==2);
        population=reset(population,pop);
%         intpopulation_T2=intpopulation([intpopulation.skill_factor]==2);
        intpopulation_T2 = Chromosome;
        intpopulation_T2(1:pop2) = population_T2;
        intpopulation_T2(1+pop2:pop2+cpop2) = child2;
        T2_pop=length(intpopulation_T2);
        
%         NSGA-IIÑ¡Ôñ    
        intpopulation_T2 = reset(intpopulation_T2,T2_pop);
        [intpopulation_T2,frontnumbers]=SolutionComparison.nondominatedsort(intpopulation_T2,T2_pop,no_of_objs_T2);
        [intpopulation_T2,~]=SolutionComparison.diversity(intpopulation_T2,frontnumbers,T2_pop,no_of_objs_T2);
        population_T2 = intpopulation_T2(1:pop2);
        
 
        population =  Chromosome;
        population(pop1+1:pop) = population_T2;
        Apopulation(poplen+1:poplen+pop2) = population_T2;
        poplen = poplen+pop2;
       
        GTX = roundn(GTX,-3);
        [~,uind] = unique(GTX,'rows');
        GTX = GTX(uind,:);
        GTY = GTY(uind,:);
          
        Maxgt = (dim+1)*(dim+2)/2+dim;
      
        Unum = ceil(rmp*dim);
        Cnum = dim-Unum;
        ind = randperm(dim);
        Uind = ind(1:Unum);
        Cind = ind(1+Unum:dim);
        CTX = FTX(:,Cind);
        GModel = cell(M,1);
        for m = 1:M
            PRmodel=POLY(CTX,FTY(:,m),'quad');
            GModel{m}   = PRmodel;
        end
        
    disp(['MFEA Generation ', num2str(generation)])
end

MFEA_data.ATY2 = ATY2;
MFEA_data.RBFval = RBFval;
MFEA_data.PRval = PRval;
MFEA_data.TX = TX;

end