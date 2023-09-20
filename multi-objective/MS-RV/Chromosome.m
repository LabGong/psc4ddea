classdef Chromosome
    
    properties
        XSnvec;  %不变性的x
        XCnvec;  %可变的x
        rnvec;
        objs_T1;
        objs_T2;
        convio;
        skill_factor;
        front;
        CD;
        rank;
        dominationcount=0;
        dominatedset=[];
        dominatedsetlength=0;
    end
    
    methods
        
        function object=initialize(object,dim)
            object.rnvec=rand(1,dim);
        end
        
        function object=evaluate(object,GModel,FModel,Mat,M,L,U)
            x=object.rnvec; 
            x(x>1) = ones(x>1);
            x(x<0) = zeros(x<0);
            if object.skill_factor==1
                
                [object.objs_T1,object.convio]=Mbenchmark(x,GModel,FModel,Mat,M,1);
                kk = 1;
            else
               
%                 x = x.*(U-L)+L;
                [object.objs_T2,object.convio]=Mbenchmark(x,GModel,FModel,Mat,M,2);
            end
        end   
        
        function population=reset(population,pop)
            for i=1:pop
                population(i).dominationcount=0;
                population(i).dominatedset=[];
                population(i).dominatedsetlength=0;
            end
        end     
    end     
end

