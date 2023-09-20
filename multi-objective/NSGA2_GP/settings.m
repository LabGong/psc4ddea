function [V,M,gen,MaxValue,MinValue]=settings(Problem)
    gen = 50;V=10;
    switch Problem
        case {'DTLZ1'}
            M = 3;MaxValue = ones(1,V);MinValue = zeros(1,V);
        
        case {'DTLZ3'}
            M = 3;MaxValue = ones(1,V);MinValue = zeros(1,V);
            
        case {'DTLZ4'} 
            M = 3;MaxValue = ones(1,V);MinValue = zeros(1,V);
            
        case {'DTLZ5'}   
            M = 3;MaxValue = ones(1,V);MinValue = zeros(1,V);
            
        case {'ZDT6'}
            M = 2;MaxValue = ones(1,V);MinValue = zeros(1,V);   
            
        case {'ZDT3'}   
            M = 2;MaxValue = ones(1,V);MinValue = zeros(1,V);
            
        case {'ZDT4'}
            M = 2;MaxValue = [ones(1,M-1) 5*ones(1,V-M+1)];MinValue = [zeros(1,M-1) -5*ones(1,V-M+1)];            
        
        case {'WFG2'} 
            M = 3;MaxValue = 2*(1:V);MinValue = zeros(1,V);
            
        case {'WFG3'} 
            M = 3;MaxValue = 2*(1:V);MinValue = zeros(1,V);
            
        case {'WFG4'} 
            M = 3;MaxValue = 2*(1:V);MinValue = zeros(1,V); 
            
        case {'WFG5'} 
            M = 3;MaxValue = 2*(1:V);MinValue = zeros(1,V);           
    end
    
end
