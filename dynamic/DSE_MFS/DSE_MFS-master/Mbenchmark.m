function Obj = Mbenchmark(x,FModel,AMat,item,run,index)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set
%   - g1: global optima of Task 1
%   - g2: global optima of Task 2
[N,D] = size(x);
Obj = [];
for i = 1:N
    if index == 1
        RBFdata = AMat(:,1:D);
        obj = rbfpredict(FModel, RBFdata, x(i,:));
    else
        Mat = AMat{run,item};
        RBFdata = Mat(:,1:D);
        obj = rbfpredict(FModel{item}, RBFdata, x(i,:));
    end
    Obj = [Obj;obj];
end