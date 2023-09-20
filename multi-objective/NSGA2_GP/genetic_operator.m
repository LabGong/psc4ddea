function NPOP = genetic_operator(POP,mu,mum)

global V MaxValue MinValue

POP=POP(:,1:V);
N = size(POP,1);

l_limit= MinValue; u_limit=MaxValue ;                                               

%交叉
for i = 1 : N/2      
    k=2*i-1; 
    parent_1 = POP(k,:);parent_2 = POP(k+1,:);
    for j = 1 : V   
        if rand(1) <= 0.9
            %计算bq
            u(j) = rand(1);
            if u(j) <= 0.5                                                                                              
                bq(j) = (2*u(j))^(1/(mu+1));                                
            else
                bq(j) = (1/(2*(1 - u(j))))^(1/(mu+1));
            end
            %计算交换后POP
            POP(k,j) = 0.5*(((1 + bq(j))*parent_1(j)) + (1 - bq(j))*parent_2(j));  
            POP(k+1,j) = 0.5*(((1 - bq(j))*parent_1(j)) + (1 + bq(j))*parent_2(j));
            if POP(k,j) > u_limit(j)                                    
                POP(k,j) = u_limit(j);
            elseif POP(k,j) < l_limit(j)
                POP(k,j) = l_limit(j);
            end
            if POP(k+1,j) > u_limit(j)
                POP(k+1,j) = u_limit(j);
            elseif POP(k+1,j) < l_limit(j)
                POP(k+1,j) = l_limit(j);
            end
        end
    end
end

%变异
for i = 1:N
    for j = 1 : V
        if rand(1) <= 0.2
            %计算delta
            r(j) = rand(1);
            if r(j) < 0.5
                delta(j) = (2*r(j))^(1/(mum+1)) - 1;
            else
                delta(j) = 1 - (2*(1 - r(j)))^(1/(mum+1));
            end
            %计算变异后POP
            POP(i,j) = POP(i,j) + (u_limit(j)-l_limit(j))*delta(j);
            if POP(i,j) > u_limit(j)
                POP(i,j) = u_limit(j);
            elseif POP(i,j) < l_limit(j)
                POP(i,j) = l_limit(j);
            end
        end
    end
end
NPOP = POP;