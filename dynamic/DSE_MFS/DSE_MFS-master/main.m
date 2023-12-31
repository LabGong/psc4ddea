function main()
% clear all

addpath(genpath('RBF'));
ub = 5;
lb = -5;
Max_FES = 60;
Max_runs = 20;
gen = [5,10,20,30,50];
dim =10;
%     TestX10 = lhsdesign(10000,dim);
%     save('TestX10','TestX10')

NP = 100;
Maxitem = 15;
fun_num = 6;
Samplen = 5*dim;
change_instance = 1;
Tgbest = [];
Acorre = [];
for dim = [10]
    for gen = 20
        EMat=[];
        TX = [];
        TY = [];
        Gmat=[];
        for run = 1:Max_runs
            tic;
            for item = 1:Max_FES
                TX1 = lhsdesign(Samplen,dim);
                TTX1 = TX1*(ub-lb)+lb;
                TY1=[];
                for i = 1:Samplen
                    [f,h] = DBG(TTX1(i,:),fun_num,change_instance,item-1,run,dim);
                    TY1 = [TY1;f];
                end
                Sbest = min(TY1);
                Tgbest(run,item) = min(h);
                SREMS = [];
                Alldata(run,item).TX = TX1;
                Alldata(run,item).TY = TY1;
                AMat{run,item} = [TX1,TY1];
                EFModel=[];
                
                
                REMS=[];
                CREMS=[];
                Curitem = min(item-1,Maxitem-1);
                W = 1;
                cmat = [TX1,TY1];
                Gmat = cmat;
                if item > 1
                    Sind = zeros(item-1,1);
                    Sind(1:item-1) = 1:item-1;    %Sind  要利用的历史环境的下标
                    for i = 1:item-1
                        obj=Mbenchmark(TX1,Allmodel,AMat,i,run,2);
                        rems = sqrt(sum((obj-TY1).^2,1)/size(TY1,1));
                        SREMS = [SREMS;rems];
                    end
                    if item>Maxitem               %%筛选要选用的历史数据
                        [~,Ind] = sort(SREMS);
                        Sind = zeros(Maxitem-1,1);
                        Sind = Ind(1:Maxitem-1);
                    end
                    
                    for i = 1:Curitem+1
                        Obj = zeros(size(TY1));
                        if i == Curitem+1
                            TX = [];
                            TY = [];
                        else
                            TX = Alldata(Sind(i)).TX;
                            TY = Alldata(Sind(i)).TY;
                            Gmat = [Gmat;[TX,TY]];
                        end
                        for k = 1:Samplen
                            testx = TX1(k,:);
                            testy = TY1(k,:);
                            trix = TX1;
                            triy = TY1;
                            trix(k,:)=[];
                            triy(k,:)=[];
                            ETX=[TX;trix];
                            ETY=[TY;triy];
                            [RBFmodel, time] = rbfbuild(ETX,ETY, 'TPS');
                            obj=Mbenchmark(testx,RBFmodel,[ETX,ETY],i,run,1);
                            Obj(k) = obj;
                        end
                        if i==Curitem+1
                           rems = sqrt(sum((Obj-TY1).^2,1)/size(TY1,1)); 
                        else
                            rems = SREMS(Sind(i));
                        end
                        
                        REMS = [REMS; rems];
                        EMat{i} = [ETX,ETY];
                        EFModel{i}   = RBFmodel;
                    end 
                    REMS(1:end-1) =  REMS(1:end-1) + REMS(end);
                else
                   REMS = 1; 
                end

                EMat{Curitem+1} = [TX1,TY1];
                [RBFmodel, time] = rbfbuild(TX1,TY1, 'TPS');
                EFModel{Curitem+1}   = RBFmodel;
                Allmodel{item} = RBFmodel;
                
                W = 1./REMS;
                W = W./repmat(sum(W,1),Curitem+1,1);
                EVec=[];
                SVec=[];
                filename = sprintf('AMatF%d', Samplen);
                save (filename, 'AMat');
                
                filename = sprintf('TgbestD%dG%d', dim,gen);
                save (filename, 'Tgbest');
                
%                 ERBFSOEA_data(item,run) = SRBFSOEA(NP,gen,EFModel,lb,ub,dim,EMat,fun_num,change_instance,item,run,W,SVec);  %集成模型单任务优化
%                 
%                 filename = sprintf('ERBFSOEA_dataF%dT2D10S%d', fun_num,change_instance);
%                 save (filename, 'ERBFSOEA_data');

                toc;
                time = toc;
                
                result = ERBFMFEA(NP,gen,EFModel,lb,ub,dim,EMat,fun_num,change_instance,item,run,W,EVec);  %集成模型多任务优化
                result.time = time;
                ERBFMFEA_data(item,run) = result;
                filename = sprintf('ERBFMFEA_dataD%dG%d', dim, gen);
                save (filename, 'ERBFMFEA_data');
            end
        end
    end
end
end