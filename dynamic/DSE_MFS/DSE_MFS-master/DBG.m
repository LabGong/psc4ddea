function [f,h] = DBG(x,fun_num,change_instance,FES,num_runs,dim,fun_opts)
% Generalized Dynamic Benchmark Generator
% for CEC'2009 Competition on Dynamic Optimization

% x - variable
% f - function value
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
% FES - number of function evaluations
%% The input parameter means the number of function evaluations
%% already used before excuting this function.
%% The function will add 1 to FES in the output.
% num_runs - no. of runs
% dim - dimension
%% For competition, dim(fixed)=10; dim(changed) is within range [5,15].
%% Note that dim can be changed under change type 7.
% fun_opts - function options
%% For F1, fun_opts takes the form [num_peaks],
%% where num_peaks denotes the number of peaks.
%% For competition, num_peaks(fixed)=10,50;
%% For F2~F6, fun_opts is simply [].

% Last Modified on Oct. 24, 2008
% Elaine L. Yu
% YuLing@ntu.edu.sg
% Nanyang Technological University

% ----- reading parameters -----
if nargin<5
    disp('Insufficient arguements') 
end
if nargin<7
    fun_opts = [];
end
if nargin<6
    dim = 10;
end

% ----- parameters settings -----
%% For all test functions:
bounds = [-5 5];                      % search range
freq = 1;                     % frequency of changes
num_change = 60;                      % total number of changes
initial_height = 50;                  % initial height
h_min = 10;                           % minimum height
h_max = 100;                          % maximum height
h_severity = 5;                       % height severity

%% For rotation peak function:
w_severity = 0.5;                     % width severity
initial_width = 5;                    % initial width
w_min = 1;                            % minimum width
w_max = 10;                           % maximum width

%% For all composition functions:
num_basic_fun = 10;                   % number of basic functions
sigma = 1;                            % converge range factor
C = 2000;                             % constant
domain1 = [-100 100];                 % domain of Sphere function
domain2 = [-5 5];                     % domain of Rastrigin's function
domain3 = [-0.5 0.5];                 % domain of Weierstrass function
domain4 = [-100 100];                 % domain of Griewank's function
domain5 = [-32 32];                   % domain of Ackley's function

if FES==0
    change_count=0;
    FES_last_change=0;
    save Dynamic_Change_Info change_count FES_last_change;
end
load Dynamic_Change_Info;

