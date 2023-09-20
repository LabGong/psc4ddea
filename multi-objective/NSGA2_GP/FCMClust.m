function [center, U] = FCMClust(tr_x) 

global L1
N=size(tr_x,1);

if N<=L1
    
    center=[];U=[];
    
else
    
    L2=20; tmax=200; alpha=2;epsilo=1e-5;m=2;
    Csize=1+ceil((N-L1)/L2);

    obj_fcn = zeros(tmax, 1);
    U = fcminit(Csize, N);     % ��ʼ��ģ���������,ʹU�����������Ϊ1
    %%Main loop  ��Ҫѭ�� 
    for i = 1:tmax 
        %�ڵ�k��ѭ���иı��������center,���亯��U��������ֵ; 
        [U, center, obj_fcn(i)] = fcmstep(tr_x, U, Csize, alpha, m); 
        % ��ֹ�����б� 
        if i > 1, 
            if abs(obj_fcn(i) - obj_fcn(i-1)) < epsilo,  
                break; 
            end
        end
    end
    fprintf('FCM:Iteration count = %d\n', i);
    obj_fcn(i+1:tmax) = []; 
end