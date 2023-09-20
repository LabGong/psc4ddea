function u = DynamicChange(u,change_type,u_min,u_max,u_severity,change_count)
% Function Used in DBG.m

% u - system control parameter
% change_type - type of changes (1~6)
%% 1: small step
%% 2: large step
%% 3: random
%% 4: chaotic
%% 5: recurrent
%% 6: recurrent change with noise
% change_count - count of changes

% Last Modified on Sept. 25, 2008
% Elaine L. Yu
% YuLing@ntu.edu.sg
% Nanyang Technological University

% ----- parameters settings -----
p = 12;                               % period
noisy_severity = 0.8;                 % severity of recurrent with noise
A = 3.67;                             % chaotic constant
alpha = 0.04;                         % step severity
alpha_max = 0.1;                      % maximum of alpha

u_range = u_max-u_min;
if change_type==1             % small step
    r = 2*rand(size(u,1),1)-1;
    u = max(min(u+alpha*u_range*r*u_severity,u_max),u_min);
end
if change_type==2             % large step
    r = 2*rand(size(u,1),1)-1;
    u = max(min(u+u_range*(alpha*sign(r)+(alpha_max-alpha)*r)*u_severity,u_max),u_min);
end
if change_type==3             % random
    u = max(min(u+normrnd(0,1,size(u,1),1)*u_severity,u_max),u_min);
end
if change_type==4             % chaotic
    u = (u-u_min)/u_range;
    u = A*u.*(1-u);
    u = u_min+u*u_range;
end
if change_type==5             % recurrent
    load phi;
    phi = phi(1:size(u,1));
    u = u_min+u_range*(sin(2*pi*change_count/p+phi)+1)/2;
end
if change_type==6             % recurrent change with noise
    load phi;
    phi = phi(1:size(u,1));
    u = u_min+u_range*(sin(2*pi*change_count/p+phi)+1)/2+normrnd(0,1,size(u,1),1)*noisy_severity;
    u = max(min(u,u_max),u_min);
end