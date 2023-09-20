clc
clear all
global dimension
global popsize
global max_length
global evaltimes %ʵ�ʼ������
global param1 %RBF1����
global param2 %RBF2����
global initial_flag

initial_flag=0;
dimension=30;
popsize=25;
%popsize=60;
run_times=1;
max_length=1000;
c1=2;
c2=2;
xmax=100;
xmin=-100;
vmax=100;
vmin=-100;
evaltimes=0; %���۴���
archup_number1=0; %���ݼ��и������¸���λ�ø��¸���
archup_number2=0; %���ݼ��и�����ʷ���Ÿ��¸���
param1max=0.5;
param1min=0.01;
param2max=0.5;
param2min=0.01;
param1=param1min;
spread1max=1;
spread1min=0.3;
spread2max=1;
spread2min=0.5;
param2=param2min; %��ʼ��ʱ���Ƚϸ�
format short; 

current_position=zeros(popsize,dimension);
current_velocity=zeros(popsize,dimension);
current_fitness=zeros(popsize,1);
pbest=zeros(popsize,dimension);
pbest_fitness=zeros(popsize,1);
gbest=zeros(1,dimension);
gbest_fitness=zeros(1,1);
gbest_output=[];%zeros(max_length+1);
evaltimes_output=[];%zeros(max_length+1); %������۴���
evaltimes_output1=[];%zeros(max_length+1); %���ÿһ�������۴���
%hitCount=zeros(max_length,1); %��¼��ײ����
whethercal=zeros(popsize,1);
whethereval=zeros(popsize,1);

currpos_arch=zeros(popsize,dimension+3); %�洢�������ʵ�ʼ����λ����Ϣ
nbthreshod=zeros(1,dimension); %ÿά�ϵ���ֵ

avggbest_fitness=0; %ƽ��ȫ��������Ӧֵ
 for r=1:run_times
     %��ʼ������avi�ļ�
