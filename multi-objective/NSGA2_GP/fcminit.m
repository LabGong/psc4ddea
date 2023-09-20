function U = fcminit(cluster_n, data_n) 
% 初始化fcm的隶属度函数矩阵 
% 输入: 
%   cluster_n   ---- 聚类中心个数 
%   data_n      ---- 样本点数 
% 输出： 
%   U           ---- 初始化的隶属度矩阵 
U = rand(cluster_n, data_n); 
col_sum = sum(U); 
U = U./col_sum(ones(cluster_n, 1), :); 