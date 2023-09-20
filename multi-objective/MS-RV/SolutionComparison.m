classdef SolutionComparison
    methods (Static)
        function [population,frontnumbers]=nondominatedsort(population,pop,no_of_objs)
            count=0;
            frontnumbers=[];
            for i=1:pop
                for j=i:pop
                    if i==j
                        continue;
                    end
                    better=0;
                    worse=0;
                    if population(i).convio < population(j).convio
                        population(i).dominatedset=[population(i).dominatedset j];
                        population(i).dominatedsetlength=population(i).dominatedsetlength+1;
                        population(j).dominationcount=population(j).dominationcount+1;
                    elseif population(i).convio > population(j).convio
                        population(j).dominatedset=[population(j).dominatedset i];
                        population(j).dominatedsetlength=population(j).dominatedsetlength+1;
                        population(i).dominationcount=population(i).dominationcount+1;                        
                    else
                        for k = 1:no_of_objs
                            if population(1).skill_factor == 1
                                if population(i).objs_T1(k) < population(j).objs_T1(k)
                                    better=1;
                                elseif population(i).objs_T1(k) > population(j).objs_T1(k)
                                    worse=1;
                                end
                            else
                                if population(i).objs_T2(k) < population(j).objs_T2(k)
                                    better=1;
                                elseif population(i).objs_T2(k) > population(j).objs_T2(k)
                                    worse=1;
                                end
                            end
                        end
                        if worse==0 && better>0
                            population(i).dominatedset=[population(i).dominatedset j];
                            population(i).dominatedsetlength=population(i).dominatedsetlength+1;
                            population(j).dominationcount=population(j).dominationcount+1;
                        elseif better==0 && worse>0
                            population(i).dominationcount=population(i).dominationcount+1;
                            population(j).dominatedset=[population(j).dominatedset i];
                            population(j).dominatedsetlength=population(j).dominatedsetlength+1;
                        end
                    end
                end
                if population(i).dominationcount==0
                    population(i).front=1;
                    count=count+1;
                end                
            end  
            frontnumbers=[frontnumbers,count];
            front=0;
            while count>0
                count=0;
                front=front+1;
                for i=1:pop
                    if population(i).front==front
                        for j=1:population(i).dominatedsetlength
                            ind=population(i).dominatedset(j);
                            population(ind).dominationcount=population(ind).dominationcount-1;
                            if population(ind).dominationcount==0
                                population(ind).front=front+1;
                                count=count+1;
                            end
                        end
                    end
                end
                frontnumbers=[frontnumbers,count];
            end  
        end
        
        function [population,minimums]=diversity(population,frontnumbers,pop,no_of_objs)
            for i=1:pop
                population(i).CD = 0;
            end
            [xx,y]=sort([population.front]);
            population=population(y);
            currentind=0;
            for i=1:population(pop).front
                subpopulation=population(currentind+1:currentind+frontnumbers(i));
                minima=zeros(1,no_of_objs);
                x=zeros(1,frontnumbers(i));                
                for j = 1:no_of_objs
                    for k = 1:frontnumbers(i)
                        if population(1).skill_factor == 1
                            x(k)=subpopulation(k).objs_T1(j);
                        else
                            x(k)=subpopulation(k).objs_T2(j);
                        end
                    end
                    [xx,y] = sort(x);
                    x=x(y);
                    subpopulation=subpopulation(y);
                    if population(1).skill_factor == 1
                        minima(j)=subpopulation(1).objs_T1(j);
                        max=subpopulation(frontnumbers(i)).objs_T1(j);
                    else
                        minima(j)=subpopulation(1).objs_T2(j);
                        max=subpopulation(frontnumbers(i)).objs_T2(j);
                    end
                    subpopulation(1).CD=inf;
                    subpopulation(frontnumbers(i)).CD=inf;
                    normobj=(x-minima(j))./(max-minima(j));
                    for k = 2:frontnumbers(i)-1
                        subpopulation(k).CD = subpopulation(k).CD + (normobj(k+1)-normobj(k-1));
                    end
                end                  
                if i == 1
                    minimums=minima;
                end
                [xx,y]=sort(-[subpopulation.CD]);
                subpopulation=subpopulation(y);
                population(currentind+1:currentind+frontnumbers(i))=subpopulation;
                currentind=currentind+frontnumbers(i);             
            end
            for i = 1: pop
                population(i).rank=i;
            end
        end
        
    end
end