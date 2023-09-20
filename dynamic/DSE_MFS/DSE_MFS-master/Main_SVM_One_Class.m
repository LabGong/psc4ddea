% 支持向量机Matlab工具箱1.0 - One-Class SVM, 一类支持向量机
% 使用平台 - Matlab6.5
% 版权所有：陆振波，海军工程大学
% 电子邮件：luzhenbo@yahoo.com.cn
% 个人主页：http://luzhenbo.88uu.com.cn
% 参数文献：Chih-Chung Chang, Chih-Jen Lin. "LIBSVM: a Library for Support Vector Machines"
%
% Support Vector Machine Matlab Toolbox 1.0 - One-Class Support Vector Machine
% Platform : Matlab6.5 / Matlab7.0
% Copyright : LU Zhen-bo, Navy Engineering University, WuHan, HuBei, P.R.China, 430033  
% E-mail : luzhenbo@yahoo.com.cn        
% Homepage : http://luzhenbo.88uu.com.cn     
% Reference : Chih-Chung Chang, Chih-Jen Lin. "LIBSVM: a Library for Support Vector Machines"
%
% Solve the quadratic programming problem - "quadprog.m"

clc
clear
close all

% ------------------------------------------------------------%
% 定义核函数及相关参数

nu = 0.01;           % nu -> [0,1] 在支持向量数与错分样本数之间进行折衷
                    % 支持向量机的 nu 参数(取值越小，异常点就越少)

ker = struct('type','linear');
%ker = struct('type','ploy','degree',3,'offset',1);
%ker = struct('type','gauss','width',500);
%ker = struct('type','tanh','gamma',1,'offset',0);

% ker - 核参数(结构体变量)
% the following fields:
%   type   - linear :  k(x,y) = x'*y
%            poly   :  k(x,y) = (x'*y+c)^d
%            gauss  :  k(x,y) = exp(-0.5*(norm(x-y)/s)^2)
%            tanh   :  k(x,y) = tanh(g*x'*y+c)
%   degree - Degree d of polynomial kernel (positive scalar).
%   offset - Offset c of polynomial and tanh kernel (scalar, negative for tanh).
%   width  - Width s of Gauss kernel (positive scalar).
%   gamma  - Slope g of the tanh kernel (positive scalar).

% ------------------------------------------------------------%
% 构造一类训练样本

n = 100
randn('state',1);
x1 = randn(2,floor(n*0.95));
x2 = 5+randn(2,ceil(n*0.05));
X = [x1,x2];            % 训练样本,d×n的矩阵,n为样本个数,d为样本维数

figure;
plot(x1(1,:),x1(2,:),'bx',x2(1,:),x2(2,:),'k.');
axis([-5 8 -5 8]); 
title('One-Class SVM');
hold on;

% ------------------------------------------------------------%
% 训练支持向量机

tic
svm = svmTrain('svm_one_class',X,[],ker,nu);
t_train = toc

% svm  支持向量机(结构体变量)
% the following fields:
%   type - 支持向量机类型  {'svc_c','svc_nu','svm_one_class','svr_epsilon','svr_nu'}
%   ker - 核参数
%   x - 训练样本,d×n的矩阵,n为样本个数,d为样本维数
%   y - 训练目标,值为[]
%   a - 拉格朗日乘子,1×n的矩阵

% ------------------------------------------------------------%
% 寻找支持向量

a = svm.a;
epsilon = 1e-10;                    % 如果小于此值则认为是0
i_sv = find(abs(a)>epsilon);        % 支持向量下标
plot(X(1,i_sv),X(2,i_sv),'ro');

% ------------------------------------------------------------%
% 测试输出

[x1,x2] = meshgrid(-5:0.05:6,-5:0.05:6);
[rows,cols] = size(x1);
nt = rows*cols;                  % 测试样本数
Xt = [reshape(x1,1,nt);reshape(x2,1,nt)];

tic
Yd = svmSim(svm,Xt);           % 测试输出
t_sim = toc

Yd = reshape(Yd,rows,cols);
contour(x1,x2,Yd,[0 0],'m');       % 分类面
hold off;