if fun_num==1                   % Rotation peak function
    num_peaks = 5;
    if isempty(num_peaks)
        num_peaks = 10;
    end
    if FES==0
        load x_peaks_original;
        x_peaks = x_peaks_original(1:num_peaks,1:dim);
        if change_instance==4
            load h_original;
            load w_original;
            h = h_original(1:num_peaks);
            w = w_original(1:num_peaks);
        else
            h = initial_height*ones(num_peaks,1);
            w = initial_width*ones(num_peaks,1);
            if change_instance==5 | change_instance==6
                h = DynamicChange(h,change_instance,h_min,h_max,h_severity,0);
                w = DynamicChange(w,change_instance,w_min,w_max,w_severity,0);
            end
        end
        if change_instance==7
            dim_change = 1;
            save dim_change dim_change;
        end
    else
        load x_peaks;
        load h;
        load w;
    end
    if FES==FES_last_change+freq    % dynamic change
        change_count=change_count+1;
        FES_last_change=FES;
        save Dynamic_Change_Info change_count FES_last_change;
        if change_instance>=1 & change_instance<=6
            h = DynamicChange(h,change_instance,h_min,h_max,h_severity,change_count);
            w = DynamicChange(w,change_instance,w_min,w_max,w_severity,change_count);
        elseif change_instance==7
            h = DynamicChange(h,3,h_min,h_max,h_severity,change_count);
            w = DynamicChange(w,3,w_min,w_max,w_severity,change_count);
            load dim_change;
            if dim+dim_change>15 | dim+dim_change<5
                dim_change=-1*dim_change;
                save dim_change dim_change;
            end
            dim = dim+dim_change;
            if dim_change>0           % Dimension is increased by 1.
                x = [x bounds(1)+rand*(bounds(2)-bounds(1))];
                load x_peaks_original;
                x_peaks = [x_peaks x_peaks_original(1:num_peaks,dim)];
            else                      % Dimension is decreased by 1.
                x = x(:,1:dim);
                x_peaks = x_peaks(:,1:dim);
            end
        else
            disp('Incorrect arguements')
        end
        if change_instance==4
            x_peaks = DynamicChange(x_peaks,4,bounds(1),bounds(2),[],change_count);
        else
            l = (dim-1)*mod(dim,2)+dim*(1-mod(dim,2));
            r = randperm(dim);
            r = (r(1:l));
            if change_count==1
                if change_instance~=5 & change_instance~=6
                    theta = rand*pi*2-pi;
                else
                    theta = 0;
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
                end
                save theta theta;
            else
                load theta;
                if change_instance>=1 & change_instance<=4
                    theta = DynamicChange(theta,change_instance,-pi,pi,1,change_count);
                elseif change_instance==5 | change_instance==6
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
                else
                    theta = DynamicChange(theta,3,-pi,pi,1,change_count);
                end
                save theta theta;
            end
            rotation_matrix = eye(dim);
            for i=1:l/2,
                rotation_matrix(r(i*2-1),r(i*2-1)) = cos(theta);
                rotation_matrix(r(i*2),r(i*2)) = cos(theta);
                rotation_matrix(r(i*2-1),r(i*2)) = -sin(theta);
                rotation_matrix(r(i*2),r(i*2-1)) = sin(theta);
            end
            x_peaks = x_peaks*rotation_matrix;
        end
    end
    f = max(h./(1+w.*sqrt(sum((ones(num_peaks,1)*x-x_peaks).^2,2)./dim)));
    % ps=size(x,1);
    % temp=sqrt(sum(abs(repmat(permute(x,[1 3 2]),[1 num_peaks 1])-repmat(permute(x_peaks,[3 1 2]),[ps 1 1])).^2,3)/dim);
    % f=max((ones(ps,1)*h')./(1+(ones(ps,1)*w').*temp),[],2);
%     FES = FES+1;
    save x_peaks x_peaks;
    save h h;
    save w w;
