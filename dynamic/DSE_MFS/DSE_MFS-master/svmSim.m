function [Yd, Ydreal] = svmSim(svm,Xt)

% ------------------------------------------------------------%

cathe = 10e+6;                 % kernel输出的元素个数的上限
nx = size(svm.x,2);            % 训练样本数
nt = size(Xt,2);               % 测试样本数
block = ceil(nx*nt/cathe);     % 分块处理
num = ceil(nt/block);          % 每块测试样本数

for i = 1:block
    if (i==block)
        index = [(i-1)*num+1:nt];
    else
        index = (i-1)*num+[1:num];
    end

    [Yd(index),Ydreal(index)] = svmSim_block(svm,Xt(:,index));           % 测试输出
end

% ------------------------------------------------------------%

function [Yd, Ydreal] = svmSim_block(svm,Xt);

% 输入参数:
% svm  支持向量机(结构体变量)
% the following fields:
%   type - 支持向量机类型  {'svc_c','svc_nu','svm_one_class','svr_epsilon','svr_nu'}
%   ker - 核参数
%       type   - linear :  k(x,y) = x'*y
%                poly   :  k(x,y) = (x'*y+c)^d
%                gauss  :  k(x,y) = exp(-0.5*(norm(x-y)/s)^2)
%                tanh   :  k(x,y) = tanh(g*x'*y+c)
%       degree - Degree d of polynomial kernel (positive scalar).
%       offset - Offset c of polynomial and tanh kernel (scalar, negative for tanh).
%       width  - Width s of Gauss kernel (positive scalar).
%       gamma  - Slope g of the tanh kernel (positive scalar).
%   x - 训练样本
%   y - 训练目标;
%   a - 拉格朗日乘子
%
% Xt  测试样本,d×n的矩阵,n为样本个数,d为样本维数

% 输出参数:
% Yd  测试输出,1×n的矩阵,n为样本个数,值为+1或-1

% ------------------------------------------------------------%

type = svm.type;
ker = svm.ker;
X = svm.x;
Y = svm.y;
a = svm.a;

% ------------------------------------------------------------%
% 测试输出

epsilon = 1e-8;                  % 如果小于此值则认为是0
i_sv = find(abs(a)>epsilon);          % 支持向量下标

switch type
    case 'svc_c',
        
        tmp = (a.*Y)*kernel(ker,X,X(:,i_sv));          % 行向量
        b = Y(i_sv)-tmp;
        b = mean(b);
        tmp =  (a.*Y)*kernel(ker,X,Xt);
        tmp = tmp+b;
        Yd = sign(tmp);
        
    case 'svc_nu', 
        %------------------------------------%
        % 与 'svc_c' 情况相同

        tmp = (a.*Y)*kernel(ker,X,X(:,i_sv));          % 行向量
        b = Y(i_sv)-tmp;
        b = mean(b);
        tmp =  (a.*Y)*kernel(ker,X,Xt);
        Yd = sign(tmp+b);
        
    case 'svm_one_class',
        
        n_sv = length(i_sv);
        tmp1 = zeros(n_sv,1);
        for i = 1:n_sv
            index = i_sv(i);
            tmp1(i) = kernel(ker,X(:,index),X(:,index));
        end

        tmp2 = 2*a*kernel(ker,X,X(:,i_sv));           % 行向量
        tmp3 = sum(sum(a'*a.*kernel(ker,X,X)));    

        R_square = tmp1-tmp2'+tmp3;
        R_square = mean(R_square);                       % 超球半径 R^2 (对所有支持向量求平均的结果)

        nt = size(Xt,2);                  % 测试样本数

        tmp4 = zeros(nt,1);               % 列向量
        for i = 1:nt
            tmp4(i) = kernel(ker,Xt(:,i),Xt(:,i));
        end
    
        tmp5 = 2*a*kernel(ker,X,Xt);                % 行向量
        Ydreal = tmp4-tmp5'+tmp3-R_square;
        Yd = sign(Ydreal);
        

    case 'svr_epsilon',
        
        tmp = a*kernel(ker,X,X(:,i_sv));   % 行向量
        b = Y(i_sv)-tmp;                    % 符号不一样,决策函数就不一样,实际上是一回事!
        %b = Y(i_sv)+tmp;
        b = mean(b);

        tmp =  a*kernel(ker,X,Xt);         % 符号不一样,决策函数就不一样,实际上是一回事!
        %tmp =  -a*kernel(ker,X,Xt);
        Yd = (tmp+b);        
        
    case 'svr_nu',
        %------------------------------------%
        % 与'svr_epsilon' 情况相同
        
        tmp = a*kernel(ker,X,X(:,i_sv));   % 行向量
        b = Y(i_sv)-tmp;                    % 符号不一样,决策函数就不一样,实际上是一回事!
        %b = Y(i_sv)+tmp;
        b = mean(b);

        tmp =  a*kernel(ker,X,Xt);         % 符号不一样,决策函数就不一样,实际上是一回事!
        %tmp =  -a*kernel(ker,X,Xt);
        Yd = (tmp+b);        
        
    otherwise,
end