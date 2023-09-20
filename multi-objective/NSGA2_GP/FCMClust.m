function [center, U] = FCMClust(tr_x) 

global L1
N=size(tr_x,1);

if N<=L1
    
    center=[];U=[];
    
else
    
    L2=20; tmax=200; alpha=2;epsilo=1e-5;m=2;
    Csize=1+ceil((N-L1)/L2);

    obj_fcn = zeros(tmax, 1);
    U = fcminit(Csize, N);     % 初始化模糊分配矩阵,使U满足列上相加为1
    %%Main loop  主要循环 
    for i = 1:tmax 
        %在第k步循环中改变聚类中心center,分配函数U的隶属度值; 
        [U, center, obj_fcn(i)] = fcmstep(tr_x, U, Csize, alpha, m); 
        % 终止条件判别 
        if i > 1, 
            if abs(obj_fcn(i) - obj_fcn(i-1)) < epsilo,  
                break; 
            end
        end
    end
    fprintf('FCM:Iteration count = %d\n', i);
    obj_fcn(i+1:tmax) = []; 
end