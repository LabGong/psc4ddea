function SOEA_data = SRBFSOEA(pop,gen,FModel,L,U,dim,Mat,fun_num,change_instance,item,run,W,OldVec)
clc
tic
selection_process = 'elitist';

for i=1:pop
    population(i)=Chromosome;
    population(i)=initialize(population(i),dim);
    population(i).skill_factor=2;
    population(i).CW = W;
end

   ypop = min(size(OldVec,1),pop);
   for i = 1:ypop
       population(i).rnvec = OldVec(i,:);
   end

for i = 1 : pop
    population(i)=evaluate_SOO(population(i),FModel,FModel,Mat,W,2,1);
end

bestobj=min([population.factorial_costs]);
EvBestFitness(1) = bestobj;

muc = 20;     % Index of Simulated Binary Crossover (tunable)
mum = 20;    % Index of polynomial mutation
RBFval = [];
ATY = [];
ATX=[];
for generation = 1:gen
    
    indorder = randperm(pop);
    count=1;
    for i = 1 : pop/2
        p1 = indorder(i);
        p2 = indorder(i+(pop/2));
        child(count)=Chromosome();
        child(count+1)=Chromosome();
        [child(count).rnvec,child(count+1).rnvec]=Evolve.crossover(population(p1).rnvec,population(p2).rnvec,muc,dim,0);
        child(count).rnvec = Evolve.mutate(child(count).rnvec,mum,1/dim,dim);
        child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,mum,1/dim,dim);
        count=count+2;
    end
    for i = 1 : pop
        child(i).CW = W;
        child(i)=evaluate_SOO(child(i),FModel,FModel,Mat,W,2,1);
    end
    
    intpopulation(1:pop)=population;
    intpopulation(pop+1:2*pop)=child;
    [xxx,y]=sort([intpopulation.factorial_costs]);
    intpopulation=intpopulation(y);
    population=intpopulation(1:pop);
%     for i = 1:2*pop
%         intpopulation(i).scalar_fitness=1/i;
%     end
%     if intpopulation(1).factorial_costs<=bestobj
%         bestobj=intpopulation(1).factorial_costs;
%         bestInd_data=intpopulation(1);
%     end
%     EvBestFitness(generation)=bestobj;
%     
%     if strcmp(selection_process,'elitist')
%         [xxx,y]=sort(-[intpopulation.scalar_fitness]);
%         intpopulation=intpopulation(y);
%         population=intpopulation(1:pop);
%     elseif strcmp(selection_process,'roulette wheel')
%         for i=1:pop
%             population(i)=intpopulation(RouletteWheelSelection([intpopulation.scalar_fitness]));
%         end
%     end
    disp(['SRBFSOEA', ' Item ', num2str(item), ' Run ', num2str(run), ' MOO Generation ', num2str(generation)])
    
    T_data=[];
    Vec=[];
    TY=[];
%     for i=1:pop
%         T_data = [T_data;population(i).factorial_costs];
%         Vec =  [Vec;population(i).rnvec];
%         Tx = population(i).rnvec*(U-L)+L;
%         [Ty,~] = DBG(Tx,fun_num,change_instance,item-1,run,dim);
%         TY = [TY;Ty];
%     end
%     fx = mean(Vec,1); 
%     Tx = Vec*(U-L)+L;
%     [fy,~] = DBG(mean(Tx,1),fun_num,change_instance,item-1,run,dim);
%     RBFval = [RBFval;T_data(1)];
%     ATY = [ATY;fy];
%     ATX = [ATX;Vec];
    
end
    for i=1:pop
%         T_data = [T_data;population(i).factorial_costs];
        Vec =  [Vec;population(i).rnvec];
%         Tx = population(i).rnvec*(U-L)+L;
%         [Ty,~] = DBG(Tx,fun_num,change_instance,item-1,run,dim);
%         TY = [TY;Ty];
    end
fx = mean(Vec,1); 
Tx = Vec*(U-L)+L;
[fy,~] = DBG(mean(Tx,1),fun_num,change_instance,item-1,run,dim);


SOEA_data.RBFval = RBFval;
SOEA_data.ATY = ATY;
SOEA_data.ATX = ATX;
SOEA_data.fx = fx;
SOEA_data.fy = fy;
end