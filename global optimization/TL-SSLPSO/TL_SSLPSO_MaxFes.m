%========================================================================================================================
%%%*********************************************************************************************************%%%
%% Implementation of Truncation-learning-driven surrogate assisted social learning particle swarm optimization for computationally expensive problem (TL-SSLPSO)
%% Haibo Yu , Li Kang , Ying Tan, Chaoli Sun , Jianchao Zeng,
%% Published in:Applied Soft Computing��Volume 97, Part A,?December 2020, 106812)
%%%*********************************************************************************************%%%
%% This paper and this code should be referenced whenever they are used to 
%% generate results for the user's own research. 
%%%*********************************************************************************************%%%
%% This matlab code was written by Haibo Yu
%% Please refer with all questions, comments, bug reports, etc. to tyustyuhaibo@126.com 
% % 
%=======================================================================================================================
clear,clc
rng('default');
rng('shuffle');
warning('off');
% d=51;% Stepped Cantilever Beam Design Problem
d=30; % d chosen from {30,50,100}
maxfes=1000;% temination by maximum number of FES

funcnum=1; % funcnum chosen from {1,2,,3,4,5,10,16,19}

if funcnum==1 %---Ellipsoid 
    fname='ellipsoid';
    Xmin=-5.12;Xmax=5.12;
    VRmin=-5.12;VRmax=5.12;
elseif funcnum==2 %---Rosenbrock
    fname='rosenbrock';
    Xmin=-2.048;Xmax=2.048;
    VRmin=-2.048;VRmax=2.048;
elseif funcnum==3 %---Ackley 
    fname='ackley';
    Xmin=-32.768;Xmax=32.768;
    VRmin=-32.768;VRmax=32.768;
elseif funcnum==4 %---Griewank
    fname='griewank';
    Xmin=-600;Xmax=600;
    VRmin=-600;VRmax=600;
elseif funcnum==5 %---Rastrigins 
    fname='rastrigin';
    Xmin=-5.12;Xmax=5.12;
    VRmin=-5.12;VRmax=5.12;
elseif funcnum==10 || funcnum==16 || funcnum==19 % CEC 2005 function F10/F16/F19
    fname='benchmark_func';
    Xmin=-5;Xmax=5;
    VRmin=-5;VRmax=5;
end

sn1=2;  gfs=zeros(1,fix(maxfes/sn1));   CE=zeros(maxfes,2);     % sampling setting according to FES

time_begin=tic;
runnum=30;

for run=1:runnum
    %---------------Initialization-----------------
    M = 100;      m = M + fix(d/10); % ��Ⱥ��ģ (��ȡ��)
%%  Invariable C3
    c3 =0; % c3 >-1 guarantee convergence
% % %     beta=0.01; c3 = d/M*beta;     % epsilon    
%%
    PL = 1;
%     
    %initialization
    p = zeros(m, d); 
    v = zeros(m, d);    

    lu = [Xmin.* ones(1, d); Xmax.* ones(1, d)];
    FES = 0;    gen = 0;       
% % %     rand('seed', sum(100 * clock));

    % ----------*** Initialization *** Method -------- (IT1)
    XRRmin = repmat(lu(1, :), m, 1);
    XRRmax = repmat(lu(2, :), m, 1);
    p = XRRmin + (XRRmax - XRRmin) .* lhsdesign(m, d);          % ��Ⱥ��ʼ��: LHS
    fitness=zeros(1,m);
    for ii=1:m
        fitness(ii) = feval(fname,p(ii,:));
        FES=FES+1;
        if FES <= maxfes 
            CE(FES,:)=[FES,fitness(ii)];
            if mod (FES,sn1)==0
                cs1=FES/sn1;
                gfs(1,cs1)=min(CE(1:FES,2));
            end
        end
    end                                                     % �����ʼ��Ⱥ��Ӧֵ
    hx=p;   hf=fitness;                                       % ��ʼ����ʷ���ݿ�
    
    [bestever,id] = min(fitness);
    gbpos=p(id,:);                                          % ��Ӣ��������: ��Ⱥ���Ÿ���λ��
    %----------------End initialization------------------
