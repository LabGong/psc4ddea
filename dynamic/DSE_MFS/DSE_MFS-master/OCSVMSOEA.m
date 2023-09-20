% This trial version of the Multi-Objective Multifactorial Evolutionary Algorithm (MO-MFEA: which is based on NSGA-II) has been
% developed to handle only two "continuous" multiobjective problems (or tasks) at a time.
% Each problem may comprise upto three objective functions.
% Generalization to many-tasking can be done based on this framework.
function OCSVM_data=OCSVMSOEA(pop,gen,L,U,dim,Mat,fun_num,change_instance,item,run,OldVec)
clc
tic
selection_process = 'elitist';
OCSVMval=[];
ATY = [];
ATX=[];
    cmat = Mat;
    csample = cmat(:,end);
    csamplex = cmat(:,1:end-1);
    
    osample = ceil(0.1*size(csamplex,1));
    [~,ind] = sort(csample);
    SVMsample = csamplex(ind(1:osample),:);

    for i=1:pop
        population(i) = Chromosome;
        population(i) = initialize(population(i),dim);
    end

    ypop = min(size(OldVec,1),pop);


 nu = 0;           % nu -> [0,1] 在支持向量数与错分样本数之间进行折衷
% 支持向量机的 nu 参数(取值越小，异常点就越少)
ker = struct('type','gauss','width',500);
svmmodel = svmTrain('svm_one_class',SVMsample',[],ker,nu);
    


muc = 20;     % Index of Simulated Binary Crossover (tunable)
mum = 20;     % Index of polynomial mutation
for generation=1:gen
    
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
    
    
    PVec = [];
    for i = 1:pop
        PVec = [PVec;population(i).rnvec];
    end
    
    CVec=[];
    for i=1:pop
        CVec = [CVec;child(i).rnvec];
    end
    AVec = [CVec;PVec];
    [cvmp,vmpr] = svmSim(svmmodel,AVec');           % 测试输出
    cvmpr = vmpr(1:pop);
    pvmpr = vmpr(1+pop:end);
    
    for i=1:pop
        child(i).factorial_costs = cvmpr(i);
    end
    for i=1:pop
        population(i).factorial_costs = pvmpr(i);
    end
    
    intpopulation(1:pop)=population;
    intpopulation(pop+1:2*pop)=child;
    [xxx,y]=sort([intpopulation.factorial_costs]);
    intpopulation=intpopulation(y);
    population=intpopulation(1:pop);
    
    T_data=[];
    Vec=[];
    TY=[];
    for i=1:pop
        T_data = [T_data;population(i).factorial_costs];
        Vec =  [Vec;population(i).rnvec];
        Tx = population(i).rnvec*(U-L)+L;
        [Ty,~]=DBG(Tx,fun_num,change_instance,item-1,run,dim);
        TY = [TY;Ty];
    end
    OCSVMval = [OCSVMval;T_data];
    ATY = [ATY;TY];
    ATX = [ATX;Vec];
    
%         figure(3)
%         plot(TY,'.r');
%         hold on
%         plot(T_data,'ob');
%         fvec = mean(Vec(gpop+1:pop,:),1);
%     
%         fobj(1) = DBG(fvec,fun_num,change_instance,item-1,run,dim);
%         fobj(2) = DBG(mean(csamplex,1),fun_num,change_instance,item-1,run,dim);
%         plot(csample,'ok');
%         pause(0.5);
%         hold off

   disp(['OCSVMSOEA', ' Item ', num2str(item), ' Run ', num2str(run), ' MOO Generation ', num2str(mean(TY(51:100)))])
   
end

nu = 0;           % nu -> [0,1] 在支持向量数与错分样本数之间进行折衷
% 支持向量机的 nu 参数(取值越小，异常点就越少)
ker = struct('type','gauss','width',500);
svmmodel = svmTrain('svm_one_class',SVMsample',[],ker,nu);
[svmp,svmpr] = svmSim(svmmodel,Vec');           % 测试输出

ofx = mean(Vec,1);
[ofy,~] = DBG(ofx*(U-L)+L,fun_num,change_instance,item-1,run,dim);

[~,mind] = min(svmpr);
fx = (Vec(mind,:));
[fy,~] = DBG(fx*(U-L)+L,fun_num,change_instance,item-1,run,dim);

OCSVM_data.Sval = OCSVMval;
OCSVM_data.ATY = ATY;
OCSVM_data.ATX = ATX;
OCSVM_data.ofx = ofx;
OCSVM_data.ofy = ofy;
OCSVM_data.fx = fx;
OCSVM_data.fy = fy;
end