function [Obj,Mse] = GPMbenchmark(x,GPmodel)
%BENCHMARK function
%   Input
%   - index: the index number of problem set
%
%   Output:
%   - Tasks: benchmark problem set
%   - g1: global optima of Task 1
%   - g2: global optima of Task 2



[N,D] = size(x);
% THETA = 5.*ones(1,D);
Obj = [];
Mse = [];
% TX = Mat(:,1:D);
% TY = Mat(:,1+D);
% dmodel = dacefit(TX,TY,'regpoly0','corrgauss',THETA,1e-5.*ones(1,D),100.*ones(1,D));

for i = 1:N
    
    %parameters for GP
    [obj,~,mse] = predictor(x(i,:),GPmodel);
    Obj = [Obj;obj];
    Mse = [Mse;mse];
end
end