%      aviobj=avifile('research1.avi');
    hashtable=init_hash();%��ʼ��һ��Hash��
    hashtable_position=init_hash();
    precise=4;
    totalHitCount=0;%����ǰ��Ϊֹ��������ʷλ������ײ�Ĵ���
    evaltimes=0;
    
    %��ʼ������
    for i=1:popsize
        for t=1:dimension
            current_velocity(i,t)=rand*(vmax-vmin)+vmin;
        end
    end
    dxmin=xmin;
    dxmax=dxmin+(xmax-xmin)/popsize;
    for i=1:popsize
        for t=1:dimension
            current_position(i,t)=rand*(dxmax-dxmin)+dxmin;
        end
        dxmin=dxmax;
        dxmax=dxmin+(xmax-xmin)/(popsize);
    end
    for i=1:popsize
        %current_fitness(i,1)=fitness(current_position(i,:));
        temp_position=current_position(i,:);
        initial_flag=0;
        current_fitness(i,1)=benchmark_func(temp_position,1);
        zput(hashtable_position,current_position(i,1:end),current_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
        evaltimes=evaltimes+1;
        %�洢��ʼ��ʱ����ʵ�ʼ����λ����Ϣ
        currpos_arch(i,1)=i;
        currpos_arch(i,2)=0;
        currpos_arch(i,3)=current_fitness(i,1);
        for t=1:dimension
            currpos_arch(i,t+3)=current_position(i,t);
        end
    end
    %temp_position=[-39.3119   58.8999  -46.3224  -74.6515  -16.7997  -80.5441  -10.5935   24.9694   89.8384    9.1119  -10.7443  -27.8558  -12.5806    7.5930   74.8127   68.4959  -53.4293   78.8544 -68.5957   63.7432   31.3470  -37.5016   33.8929  -88.8045  -78.7719  -66.4944   44.1972   18.3836   26.5212   84.4723];
    %initial_flag=0;
    %fittest=benchmark_func(temp_position,1);
     %
    evaltimes_output(1)=evaltimes;
    evaltimes_output1(1)=evaltimes_output(1);

     for i=1:popsize 
         pbest(i,:)=current_position(i,:);
         pbest_fitness(i,:)=current_fitness(i,:);
         zput(hashtable,pbest(i,1:end),pbest_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
     end
     
     gbest(1,:)=pbest(1,:);
     gbest_fitness(1,1)=pbest_fitness(1,1);
     for i=2:popsize
         if pbest_fitness(i,1)<gbest_fitness(1,1)
             gbest(1,:)=pbest(i,:);
             gbest_fitness(1,1)=pbest_fitness(i,1);
         end
     end
     gbest_output(1)=gbest_fitness(1,1); %�����ʼ��ʱ����ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---ȷ��spreadֵ,��������ʱ���������timenet ----�����ڹ���ȫ�ִ���ģ��
    n1=fix(rand*popsize);
    while n1==0
        n1=fix(rand*popsize);
    end
    n2=fix(rand*popsize);
    while (n2==n1 || n2==0)
        n2=fix(rand*popsize);
    end
    spread1=0;
    for t=1:dimension
        spread1=spread1+(current_position(n1,t)-current_position(n2,t))^2;
    end    
    spread1=sqrt(spread1);
     curr_pos=zeros(popsize,dimension);% �洢ÿ���������ʵ�ʼ������λ����Ϣ
     curr_fitness=zeros(popsize,1);%�洢ÿ���������ʵ�ʼ������λ����Ӧֵ��Ϣ
     for i=1:popsize
         curr_fitness(i,1)=currpos_arch(i,3);
     end
     for i=1:popsize
         for t=1:dimension
             curr_pos(i,t)=currpos_arch(i,t+3);
         end
     end
     timenet=newrb(curr_pos',curr_fitness',0.1,spread1,30);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     maxmin=0;
     for t=1:dimension
         maxmin=maxmin+(xmax-xmin)^2;
     end
     maxmin=sqrt(maxmin); %��һ����ʱ���õ�
     totalupdate1=0; %ͳ��net1�������¸���
     iter=1;
     testtotal=0; %ͳ����ʵ�����۸������ģ�͵ĸ���
     squaremse=0; %������ͳ��     
     %while (evaltimes<=10000)&&(iter<=max_length)
     while (evaltimes<=10000)
         w=0.9-0.5*(iter-1)/(max_length-1);
         distance1=zeros(size(currpos_arch,1),1);
         distance2=zeros(popsize,1);
         %whethercal=0;
         for i=1:popsize
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %---�����ٶȺ�λ��
             for t=1:dimension
                 current_velocity(i,t)=w*current_velocity(i,t)+c1*rand*(pbest(i,t)-current_position(i,t))+c2*rand*(gbest(1,t)-current_position(i,t));
                 if current_velocity(i,t)>vmax
                     current_velocity(i,t)=vmax;
                 end
                 if current_velocity(i,t)<vmin
                     current_velocity(i,t)=vmin;
                 end
                 current_position(i,t)=current_position(i,t)+current_velocity(i,t);
                 if current_position(i,t)>xmax
                     current_position(i,t)=xmax;
                 end
                 if current_position(i,t)<xmin
                     current_position(i,t)=xmin;
                 end
             end
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %---�ж��Ƿ��Ѿ����������δ�����ж���Χʵ�ʼ������λ����Ϣ�Ƿ������ֵ�����ǣ������ֲ�ģ�ͶԵ�ǰ���������Ӧֵ���ƣ���
             %����ȫ��ģ�ͶԵ�ǰ���������Ӧֵ���ơ�
             val=zget(hashtable_position,current_position(i,1:end),precise); %��hash����ȡֵ
             if isempty(val)
                 current_fitness(i,1)=sim(timenet,current_position(i,:)');
                 global_fitness(i,1)=current_fitness(i,1);
                 whethereval(i,1)=0;
                 whethercal(i,1)=0;
             else
                 current_fitness(i,1)=val;%ֱ��ʹ��hash������Ӧֵ������Ҫ����
                 currpos_arch(size(currpos_arch,1)+1,:)=[i iter current_fitness(i,1) current_position(i,:)];
                 %totalupdate1=totalupdate1+1;
                 %ͳ�Ʋ�ѯ����
                 %hitCount(iter)=hitCount(iter)+1;
                 totalHitCount=totalHitCount+1;
                 whethercal(i,1)=1;
                 whethereval(i,1)=1;
             end
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %������ʷ����λ��
%             if current_fitness(i,1)<pbest_fitness(i,1)
                 if whethereval(i,1)==0
                     for t=1:dimension
                         %nbthreshold(1,t)=0.1*(xmax-xmin); %���������ֵ
                         nbthreshold(1,t)=(xmax-xmin)/popsize;
                         %nbthreshold(1,t)=10*(xmax-xmin)/popsize;
                     end
                     [nb_keys,nb_values]=zget_nb(hashtable,current_position(i,:),nbthreshold);
                     %[nb_keys,nb_values]=zget_nb(hashtable_position,current_position(i,:),nbthreshold);
                     nbsize=numel(nb_values);
                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     %---�����������ģ��
                     if nbsize>=10
                         neighbor_info=zeros(nbsize,dimension);
                         neighbor_infofitness=zeros(nbsize,1);
                         for i1=1:nbsize
                            neighbor_info(i1,:)=nb_keys{i1};
                            neighbor_infofitness(i1,1)=nb_values{i1};
                         end
                         n1=fix(rand*nbsize);
                         while n1==0
                             n1=fix(rand*nbsize);
                         end
                         n2=fix(rand*nbsize);
                         while (n2==n1 || n2==0)
                             n2=fix(rand*nbsize);
                         end
                         spread2=0;
                         for t=1:dimension
                             spread2=spread2+(neighbor_info(n1,t)-neighbor_info(n2,t))^2;
                         end
                         spread2=sqrt(spread2);
                         %tempsum=0;
                         %for i1=1:nbsize
                             %tempsum=tempsum+neighbor_infofitness(i1,1);
                         %end
                         %tempsum=tempsum/nbsize;
                         %localgoal=0.01*tempsum
                         %spacenet=newrb(neighbor_info',neighbor_infofitness',spread2);
                         spacenet=newrb(neighbor_info',neighbor_infofitness',0.01,spread2,30); %�ֲ�����ģ��
                         %spacenet=newrb(neighbor_info',neighbor_infofitness',localgoal,spread2,30); %�ֲ�����ģ��
                         temp=current_fitness(i,1);
                         if(current_fitness(i,1)>sim(spacenet,current_position(i,:)'))
                             current_fitness(i,1)=sim(spacenet,current_position(i,:)');
                             whethercal(i,1)=0;
                         end
                         if current_fitness(i,1)<pbest_fitness(i,1)
                             %current_fitness(i,1)=fitness(current_position(i,:));
                             temp_position=current_position(i,:);
                             initial_flag=0;
                             current_fitness(i,1)=benchmark_func(temp_position,1);
                             whethercal(i,1)=1;
                             %squaremse=squaremse+abs(log(temp-current_fitness(i,1)));
                             difference=abs((temp-current_fitness(i,1))/current_fitness(i,1));
                             testtotal=testtotal+1;
                             zput(hashtable_position,current_position(i,1:end),current_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                             if difference>0.5 %����ֵ���ڸ�����ֵ����ʵ�ʼ���������Ϣ����currpos_arch��
                                 currpos_arch(size(currpos_arch,1)+1,:)=[i iter current_fitness(i,1) current_position(i,:)];
                                 totalupdate1=totalupdate1+1;
                             end
                             evaltimes=evaltimes+1;
                             if current_fitness(i,1)<pbest_fitness(i,1)
                                 pbest(i,:)=current_position(i,:);
                                 pbest_fitness(i,1)=current_fitness(i,1);
                                 zput(hashtable,pbest(i,1:end),pbest_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                             end
                         end
                     else
                         if current_fitness(i,1)<pbest_fitness(i,1)
                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                             temp=current_fitness(i,1);
                             %current_fitness(i,1)=fitness(current_position(i,:));
                             temp_position=current_position(i,:);
                             initial_flag=0;
                             current_fitness(i,1)=benchmark_func(temp_position,1);
                             whethercal(i,1)=1;
                             %squaremse=squaremse+abs(log(temp-current_fitness(i,1)));
                             difference=abs((temp-current_fitness(i,1))/current_fitness(i,1)); %�����ֵ
                             testtotal=testtotal+1;
                             zput(hashtable_position,current_position(i,1:end),current_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                             if difference>0.5
                                 currpos_arch(size(currpos_arch,1)+1,:)=[i iter current_fitness(i,1) current_position(i,:)];
                                 totalupdate1=totalupdate1+1;
                             end
                             evaltimes=evaltimes+1;
                             if current_fitness(i,1)<pbest_fitness(i,1)
                                 pbest(i,:)=current_position(i,:);
                                 pbest_fitness(i,1)=current_fitness(i,1);
                                 zput(hashtable,pbest(i,1:end),pbest_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                             end
                         end
                     end
                 else
                     if current_fitness(i,1)<pbest_fitness(i,1)
                         pbest(i,:)=current_position(i,:);
                         pbest_fitness(i,1)=current_fitness(i,1);
                         zput(hashtable,pbest(i,1:end),pbest_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                     end
                 end
         end
         %whethercaltemp=find(whethercal>0);
         %if size(whethercaltemp,1)==0 %whethercal==0 %��δ�и������Ӧֵ��������ʷ����ʱ���������ɸ�����
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              [sortfit,individualflag]=sort(current_fitness(:,1));
%              %for i=1:10
%              %for i=1:1
%              i=1;
%              if whethercal(individualflag(i),1)==0
%                  %temp=current_fitness(individualflag(i),1);
%                  temp=global_fitness(individualflag(i),1);
%                  %current_fitness(individualflag(i),1)=fitness(current_position(individualflag(i),:));
%                  temp_position=current_position(individualflag(i),:);
%                  initial_flag=0;
%                  current_fitness(individualflag(i),1)=benchmark_func(temp_position,1);
%                  %squaremse=squaremse+abs(log(temp-current_fitness(i,1)));
%                  difference=abs((temp-current_fitness(individualflag(i),1))/current_fitness(individualflag(i),1));
%                  testtotal=testtotal+1;
%                  zput(hashtable_position,current_position(individualflag(i),1:end),current_fitness(individualflag(i),1),precise); %��ʵ�ʼ������Ϣ����hash����
%                  if difference>0.5
%                      currpos_arch(size(currpos_arch,1)+1,:)=[individualflag(i) iter current_fitness(individualflag(i),1) current_position(individualflag(i),:)];
%                      totalupdate1=totalupdate1+1;
%                  end
%                  evaltimes=evaltimes+1;
%                  if current_fitness(individualflag(i),1)<pbest_fitness(individualflag(i),1)
%                      pbest(individualflag(i),:)=current_position(individualflag(i),:);
%                      pbest_fitness(individualflag(i),1)=current_fitness(individualflag(i),1);
%                      zput(hashtable,pbest(individualflag(i),1:end),pbest_fitness(individualflag(i),1),precise); %��ʵ�ʼ������Ϣ����hash����
%                  end
%              end
%              %***************
%              [sortfit,individualflag]=sort(current_fitness(:,1),'descend');
%              %for i=1:10
%              %for i=1:1
%              i=1;
%              if whethercal(individualflag(i),1)==0
%                  %temp=current_fitness(individualflag(i),1);
%                  temp=global_fitness(individualflag(i),1);
%                  %current_fitness(individualflag(i),1)=fitness(current_position(individualflag(i),:));
%                  temp_position=current_position(individualflag(i),:);
%                  initial_flag=0;
%                  current_fitness(individualflag(i),1)=benchmark_func(temp_position,1);
%                  %squaremse=squaremse+abs(log(temp-current_fitness(i,1)));
%                  difference=abs((temp-current_fitness(individualflag(i),1))/current_fitness(individualflag(i),1));
%                  testtotal=testtotal+1;
%                  zput(hashtable_position,current_position(individualflag(i),1:end),current_fitness(individualflag(i),1),precise); %��ʵ�ʼ������Ϣ����hash����
%                  if difference>0.5
%                      currpos_arch(size(currpos_arch,1)+1,:)=[individualflag(i) iter current_fitness(individualflag(i),1) current_position(individualflag(i),:)];
%                      totalupdate1=totalupdate1+1;
%                  end
%                  evaltimes=evaltimes+1;
%                  if current_fitness(individualflag(i),1)<pbest_fitness(individualflag(i),1)
%                      pbest(individualflag(i),:)=current_position(individualflag(i),:);
%                      pbest_fitness(individualflag(i),1)=current_fitness(individualflag(i),1);
%                      zput(hashtable,pbest(individualflag(i),1:end),pbest_fitness(individualflag(i),1),precise); %��ʵ�ʼ������Ϣ����hash����
%                  end
%              end
         %end

%          whethercaltemp=find(whethercal>0);
%          if size(whethercaltemp,1)==0
%              tempposition=zeros(5,1);
%              i1=1;
%              while i1<=5
%                  i=fix(rand*popsize);
%                  if i<=0
%                      i=1;
%                  end;
%                  while whethercal(i)==1
%                      i=fix(rand*popsize);
%                      if i<=0
%                          i=1;
%                      end
%                  end
%                  temporary=find(tempposition==i);
%                  if size(temporary,1)==0
%                      tempposition(i1,1)=i;
%                      i1=i1+1;
%                  end
%              end
%              for i1=1:5
%                  i=tempposition(i1,1);
                 whethercaltemp=find(whethercal>0);
                 if size(whethercaltemp,1)<popsize
                 i=fix(rand*popsize);
                 if i==0
                     i=1;
                 end
                 while whethercal(i)==1
                     i=fix(rand*popsize);
                     if i<=0
                         i=1;
                     end
                 end
                 temp=global_fitness(i,1);
                 %current_fitness(individualflag(i),1)=fitness(current_position(individualflag(i),:));
                 temp_position=current_position(i,:);
                 initial_flag=0;
                 current_fitness(i,1)=benchmark_func(temp_position,1);
                 %squaremse=squaremse+abs(log(temp-current_fitness(i,1)));
                 difference=abs((temp-current_fitness(i,1))/current_fitness(i,1));
                 testtotal=testtotal+1;
                 zput(hashtable_position,current_position(i,1:end),current_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                 if difference>0.5
                     currpos_arch(size(currpos_arch,1)+1,:)=[i iter current_fitness(i,1) current_position(i,:)];
                     totalupdate1=totalupdate1+1;
                 end
                 evaltimes=evaltimes+1;
                 if current_fitness(i,1)<pbest_fitness(i,1)
                     pbest(i,:)=current_position(i,:);
                     pbest_fitness(i,1)=current_fitness(i,1);
                     zput(hashtable,pbest(i,1:end),pbest_fitness(i,1),precise); %��ʵ�ʼ������Ϣ����hash����
                 end
             end
         %end
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %---ȷ��Ⱥ������
         for i=1:popsize
             if pbest_fitness(i,1)<gbest_fitness(1,1)
                 gbest(1,:)=pbest(i,:);
                 gbest_fitness(1,1)=pbest_fitness(i,1);
             end
         end
         gbest_output(iter+1)=gbest_fitness(1,1);
         gbest_fitness(1,1)
    
         %���»���ʱ���ȫ��ģ��
         totalupdate1
         %squaremse=(squaremse)/testtotal
         if totalupdate1>=1 %���¸�������20%��Ⱥ��
             for i=1:size(currpos_arch,1)
                 for t=1:dimension
                     curr_pos(i,t)=currpos_arch(i,t+3);
                 end
                 curr_fitness(i,1)=currpos_arch(i,3);
             end
             n1=fix(rand*size(currpos_arch,1));
             while n1==0
                 n1=fix(rand*size(currpos_arch,1));
             end
             n2=fix(rand*size(currpos_arch,1));
             while (n2==n1 || n2==0)
                 n2=fix(rand*size(currpos_arch,1));
             end
             spread1=0;
             for t=1:dimension
                 spread1=spread1+(curr_pos(n1,t)-curr_pos(n2,t))^2;
             end
             spread1=sqrt(spread1);
             timenet=newrb(curr_pos',curr_fitness',0.1,spread1,30);
             totalupdate1=0;
             testtotal=0;
         end
         evaltimes_output(iter+1)=evaltimes;
         evaltimes_output1(iter+1)=evaltimes_output(iter+1)-evaltimes_output(iter);
         iter=iter+1
         evaltimes
     end  
     iter
     %movie2avi(m,'d:\2013---surrogate-assistedpso\goldstein-price function\goldstein-price2.avi')
%     movie2avi(m,'d:\b.avi')
     r;
     gbest(1,:);
     a=gbest_fitness(1,1)
%     hitCount
     totalHitCount
     evaltimes
     totalupdate1
     x=0:1:iter-1;
     for i=1:iter
         y(i)=gbest_output(i);
         z(i)=evaltimes_output1(i);
     end
%      y=gbest_output;
%      z=evaltimes_output1;
%      x=0:1:max_length;
%      y=gbest_output;
%      z=evaltimes_output;
     subplot(2,1,1),plot(x,y),axis([0 iter -2 2]);
     subplot(2,1,2),plot(x,z),axis([0 iter 0 60]);
     avggbest_fitness=avggbest_fitness+gbest_fitness(1,1);
 end
 avggbest_fitness=avggbest_fitness/run_times
         
