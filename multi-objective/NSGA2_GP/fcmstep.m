function [U_new, center, obj_fcn] = fcmstep(data, U, cluster_n, alpha, m) 
% ģ��C��ֵ����ʱ������һ�� 
% ���룺 
%   data        ---- nxm����,��ʾn������,ÿ����������m��ά����ֵ 
%   U           ---- �����Ⱦ��� 
%   cluster_n   ---- ����,��ʾ�ۺ�������Ŀ,������� 
%   expo        ---- �����Ⱦ���U��ָ��                       
% ����� 
%   U_new       ---- ������������µ������Ⱦ��� 
%   center      ---- ������������µľ������� 
%   obj_fcn     ---- Ŀ�꺯��ֵ 
mf = U.^alpha; 
center = mf*data./((ones(size(data, 2), 1)*sum(mf'))'); 
dist = fcmdist(center, data);  
obj_fcn = sum(sum((dist.^2).*mf));  
tmp = dist.^(-2/(m-1));      
U_new = tmp./(ones(cluster_n, 1)*sum(tmp));