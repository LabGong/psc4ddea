function Centers=nsga_2(hyp, center, data, tr_x, tr_y)

    global M V MaxValue MinValue
    nn=0;
    N = 50;                                                                
    gen = 50;                                                         
    pool = N;tour = 2;
    mu = 20;mum = 20;counter=0;
    
    while (nn==100||nn==0)
        
        chromosome = rand(N,V);%N*V 
        chromosome = chromosome.*repmat(MaxValue,N,1)+(1-chromosome).*repmat(MinValue,N,1);%N*V   
        chromosome(:,V+1:V+M)=estimate(chromosome(:,1:V), hyp, center, data, tr_x, tr_y);
        chromosome = non_domination_sort_mod(chromosome);%N*(V+M+2)                    

        for i = 1 : gen                                                    
            parent_chromosome = tournament_selection(chromosome,pool,tour);%N*(V+M+2)          
            offspring_chromosome = genetic_operator(parent_chromosome,mu,mum);%N*V
            offspring_chromosome(:,V+1:V+M)=estimate(offspring_chromosome(:,1:V), hyp, center, data, tr_x, tr_y);
    
            intermediate_chromosome=[];
            intermediate_chromosome(1:N,:) = chromosome(:,1:V+M);
            intermediate_chromosome(N+1 : 2*N, :) = offspring_chromosome(:,1:V+M);%2N*V                                              
    
            intermediate_chromosome = non_domination_sort_mod(intermediate_chromosome);%2N*(V+M+2)            
            chromosome = replace_chromosome(intermediate_chromosome,N);%N*(V+M+2) 
            %if ~mod(i,10)
                %disp(sprintf('NSGA2£º%u / %u finished', i, gen));  
            %end
        end
        [Centers, nn]=kmean(chromosome, tr_x, N);
        if nn==100
            disp(sprintf('restart'))
            counter=counter+1;
        end
        if (isempty(Centers))&&(gen>=25)&&(counter>=20)
            gen=gen-5;N=N-5;pool = N;
            counter=0;
            disp(sprintf('gen reduce to %u, so as pop', gen))
        end
    end
end


      