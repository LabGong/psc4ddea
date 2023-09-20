function [population,Cind,THETA] = Gsearch(population,GModel,FModel,Mat,Cind,Cdim,M,rmp,pop,Subgen,L,U,THETA)

        
% for m = 1:M
%     GPmodel     = dacefit(FTX,FTY(:,m),'regpoly0','corrgauss',Theta(m,:),1e-5.*ones(1,Cnum),100.*ones(1,Cnum));
%     LModel{m}   = GPmodel;
%     Theta(m,:)  = GPmodel.theta;
% end
% THETA(:,Cind) = Theta;

Vec = [];
PGPval = [];
PPRval = [];

for i = 1:pop
    nvec = population(i).rnvec;
    Vec = [Vec;nvec];
    population(i)=Chromosome;
    population(i)=initialize(population(i),Cdim);
%     population(i).rnvec(Uind) = nvec(Uind);
    population(i).skill_factor=1;
    population(i)=evaluate(population(i),GModel,FModel,Mat,M,L,U);
    x = population(i).rnvec;
    PPRval = [PPRval;population(i).objs_T1];
end
    [population,frontnumbers]=SolutionComparison.nondominatedsort(population,pop,M);
    [population,~]=SolutionComparison.diversity(population,frontnumbers,pop,M);

muc = 20;    % Index of Simulated Binary Crossover (tunable)
mum = 20;    % Index of polynomial mutation
for generation = 1: Subgen
        rndlist=randperm(pop);
        population=population(rndlist);
        for i = 1:pop                % Performing binary tournament selection to create parent pool
            parent(i)=Chromosome();
            p1=1+round(rand(1)*(pop-1));
            p2=1+round(rand(1)*(pop-1));
            if population(p1).rank < population(p2).rank
                parent(i) = population(p1);
            else
                parent(i) = population(p2);
            end
        end
%     parent = population;
    Dparent1 = randperm(pop);
    count=1;
    for i = 1 : 2: pop
         child(count)=Chromosome;
         child(count+1)=Chromosome;
         p1=Dparent1(i);
         p2=Dparent1(i+1);
        [child(count).rnvec,child(count+1).rnvec]=Evolve.crossover(parent(p1).rnvec,parent(p2).rnvec,muc,Cdim,0);
        child(count).rnvec = Evolve.mutate(child(count).rnvec,Cdim,1/Cdim,Cdim);
        child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,Cdim,1/Cdim,Cdim);
        child(count).skill_factor=parent(p1).skill_factor;
        child(count+1).skill_factor=parent(p2).skill_factor;
        count=count+2;
    end
    CGPval = [];
    CPRval = [];
    cpop = length(child);
    for i = 1 : cpop
        child(i).skill_factor=1;
        child(i)=evaluate(child(i),GModel,FModel,Mat,M,L,U);
        x = population(i).rnvec;
        CPRval = [CPRval;child(i).objs_T1];
    end
    population=reset(population,pop);
    intpopulation(1:pop)=population;
    intpopulation(pop+1:cpop+pop)=child;
    
    PRval  =[PPRval;CPRval];
    GPval  =[PGPval;CGPval];
    Obj = PRval;

    [FrontNO,~] = P_sort(Obj,'fixed',2*pop);
    Con     = sum(Obj,2);
    Con     = FrontNO'*(max(Con)-min(Con)) + Con;
    oldCon  = Con(1:pop);
    newCon  = Con(pop+1:2*pop);
    updated = find(oldCon > newCon);
    
    for i = 1:pop
        population(i).rank = oldCon(i);
    end
    for i = 1:length(updated)
        population(updated(i)) = child(updated(i));
        population(updated(i)).rank = newCon(updated(i));
        PPRval(updated(i),:) = CPRval(updated(i),:);
%         PGPval(updated(i),:) = CGPval(updated(i),:); 
    end  
end
    [population,frontnumbers]=SolutionComparison.nondominatedsort(population,pop,M);
    [population,~]=SolutionComparison.diversity(population,frontnumbers,pop,M);
end