
    
               fiteva=zeros(ps,1);%ÿһ���Ķ�Ӧ�ĸ��屻ʵ�ʼ���ʱΪ1������Ϊ0 
        minevafitpast=min(pastposfit);
    GPglobal;

    
        for mj=1:m
        k=ismember(p(mj,:),pastpos,'rows');
          if k==1
            pastid=find((ismember(p(mj,:),pastpos,'rows')));
            fiteva(mj,1)=1;%�˴�������ʵ�ʼ��������Ϊ�Ǹ�ֵ�����Բ�û�����Ӽ������
            posfit(mj,1)=pastposfit(pastid(1),1);
            posmse(mj,1)=minmse;
          end
        end

       
        
        [FrontNo,MaxFNo] = NDSort(PopObj,m);%û��ȥ����ǰ������ֵ��û��ϵ����fiteva����Ѿ�Ϊ1�򲻼���
         difNo=unique(FrontNo);  %���ص��Ǻ�FrontNo��һ����ֵ������û���ظ�Ԫ�ء������Ľ����������������
         difNoL=length(difNo);%�ܹ����˶��ٸ���
         MinFNo=min(FrontNo);
         Fristpointsid=find (FrontNo==MinFNo);%�ҳ��ڵ�һ�����ϵ���±�
         Lastpointsid=find (FrontNo==MaxFNo);%�ҳ������һ�����ϵ���±�
        FristL=length(Fristpointsid);
        LastL=length(Lastpointsid);

            for ffid=1:FristL
              if fiteva(Fristpointsid(ffid),1)==0
              posfit(Fristpointsid(ffid),1)=evafit(p(Fristpointsid(ffid),:),problem);
                evacount=evacount+1;
                fiteva(Fristpointsid(ffid),1)=1;
                pastpos=[pastpos;p(Fristpointsid(ffid),:)];%%%������ʷ����
                pastposfit=[pastposfit;posfit(Fristpointsid(ffid),1)];
                posmse(Fristpointsid(ffid))=minmse;  
                minevafitnow = min(pastposfit);
               everyEVA=[everyEVA;evacount];
               everyGBEST=[everyGBEST;minevafitnow ];
 
             end
           end
      
             

for lfid=1:LastL
  if fiteva(Lastpointsid(lfid),1)==0

                posfit(Lastpointsid(lfid),1)=evafit(p(Lastpointsid(lfid),:),problem);
                evacount=evacount+1;
                fiteva(Lastpointsid(lfid),1)=1;
                pastpos=[pastpos;p(Lastpointsid(lfid),:)];%%%������ʷ����
                pastposfit=[pastposfit;posfit(Lastpointsid(lfid),1)];
               posmse(Lastpointsid(lfid))=minmse;  
                minevafitnow = min(pastposfit);
               everyEVA=[everyEVA;evacount];
               everyGBEST=[everyGBEST;minevafitnow ];
              
               
  end
end
           
        
       
      
      [posfit, gbestmid] = sort(posfit, 'descend');%%gbestmidΪ��Ӧֵ�ɴ�С����
      p=p(gbestmid,:);

      fiteva=fiteva(gbestmid,:);
    gbestval =minevafitnow;
    fprintf('Best fitness: %e\n',gbestval);
     fprintf('evacount: %e\n',evacount);
