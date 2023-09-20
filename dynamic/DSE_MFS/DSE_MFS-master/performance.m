function performance(f,fun_num,change_instance,FES,dim,num_runs,h,fun_opts)
% Function for Performance Marking Used in DBG.m

% f - current function value
% fun_num - function number (1~6)
%% F1: Rotation peak function (maximization)
%% F2: Composition of Sphere function (minimization)
%% F3: Composition of Rastrigin's function (minimization)
%% F4: Composition of Griewank's function (minimization)
%% F5: Composition of Ackley's function (minimization)
%% F6: Hybrid Composition function (minimization)
% change_instance - instance No. of changes (1~7)
%% 1: small step
%% 2: large step
%% 3: random
%% 4: chaotic
%% 5: recurrent
%% 6: recurrent change with noise
%% 7: random change with changed dimension
% FES - number of function evaluations already used
% dim - dimension
% num_runs - no. of runs
% h - heights of peaks for F1, or parameter H in the formula for F2~F6
% fun_opts - function options
%% For F1, fun_opts takes the form [num_peaks],
%% where num_peaks denotes the number of peaks.
%% For competition, num_peaks(fixed)=10,50;
%% For F2~F6, fun_opts is simply [].

% Last Modified on Sept. 25, 2008
% Elaine L. Yu
% YuLing@ntu.edu.sg
% Nanyang Technological University

freq = 10000*dim;                     % frequency of changes
runs = 20;                            % total number of runs
num_change = 60;                      % total number of changes
s_f = 100;                            % sampling frequency
S = freq/s_f;                         % total number of samplings during one change

F = [0.20 0.16 0.16 0.16 0.16 0.16];
T = [0.15 0.15 0.15 0.15 0.15 0.15 0.1];
if fun_num==1
    index_peak = (fun_opts==10)*1+(fun_opts==50)*2;
end

load Dynamic_Change_Info;
load scoring_Info;
if num_runs==1 & FES==1
    if fun_num==1
        marks((change_instance-1)*2+index_peak) = 0;
    elseif fun_num>1
        marks(14+(fun_num-2)*7+change_instance) = 0;
    end
    sum_r = 0;
end
if FES==1
    sum_r(num_runs) = 0;
end
if FES==FES_last_change+1
    f_best = f;
    r_ij = 1;
else
    f_best = (fun_num==1)*max(f_best,f)+(fun_num>1)*min(f_best,f);
end
if mod(FES-FES_last_change,s_f)==0
    temp = (fun_num==1)*f_best/max(h)+(fun_num>1)*min(h)/f_best;
    r_ij = r_ij+(1-temp)/S;
end
if FES==FES_last_change+freq
    temp = (fun_num==1)*f_best/max(h)+(fun_num>1)*min(h)/f_best;
    r_ij = temp/r_ij;
    sum_r(num_runs) = sum_r(num_runs)+r_ij/num_change/runs;
end
if num_runs==runs & change_count==num_change-1 & FES==FES_last_change+freq
    weight_k = F(fun_num)*T(change_instance)*((fun_num==1)*.5+(fun_num>1));
    mark_k = weight_k*sum(sum_r);
    if fun_num==1
        marks((change_instance-1)*2+index_peak) = mark_k;
    elseif fun_num>1
        marks(14+(fun_num-2)*7+change_instance) = mark_k;
    end
end
save scoring_Info f_best r_ij sum_r marks;