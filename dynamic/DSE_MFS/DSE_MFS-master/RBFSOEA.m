function SOEA_data = RBFSOEA(pop,gen,FModel,L,U,dim,Mat,fun_num,change_instance,item,run,W,MVec,AMat)
clc
tic
THETA = 5.*ones(1,dim);
Obj = [];
Mse = [];
GPTX = AMat(:,1:dim);
GPTY = AMat(:,1+dim);
GPmodel = dacefit(GPTX,GPTY,'regpoly0','corrgauss',THETA,1e-5.*ones(1,dim),100.*ones(1,dim));
selection_process = 'elitist';

for i=1:pop
    population(i)=Chromosome;
    population(i)=initialize(population(i),dim);
    population(i).skill_factor=2;
end

% if item>1
   ypop = min(size(MVec,1),pop);
   for i = 1:ypop
       population(i).rnvec = MVec(i,:);
   end
% end

for i = 1 : pop
    population(i)=evaluate_SOO(population(i),FModel,FModel,AMat,W,2,2);
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

    figure(6)
    plot(TY,'.b');
    hold on
    plot(T_data,'ob');
%     plot(Obj,'or');
%     plot(sample,'og');
    pause(0.5);
    hold off


% bestobj=min([population.factorial_costs]);
% EvBestFitness(1) = bestobj;
% 
% ATY = [];
% TX=[];
% muc = 20;     % Index of Simulated Binary Crossover (tunable)
% mum = 20;    % Index of polynomial mutation
% RBFval = [];
% RMSE=[];
% for generation = 1:gen
%     
%     indorder = randperm(pop);
%     count=1;
%     for i = 1 : pop/2
%         p1 = indorder(i);
%         p2 = indorder(i+(pop/2));
%         child(count)=Chromosome();
%         child(count+1)=Chromosome();
%         [child(count).rnvec,child(count+1).rnvec]=Evolve.crossover(population(p1).rnvec,population(p2).rnvec,muc,dim,0);
%         child(count).rnvec = Evolve.mutate(child(count).rnvec,mum,1/dim,dim);
%         child(count+1).rnvec=Evolve.mutate(child(count+1).rnvec,mum,1/dim,dim);
%         count=count+2;
%     end
%     for i = 1 : pop
%         child(i)=evaluate_SOO(child(i),FModel,FModel,AMat,W,2,2);
%     end
%     
%     intpopulation(1:pop)=population;
%     intpopulation(pop+1:2*pop)=child;
%     [xxx,y]=sort([intpopulation.factorial_costs]);
%     intpopulation=intpopulation(y);
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
%     disp(['SOO Generation ', num2str(generation), ' best objective = ', num2str(bestobj)])
%     
%     T_data=[];
%     Vec=[];
%     TY=[];
%     for i=1:pop
%         T_data = [T_data;population(i).factorial_costs];
%         Vec =  [Vec;population(i).rnvec];
%         Tx = population(i).rnvec*(U-L)+L;
%         Ty=DBG(Tx,fun_num,change_instance,item-1,run,dim);
%         TY = [TY;Ty];
%     end
%     rems = sqrt(sum((T_data-TY).^2,1)/size(TY,1));
%     RMSE = [RMSE;rems];
%     RBFval = [RBFval;T_data];
%     ATY = [ATY;TY];
%     TX = [TX;Vec];
%     [Obj,Mse] = GPMbenchmark(Vec,GPmodel);
%     len = length(Mat);
%     mat = Mat{len};
%     sample = mat(:,end);
%     
%     figure(6)
%     plot(TY,'.b');
%     hold on
%     plot(T_data,'ob');
%     plot(Obj,'or');
%     plot(sample,'og');
%     pause(0.5);
%     hold off
%     
% end


    
%     figure(2)
%     plot(T_data,'.b');
%     hold on
%     plot(Obj,'.r');
%     pause(0.5);
%     hold off
      
% SOEA_data.RBFval = RBFval;
% SOEA_data.ATY = ATY;
% SOEA_data.TX = TX;
SOEA_data.Vec = Vec;
end