elseif fun_num>=2 & fun_num<=6  % Composition functions
    if FES==0
        load composition_func_data;
        o = o_original(1:10,1:dim);
        if change_instance==4
            load h_original;
            h = h_original(1:10);
        else
            h = initial_height*ones(10,1);
            if change_instance==5 | change_instance==6
                h = DynamicChange(h,change_instance,h_min,h_max,h_severity,0);
            end
        end
        if change_instance==7
            dim_change = 1;
            save dim_change dim_change;
        end
    else
        load o;
        load h;
    end
    if FES==FES_last_change+freq    % dynamic change
        change_count=change_count+1;
        FES_last_change=FES;
        save Dynamic_Change_Info change_count FES_last_change;
        if change_instance>=1 & change_instance<=6
            h = DynamicChange(h,change_instance,h_min,h_max,h_severity,change_count);
        elseif change_instance==7
            h = DynamicChange(h,3,h_min,h_max,h_severity,change_count);
            load dim_change;
            if dim+dim_change>15 | dim+dim_change<5
                dim_change=-1*dim_change;
                save dim_change dim_change;
            end
            dim = dim+dim_change;
            if dim_change>0           % Dimension is increased by 1.
                x = [x bounds(1)+rand*(bounds(2)-bounds(1))];
                load composition_func_data;
                o = [o o_original(1:10,dim)];
            else                      % Dimension is decreased by 1.
                x = x(:,1:dim);
                o = o(:,1:dim);
            end
        else
            disp('Incorrect arguements')
        end
        if change_instance==4
            o = DynamicChange(o,4,bounds(1),bounds(2),[],change_count);
        else
            l = (dim-1)*mod(dim,2)+dim*(1-mod(dim,2));
            r = randperm(dim);
            r = (r(1:l));
            if change_count==1
                if change_instance~=5 & change_instance~=6
                    theta = rand*pi*2-pi;
                else
                    theta = 0;
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
                end
                save theta theta;
            else
                load theta;
                if change_instance>=1 & change_instance<=4
                    theta = DynamicChange(theta,change_instance,-pi,pi,1,change_count);
                elseif change_instance==5 | change_instance==6
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
                else
                    theta = DynamicChange(theta,3,-pi,pi,1,change_count);
                end
                save theta theta;
            end
            rotation_matrix = eye(dim);
            for i=1:l/2,
                rotation_matrix(r(i*2-1),r(i*2-1)) = cos(theta);
                rotation_matrix(r(i*2),r(i*2)) = cos(theta);
                rotation_matrix(r(i*2-1),r(i*2)) = -sin(theta);
                rotation_matrix(r(i*2),r(i*2-1)) = sin(theta);
            end
            o = o*rotation_matrix;
        end
    end
    eval(['load composition_func_M_D' int2str(dim)]);
    
    weight = exp(-sqrt(sum((ones(10,1)*x-o).^2,2)./2./(dim*sigma^2)));
    [tmp,tmpid] = sort(weight,1);     % weight is a 10*1 column vector.
    weight = (weight==tmp(5)).*weight+(weight~=tmp(5)).*(weight.*(1-tmp(5).^10));
    tmp = sum(weight);
    weight = weight./tmp;
    lamda = ones(10,1);
    fmax = zeros(10,1);         % fmax non-negative (as f non-negative)
    f = 0;
    if fun_num==2               % Composition of Sphere function
        lamda = sigma*(bounds(2)-bounds(1))/(domain1(2)-domain1(1))*lamda;
        for i=1:10
            eval(['fmax(i) = fsphere((domain1(2)*ones(1,dim))*M' int2str(i) ');']);
            eval(['f = f+weight(i)*(C*fsphere(((x-o(i,:))/lamda(i))*M' int2str(i) ')/fmax(i)+h(i));']);
        end
    elseif fun_num==3           % Composition of Rastrigin's function
        lamda = sigma*(bounds(2)-bounds(1))/(domain2(2)-domain2(1))*lamda;
        for i=1:10
            eval(['fmax(i) = frastrigin((domain2(2)*ones(1,dim))*M' int2str(i) ');']);
            eval(['f = f+weight(i)*(C*frastrigin(((x-o(i,:))/lamda(i))*M' int2str(i) ')/fmax(i)+h(i));']);
        end
    elseif fun_num==4           % Composition of Griewank's function
        lamda = sigma*(bounds(2)-bounds(1))/(domain4(2)-domain4(1))*lamda;
        for i=1:10
            eval(['fmax(i) = fgriewank((domain4(2)*ones(1,dim))*M' int2str(i) ');']);
            eval(['f = f+weight(i)*(C*fgriewank(((x-o(i,:))/lamda(i))*M' int2str(i) ')/fmax(i)+h(i));']);
        end
    elseif fun_num==5           % Composition of Ackley's function
        lamda = sigma*(bounds(2)-bounds(1))/(domain5(2)-domain5(1))*lamda;
        for i=1:10
            eval(['fmax(i) = fackley((domain5(2)*ones(1,dim))*M' int2str(i) ');']);
            eval(['f = f+weight(i)*(C*fackley(((x-o(i,:))/lamda(i))*M' int2str(i) ')/fmax(i)+h(i));']);
        end
    elseif fun_num==6           % Hybrid Composition function
        
        lamda(1) = sigma*(bounds(2)-bounds(1))/(domain1(2)-domain1(1));
        lamda(2) = lamda(1);
        lamda(3) = sigma*(bounds(2)-bounds(1))/(domain5(2)-domain5(1));
        lamda(4) = lamda(3);
        lamda(5) = sigma*(bounds(2)-bounds(1))/(domain4(2)-domain4(1));
        lamda(6) = lamda(5);
        lamda(7) = sigma*(bounds(2)-bounds(1))/(domain2(2)-domain2(1));
        lamda(8) = lamda(7);
        lamda(9) = sigma*(bounds(2)-bounds(1))/(domain3(2)-domain3(1));
        lamda(10) = lamda(9);
        fmax(1) = fsphere((domain1(2)*ones(1,dim))*M1);
        fmax(2) = fsphere((domain1(2)*ones(1,dim))*M2);
        fmax(3) = fackley((domain5(2)*ones(1,dim))*M3);
        fmax(4) = fackley((domain5(2)*ones(1,dim))*M4);
        fmax(5) = fgriewank((domain4(2)*ones(1,dim))*M5);
        fmax(6) = fgriewank((domain4(2)*ones(1,dim))*M6);
        fmax(7) = frastrigin((domain2(2)*ones(1,dim))*M7);
        fmax(8) = frastrigin((domain2(2)*ones(1,dim))*M8);
        fmax(9) = fweierstrass((domain3(2)*ones(1,dim))*M9);
        fmax(10) = fweierstrass((domain3(2)*ones(1,dim))*M10);
        f = f+weight(1)*(C*fsphere(((x-o(1,:))/lamda(1))*M1)/fmax(1)+h(1));
        f = f+weight(2)*(C*fsphere(((x-o(2,:))/lamda(2))*M2)/fmax(2)+h(2));
        f = f+weight(3)*(C*fackley(((x-o(3,:))/lamda(3))*M3)/fmax(3)+h(3));
        f = f+weight(4)*(C*fackley(((x-o(4,:))/lamda(4))*M4)/fmax(4)+h(4));
        f = f+weight(5)*(C*fgriewank(((x-o(5,:))/lamda(5))*M5)/fmax(5)+h(5));
        f = f+weight(6)*(C*fgriewank(((x-o(6,:))/lamda(6))*M6)/fmax(6)+h(6));
        f = f+weight(7)*(C*frastrigin(((x-o(7,:))/lamda(7))*M7)/fmax(7)+h(7));
        f = f+weight(8)*(C*frastrigin(((x-o(8,:))/lamda(8))*M8)/fmax(8)+h(8));
        f = f+weight(9)*(C*fweierstrass(((x-o(9,:))/lamda(9))*M9)/fmax(9)+h(9));
        f = f+weight(10)*(C*fweierstrass(((x-o(10,:))/lamda(10))*M10)/fmax(10)+h(10));
        
    end
