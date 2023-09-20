classdef Chromosome
    properties
        rnvec; % (genotype)--> decode to find design variables --> (phenotype)
        factorial_costs;
        factorial_ranks;
        scalar_fitness;
        skill_factor;
        gen;
        CW;
    end
    methods
        function object = initialize(object,D)
            object.rnvec = rand(1,D);
        end
        
        function [object,calls] = evaluate(object,Tasks,p_il,no_of_tasks,options)
            if object.skill_factor == 0
                calls=0;
                for i = 1:no_of_tasks
                    [object.factorial_costs(i),xxx,funcCount]=fnceval(Tasks(i),object.rnvec,p_il,options);
                    calls = calls + funcCount;
                end
            else
                object.factorial_costs(1:no_of_tasks)=inf;
                for i = 1:no_of_tasks
                    if object.skill_factor == i
                        [object.factorial_costs(object.skill_factor),object.rnvec,funcCount]=fnceval(Tasks(object.skill_factor),object.rnvec,p_il,options);
                        calls = funcCount;
                        break;
                    end
                end
            end
        end
        
        function object = evaluate_SOO(object,GPmodel,FModel,Mat,W,SAname,modelind)
            x=object.rnvec;
            W = object.CW;
            if modelind == 1
               [object.factorial_costs]=ENpredict(x,FModel,Mat,W,SAname);
            else
               object.factorial_costs = Mbenchmark(x,GPmodel,Mat,1,1,1);
            end
        end
    end
end