%%
    % ͨ�����ò���group_num ���л��Ա��㷨(RBF-SLPSO vs. TL-SSLPSO)
    group_num = 3; % // group_num=1 ---> RBF-SLPSO(S-SLPSO) // *** group_num>1--->Population division-based RBF-SLPSO (TL-SSLPSO) ***// take the value of 3 is of the best according to the sensitivity analysis
    %% �����Ȳ���������3��5��7��10��15
    %% ���ݲ���������ʵ�������ֳ�3�飬����Ч���Ϻ�
    
    %main loop
    while(FES < maxfes)                    
%         fprintf('Iteration: %d Fitness evaluation: %d Best fitness: %e\n', gen, FES, bestever);% Ӧ��ÿ����һ�Σ���ʾһ�Σ�������ÿ����һ����ʾһ�Σ�Ӧ��������if���棩
        
        %% population segmentation
        if gen >= 1 && group_num~=1  % group_num=1 denotes the comparison algorithm: RBF-SLPSO algorithm
            % Equal division
            num_c=group_num;
            [~,idx]=sort(fitness); % �ָ�ǰ�������ݰ���Ӧֵ��С�����������
            idx=buffer(idx,ceil(m/num_c)); % idx ��ÿһ�ж�Ӧÿһ�ָ�������������ָ�꼯      
            
            p_id=cell(num_c,1);% ��������Ⱥ�����ָ�꼯[��ʼ��]
            pos_mean=cell(num_c,1);% ��������Ⱥ���弯��ƽ��λ��
            centroid=cell(num_c,1);% ���������λ��
            nc=zeros(1,num_c);% ���������������
            cf_mean=zeros(1,num_c);
            for i=1:num_c % divide database into m levels according to the fitness value
                % Equal division
                k=idx(:,i); k(k==0)=[];  
                pos_i=p(k,:);% positions of samples in ith cluster/group               
                cf=fitness(k);   cf_mean(i)=mean(cf); % mean fitness value of ith cluster/group
                centroid{i}=mean(pos_i); % the centroid of ith cluster/group
                [~,~,ip]=intersect(pos_i,p,'rows');
                if ~isempty(ip) == 1
                    p_id{i}=ip; % record the index of candidate individual belonging to the ith cluster/group
                    pos_mean{i}=mean(p(ip,:));
                else
                    p_id{i}=[];
                    pos_mean{i}=[];
                end              
                
                nc(i)=length(p_id{i});% number of samples in ith cluster/group
                
                % count the number of hx and p in ith cluster
                if i == 1 % the group of the highest-level sub-population
                    [~,ihh,~]=intersect(hx,pos_i,'rows');
                    if ~isempty(ihh)==1
                        num_hx=length(ihh);
                        num_p=nc(i)-num_hx;
                    else
                        num_hx=0;
                        num_p=nc(i);
                    end
                    num_app(gen,:)=[num_hx,num_p];
                end
                
            end

            [cf_mean,icf]=sort(cf_mean,'descend'); % �������У�according to fitness mean value of each cluster
            
            nc=nc(icf);                  % ������Ӧ��������������
            p_id=p_id(icf);              % ������Ӧ�����и����ָ�꼯
            pos_mean=pos_mean(icf);      % ������Ӧ��������Ⱥ�����ƽ��λ��
            centroid=centroid(icf);      % ������Ӧ����������ƽ��λ�ã����ģ�      
            
        end

       %% ********************* Phase 2 ************************ behavioral learning       
        if gen < 1
            %population sorting        
            [fitness,rank] = sort(fitness, 'descend');                 % �������ɴ�С����������   
            p = p(rank,:);
            v = v(rank,:); 
            %center position
            center = ones(m,1)*mean(p);
            %random matrix
            randco1 = rand(m, d);
            randco2 = rand(m, d);
            randco3 = rand(m, d);
            winidxmask = repmat([1:m]', [1 d]);
            winidx = winidxmask + ceil(rand(m, d).*(m - winidxmask));
%             winidx = m - floor(0.5*rand(m, d).*(m - winidxmask));    
            pwin = p;
            for j = 1:d
                pwin(:,j) = p(winidx(:,j),j);              % ÿһ������ĵ�jάԪ�ع���ѧϰ�����ĵ�jά
            end
            %learning
%             rand('seed', sum(100 * clock));
            lpmask = repmat(rand(m,1) < PL, [1 d]);
            lpmask(m,:) = 0;                              % ���ŵĵ�m�����岻ѧϰ
            v1 =  1*(randco1.*v + randco2.*(pwin - p) + c3*randco3.*(center - p));
            p1 =  p + v1;   
            v = lpmask.*v1 + (~lpmask).*v;                % �����Ÿ�����ʣ����嶼ѧϰ
            p = lpmask.*p1 + (~lpmask).*p;                % �������Ÿ��嵽��һ������m�����岻ѧϰ
        else
            for i = 1:group_num   
                p_index=p_id{i}(:,:);
                nn=length(p_index); % number of candidate inviduales in ith cluster/group                 
                if i == group_num % �������������Ⱥ�����ѧϰ
                    if nn == 1 % ֻ����һ����Ⱥ����
                        continue;% �������ڵĸ��岻ѧϰ
                    elseif group_num == 1 % *(comparison algorithm��RBF-SLPSO�㷨)* ��ѧϰ:ʵ�鷢�֣���ѧϰ�����ƻ�Ǳ�����Ž⣬����Ⱥ������
                        sam=[]; fit=[];                                
                        sam=p(p_index,:);
                        fit=fitness(p_index);
                        v_tmp=v(p_index,:);
                        [~,rank]=sort(fit,'descend');                    
                        sam=sam(rank,:);
                        fit=fit(rank);                                
                        %random matrix
                        randco1 = rand(nn, d);
                        randco2 = rand(nn, d);                    
                        randco3 = rand(nn, d);
                        winidxmask = repmat([1:nn]', [1 d]);
                        winidx = winidxmask + ceil(rand(nn, d).*(nn - winidxmask));   
                        pwin = sam;
                        for j = 1:d
                            pwin(:,j) = sam(winidx(:,j),j);              % ÿһ������ĵ�jάԪ�ع���ѧϰ�����ĵ�jά
                        end
                        %learning
                        lpmask = repmat(rand(nn,1) < PL, [1 d]);
                        lpmask(nn,:) = 0;                              % ���ŵĵ�m�����岻ѧϰ    
                        v1 =  1*(randco1.*v_tmp + randco2.*(pwin - sam) + c3*randco3.*(ones(nn,1)*pos_mean{i}(:,:) - sam)); % Main strategy:�����������ѧϰ��֤�㷨�������ԣ�ͬʱ�ֹ�����Ⱥ��ƽ����Ϣ��֤�㷨�Ķ�����,recall c3=0;
                        p1 =  sam + v1;   
                        v_tmp = lpmask.*v1 + (~lpmask).*v_tmp;                % �����Ÿ�����ʣ����嶼ѧϰ
                        sam = lpmask.*p1 + (~lpmask).*sam;                % �������Ÿ��嵽��һ������m�����岻ѧϰ

                        idd = p_index;
                        idd = idd(rank);
                        p(idd,:)=sam;
                        v(idd,:)=v_tmp;       

                        continue;  
                    else
                        continue
                    end
                    
                end                       
                    
                %% ��Ҫ�ҵ��ȵ�ǰ���θߵ������� (Demonstrator selection)
                id_demo=i+1:group_num; % ����DB��������Ⱥ��������и߲��� (Main strategy) 
                num_democluster=length(id_demo);                    

                for j = 1:d
                    %% competitive selection ---> RBF-SLPSO-division (TL-SSLPSO-B)
%                     if num_democluster == 1
%                         dim_cluster = num_c;
%                     else
%                         id=randperm(num_democluster);
%                         dim_cluster=id_demo(id(1:2)); % j ά���� demonstrator *��ָ��*                        
%                         % ��ͬ��level-based pso�бȽϸ߲���������ԣ�random pair���������Ӧֵ,��������ѡȡ�Ƚϸ߲�������Ӧֵ��ֵ��ѡȡ�������еĸ�����Ϊ��ǰ�����demonstrators
%                         if cf_mean(dim_cluster(1)) < cf_mean(dim_cluster(2)) 
%                             dim_cluster=dim_cluster(1);
%                         else
%                             dim_cluster=dim_cluster(2);
%                         end                       
%                     end

                    %% random selection ---> RBF-SLPSO-division-random (TL-SSLPSO-R)
                    id=randi(num_democluster); % randomly select one---> for comparison
                    dim_cluster=id_demo(id);
                    %%                    
                    demo_p=p(p_id{dim_cluster}(:,:),:);
                    demonstrator=demo_p; % (Main strategy)��demonstrator̫�࣬����ѡ���Եı������ɴ����Ե���ʷ����
                    pwin(p_index,j) = demonstrator(randi(size(demonstrator,1),1,size(p_index,1)),j);
                end

                %learning
                lpmask = repmat(rand(nn,1) < PL, [1 d]); 
                %random matrix
                randco1 = rand(nn, d);
                randco2 = rand(nn, d);
                randco3 = rand(nn, d);     
                v1 =  1*(randco1.*v(p_index,:) + randco2.*(pwin(p_index,:)  - p(p_index,:)) + c3*randco3.*(ones(nn,1)*pos_mean{i}(:,:) - p(p_index,:))); % Main strategy

                p1 =  p(p_index,:) + v1;   
                v(p_index,:) = lpmask.*v1 + (~lpmask).* v(p_index,:);                % �����Ÿ�����ʣ����嶼ѧϰ
                p(p_index,:) = lpmask.*p1 + (~lpmask).* p(p_index,:);                % �������Ÿ��嵽��һ������m�����岻ѧϰ
            end
        end
        %boundary
        for i = 1:m
            p(i,:) = max(p(i,:), lu(1,:)); % �½�
            p(i,:) = min(p(i,:), lu(2,:)); % �Ͻ�
        end                       
        
        gen = gen + 1;  
        
% % %         % compute swarm diversity
% % %         p_mean=mean(p);
% % %         distance=real(sqrt(p_mean.^2*ones(size(p'))+ones(size(p_mean))*(p').^2-2*p_mean*(p')));
% % %         diversity(gen)=max(distance);
        
        %% RBF-modeling and evaluation
        % select training samples% ��Χ��ǰ������Ⱥ�� DB ���� ------> �ֲ�ģ�ͣ�local��
        NS=2*(d+1);                                    % *** �㷨���ܲ��� ***
        phdis=real(sqrt(p.^2*ones(size(hx'))+ones(size(p))*(hx').^2-2*p*(hx')));        
        [~,sidx]=sort(phdis,2);                        % ÿ�ж���������   
        nidx=sidx; nidx(:,NS+1:end)=[];                % ����Ľ�������ָ�꼯����
        nid=unique(nidx);
        trainx=hx(nid,:);   
        trainf=hf(nid); 
        
        % radial basis function interpolation----(RBF-interpolation)
        flag='cubic';
        [lambda, gamma]=RBF(trainx,trainf',flag);
        FUN=@(x) RBF_eval(x,trainx,lambda,gamma,flag);

        fitness=FUN(p);     fitness=fitness';% model values
        
%% *** Expensive evaluation: individual-based evolution control **************** %%
        %% ������Ӧ�ȹ�ֵ���ڵ�ǰ���ŵĸ������ʵ��Ӧֵ��������㵱ǰ��ֵ���Ÿ������ʵ��Ӧֵ
        %% ʵ�鷢�֣������ڴ���ģ�;��ȼ������ռ����Ե�Ӱ�죬�㷨��Ѱ�Ź��̣����ɴε�������������������ĳЩ��ʵ����ʷ��������ķ��ա�
        %% ������ˣ��㷨��Ϸ���ѧϰ���ƣ�������������ЩӰ����,����֮������ѧϰ���Ƽ�Ӽ�С���㷨����ģ�;ֲ���ֵ�ĸ��ʣ���Ϊ�䱣���˲��־ֲ�������������Щ����������ѧϰ
        %% Two alternative infill sampling criteria
        pid = find(fitness < bestever);
        p_tmp = p(pid,:);
        f_tmp = fitness(pid);
        if ~isempty(p_tmp) == 1
            for i = 1 : size(p_tmp,1)
                [~,ih,~]=intersect(hx,p_tmp(i,:),'rows');
                if ~isempty(ih)==1
                    f_tmp(i)=hf(ih);
                else
                    f_tmp(i)=feval(fname,p_tmp(i,:));
                    FES=FES+1;
                    if FES <= maxfes
                        CE(FES,:)=[FES,f_tmp(i)];
                        if mod (FES,sn1)==0
                            cs1=FES/sn1;
                            gfs(1,cs1)=min(CE(1:FES,2));% the newly evaluated sample points are used to improve the accuracy of the surrogate model on one side, and on the other side, they are used as a promising leader in the evolution population
                        end
                    end
                    hx=[hx;p_tmp(i,:)];   hf=[hf,f_tmp(i)];                  % ������ʷ���ݿ�   
                end
                [bestever,ib] = min([f_tmp(i), bestever]);             % ����ȫ������         
                if ib==1
                    gbpos=p_tmp(i,:); 
                end
            end                
            fitness(pid) = f_tmp;
        else
            %% ������Ӧ�ȹ�ֵ���ŵĸ������ʵ��Ӧֵ
            [~,idx]=sort(fitness); 
            p_app=p(idx,:); f_app=fitness(idx);        
            [~,~,ip]=intersect(hx,p_app,'rows');
            p_app(ip,:)=[]; f_app(ip)=[]; % delete history samples
            
            sbest_pos=p_app(1,:);% performance ----> under limited computational cost, we prefer fast convergence performance                
            sbesty=feval(fname,sbest_pos);
            FES=FES+1;
            if FES <= maxfes
                CE(FES,:)=[FES,sbesty];
                if mod (FES,sn1)==0
                    cs1=FES/sn1;
                    gfs(1,cs1)=min(CE(1:FES,2));% the newly evaluated sample points are used to improve the accuracy of the surrogate model on one side, and on the other side, they are used as a promising leader in the evolutionary population
                end
            end
            hx=[hx;sbest_pos];   hf=[hf,sbesty];                  % ������ʷ���ݿ�   
            [bestever,ib] = min([sbesty, bestever]);             % ����ȫ������         
            if ib==1
                gbpos=sbest_pos; 
            end
            [~,ip,~]=intersect(p,p_app(1,:),'rows');
            fitness(ip)=sbesty;                
        end        
%% *****************************************************************         
 
    end
    
    fprintf('Runing Number: %d Fitness evaluation:%d Total generation: %d Best fitness:%e\n', run,FES,gen,bestever);
    
    gennum(run,:)=gen;
    
    gsamp1(run,:)=gfs;
end

best_samp=min(gsamp1(:,end));
worst_samp=max(gsamp1(:,end));
samp_mean=mean(gsamp1(:,end));
samp_median=median(gsamp1(:,end));
std_samp=std(gsamp1(:,end));
out1=[best_samp,worst_samp,samp_median,samp_mean,std_samp];
gsamp1_ave=mean(gsamp1,1);
gsamp1_log=log(gsamp1_ave);

for j=1:maxfes
    if mod(j,sn1)==0
        j1=j/sn1; gener_samp1(j1)=j;
    end
end

figure(1);
plot(gener_samp1,gsamp1_log,'.-r','Marker','.','Markersize',25,'LineWidth',2)
% semilogy(gener_samp1,gsamp1_ave,'.-r','Marker','.','Markersize',25,'LineWidth',2)
legend('TL-SSLPSO-R');
% xlim([100,maxfe]);
xlabel('Function Evaluation Calls ');
ylabel('Mean Fitness Value (Natural log)');
% % % title('2005 CEC Benchmark Function (F10)')
% % % title('2005 CEC Benchmark Function (F16)')
% % % title('2005 CEC Benchmark Function (F19)')
% % % title('Ackley Function')
% % % title('Griewank Function')
% % % title('Rastrigin Function')
% % % title('Rosenbrock Function')
% % % title('Ellipsoid Function')
set(gca,'FontSize',20);
time_cost=toc(time_begin);
time_ave=time_cost/runnum;