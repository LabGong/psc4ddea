function svm = svmTrain(svmType,X,Y,ker,p1,p2)
% SVM Classification:
%   svm = svmTrain('svc_c',x,y,ker,C); 
%   svm = svmTrain('svc_nu',x,y,ker,nu); 
%
% One-Class SVM:
%   svm = svmTrain('svm_one_class',x,[],ker,nu);
%
% SVM Regression:
%   svm = svmTrain('svr_epsilon',x,y,ker,C,e); 
%   svm = svmTrain('svr_nu',x,y,ker,C,nu); 

% 输入参数:
% X  训练样本,d×n的矩阵,n为样本个数,d为样本维数
% Y  训练目标,1×n的矩阵,n为样本个数,值为+1或-1
% ker  核参数(结构体变量)
% the following fields:
%   type   - linear :  k(x,y) = x'*y
%            poly   :  k(x,y) = (x'*y+c)^d
%            gauss  :  k(x,y) = exp(-0.5*(norm(x-y)/s)^2)
%            tanh   :  k(x,y) = tanh(g*x'*y+c)
%   degree - Degree d of polynomial kernel (positive scalar).
%   offset - Offset c of polynomial and tanh kernel (scalar, negative for tanh).
%   width  - Width s of Gauss kernel (positive scalar).
%   gamma  - Slope g of the tanh kernel (positive scalar).

% 输出参数:
% svm  支持向量机(结构体变量)
% the following fields:
%   type - 支持向量机类型  {'svc_c','svc_nu','svm_one_class','svr_epsilon','svr_nu'}
%   ker - 核参数
%   x - 训练样本,d×n的矩阵,n为样本个数,d为样本维数
%   y - 训练目标,1×n的矩阵,n为样本个数,值为+1或-1
%   a - 拉格朗日乘子,1×n的矩阵

% ------------------------------------------------------------%

options = optimset;
options.LargeScale = 'off';
options.Display = 'off';

switch svmType
    case 'svc_c',
        
        C = p1;

        n = length(Y);
        H = (Y'*Y).*kernel(ker,X,X);

        f = -ones(n,1);
        A = [];
        b = [];
        Aeq = Y;
        beq = 0;
        lb = zeros(n,1);
        ub = C*ones(n,1);
        a0 = zeros(n,1);
        
        [a,fval,eXitflag,output,lambda]  = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);                    
    
    case 'svc_nu',
        
        nu = p1;
       
        n = length(Y);
        H = (Y'*Y).*kernel(ker,X,X);

        f = zeros(n,1);
        A = -ones(1,n);
        b = -nu;
        Aeq = Y;
        beq = 0;
        lb = zeros(n,1);
        ub = ones(n,1)/n;
        a0 = zeros(n,1);
        
        [a,fval,eXitflag,output,lambda]  = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);                    

    case 'svm_one_class',
        
        nu = p1;
    
        n = size(X,2);
        H = kernel(ker,X,X);

        f = zeros(n,1);
        for i = 1:n
            f(i,:) = -kernel(ker,X(:,i),X(:,i));
        end
        A = [];
        b = [];
        Aeq = ones(1,n);
        beq = 1;
        lb = zeros(n,1);
        ub = ones(n,1)/(nu*n);
        a0 = zeros(n,1);

        [a,fval,eXitflag,output,lambda]  = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);                    
        
    case 'svr_epsilon',
        
        C = p1;
        e = p2;
        
        n = length(Y);
        Q = kernel(ker,X,X);
        H = [Q,-Q;-Q,Q];
        f = [e*ones(n,1)-Y';e*ones(n,1)+Y'];          % 符号不一样,决策函数就不一样,实际上是一回事!
        %f = [e*ones(n,1)+Y';e*ones(n,1)-Y'];
        A = [];
        b = [];
        Aeq = [ones(1,n),-ones(1,n)];
        beq = 0;
        lb = zeros(2*n,1);               
        ub = C*ones(2*n,1);
        a0 = zeros(2*n,1);
        
        [a,fval,eXitflag,output,lambda]  = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);  
        a = a(1:n)-a(n+1:end);

    case 'svr_nu',

        C = p1;
        nu = p2;

        n = length(Y);
        Q = kernel(ker,X,X);
        H = [Q,-Q;-Q,Q];
        f = [-Y';+Y'];          % 符号不一样,决策函数就不一样,实际上是一回事!
        %f = [+Y';-Y'];
        A = [];
        b = [];
        Aeq = [ones(1,n),-ones(1,n);ones(1,2*n)];
        beq = [0;C*n*nu];
        lb = zeros(2*n,1);               
        ub = C*ones(2*n,1);
        a0 = zeros(2*n,1);
        
        [a,fval,eXitflag,output,lambda]  = quadprog(H,f,A,b,Aeq,beq,lb,ub,a0,options);            
        a = a(1:n)-a(n+1:end);

    otherwise,
end


eXitflag;

% ------------------------------------------------------------%
% 输出 svm

svm.type = svmType;
svm.ker = ker;
svm.x = X;
svm.y = Y;
svm.a = a';