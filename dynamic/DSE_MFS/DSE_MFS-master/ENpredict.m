function [OBJ] = ENpredict(x,FModel,AMat,W,index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set
%   - g1: global optima of Task 1
%   - g2: global optima of Task 2

[N,D] = size(x);
OBJ=zeros(N,1);
Item = size(W,1);
for item = 1:Item
    Obj = [];
    w = W(item,:);
    for i = 1:N
        if index == 1
            obj = rbfpredict(FModel{item,m}, RBFdata, x(i,:));
        else
            Mat = AMat{item};
            RBFdata = Mat(:,1:D);
            obj = rbfpredict(FModel{item}, RBFdata, x(i,:));
        end
        Obj = [Obj;obj];
    end
    Obj = Obj*w;
    OBJ = OBJ+Obj;
end
end