%     FES = FES+1;
    save o o;
    save h h;
else
    disp('Incorrect arguements')
end
if(fun_num == 1)
    error = max(h)-f;
else
    error = f - min(h);
end
performance(f,fun_num,change_instance,FES,dim,num_runs,h,fun_opts);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The functions below are changed from CEC'2005 test problems.
% Please refer to http://www3.ntu.edu.sg/home/EPNSugan/ for original files.

function f = fsphere(x)
f = sum((x.*20).^2,2);
%--------------------------------
function f = frastrigin(x)
f = sum(x.^2-10.*cos(2.*pi.*x)+10,2);
%--------------------------------
function f = fweierstrass(x)
[ps,D] = size(x);
x = x+0.5;
a = 0.5;
b = 3;
kmax = 20;
c1(1:kmax+1) = a.^(0:kmax);
c2(1:kmax+1) = 2*pi*b.^(0:kmax);
f = zeros(ps,1);
for i=1:D,
    f = f+sum((ones(ps,1)*c1).*cos(x(:,i)*c2),2);
end
f = f-D*sum(c1.*cos(c2/2));
%--------------------------------
function f = fgriewank(x)
[ps,D] = size(x);
f = ones(ps,1);
for i=1:D,
    f = f.*cos(x(:,i)./sqrt(i));
end
f = sum(x.^2,2)./4000-f+1;
%--------------------------------
function f = fackley(x)
D = size(x,2);
f = sum(x.^2,2);
f = 20-20.*exp(-0.2.*sqrt(f./D))-exp(sum(cos(2.*pi.*x),2)./D)+exp(1);