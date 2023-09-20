function [Obj,convio] = Mbenchmark(x,GModel,FModel,Mat,M,index)
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
convio = 0;
if index == 1
    for m = 1:M
        Obj(m) = POLY_eval(x,GModel{m},'quad');
    end
else
    for m = 1:M
        Obj(m) = rbfpredict(FModel{m}, RBFdata, x);%+POLY_eval(x,GModel{1},'quad');
    end
    
end
end