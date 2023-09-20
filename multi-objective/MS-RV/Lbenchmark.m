function [Objval] = Lbenchmark(x,Model,Mat,M,w,index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set
%   - g1: global optima of Task 1
%   - g2: global optima of Task 2
        D = length(x);
        RBFdata = Mat(:,1:D);
        Obj=[];
        if index == 1
            for m = 1:M
                Obj(m) = POLY_eval(x,Model{m},'quad');
            end
        elseif index==2
            for m = 1:M
                Obj(m) = rbfpredict(Model{m}, RBFdata, x);
            end
        else
            for m = 1:M
                [me,~,s] = predictor(x,Model{m});
                Obj(m) = me-2*s;
            end
        end    
        
        Objval = Obj*w';
end