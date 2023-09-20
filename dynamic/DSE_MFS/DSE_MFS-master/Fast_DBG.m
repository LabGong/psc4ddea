function [error,h] = Fast_DBG(x,fun_num,change_instance,FES,num_runs,dim,fun_opts)
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
persistent dim_change;
persistent change_count;
persistent FES_last_change;
persistent theta;
persistent saved_x_peaks;
global x_peaks;
global h;
persistent w;
persistent saved_o;
global o;
persistent func_handles;
persistent M;
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
    %     save Dynamic_Change_Info change_count FES_last_change;
end
% load Dynamic_Change_Info;

if fun_num==1                   % Rotation peak function
    num_peaks = fun_opts;
    if isempty(num_peaks)
        num_peaks = 10;
    end
    if FES==0
        load x_peaks_original;
        saved_x_peaks = x_peaks_original(1:num_peaks,1:dim);
        x_peaks = saved_x_peaks;
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
            %             save dim_change dim_change;
        end
    end
    if FES==FES_last_change+freq    % dynamic change
        change_count=change_count+1;
        FES_last_change=FES;
        %         save Dynamic_Change_Info change_count FES_last_change;
        if change_instance>=1 & change_instance<=6
            h = DynamicChange(h,change_instance,h_min,h_max,h_severity,change_count);
            w = DynamicChange(w,change_instance,w_min,w_max,w_severity,change_count);
        elseif change_instance==7
            h = DynamicChange(h,3,h_min,h_max,h_severity,change_count);
            w = DynamicChange(w,3,w_min,w_max,w_severity,change_count);
            %             load dim_change;
            if dim+dim_change>15 | dim+dim_change<5
                dim_change=-1*dim_change;
                %                 save dim_change dim_change;
            end
            dim = dim+dim_change;
            if dim_change>0           % Dimension is increased by 1.
                x = [x bounds(1)+rand*(bounds(2)-bounds(1))];
                load x_peaks_original;
                saved_x_peaks = [saved_x_peaks x_peaks_original(1:num_peaks,dim)];
                x_peaks = saved_x_peaks;
            else                      % Dimension is decreased by 1.
                x = x(:,1:dim);
                saved_x_peaks = saved_x_peaks(:,1:dim);
                x_peaks = saved_x_peaks;
            end
        else
            disp('Incorrect arguements')
        end
        if change_instance==4
            saved_x_peaks = DynamicChange(saved_x_peaks,4,bounds(1),bounds(2),[],change_count);
            x_peaks = saved_x_peaks;
        else
            l = (dim-1)*mod(dim,2)+dim*(1-mod(dim,2));
            r = randperm(dim);
            r = (r(1:l));
            if change_count==1 && (change_instance == 5 || change_instance == 6)
                    theta = 0;
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
            else
                if change_instance>=1 & change_instance<=4
                    theta = DynamicChange(0,change_instance,-pi,pi,1,change_count);
                elseif change_instance==5 | change_instance==6
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
                else
                    theta = DynamicChange(theta,3,-pi,pi,1,change_count);
                end
            end
            rotation_matrix = eye(dim);
            for i=1:l/2
                rotation_matrix(r(i*2-1),r(i*2-1)) = cos(theta);
                rotation_matrix(r(i*2),r(i*2)) = cos(theta);
                rotation_matrix(r(i*2-1),r(i*2)) = -sin(theta);
                rotation_matrix(r(i*2),r(i*2-1)) = sin(theta);
            end
            if change_instance==5 || change_instance==6
                load x_peaks_original;
                saved_x_peaks = x_peaks_original(1:num_peaks,1:dim);
            end
            saved_x_peaks = saved_x_peaks*rotation_matrix;
            x_peaks = saved_x_peaks;
            x_peaks(x_peaks>bounds(2))=bounds(2);
            x_peaks(x_peaks<bounds(1))=bounds(1);
        end
    end
    sx = sum(x.^2,2);
    sxp = sum(x_peaks.^2,2);
    
%     f = max(h./(1+w.*sqrt(sum((ones(num_peaks,1)*x-x_peaks).^2,2)./dim)));
    f=bsxfun(@ldivide,1+bsxfun(@times,sqrt(abs(bsxfun(@plus,bsxfun(@plus,-2*x*x_peaks', sx), sxp'))./dim),w'),h');
    f=max(f,[],2);
    FES = FES+size(x,1);
    
elseif fun_num>=2 && fun_num<=6  % Composition functions
    if FES==0
        load composition_func_data;
        saved_o = o_original(1:10,1:dim);
        o = saved_o;
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
            %             save dim_change dim_change;
        end
        
        eval(['load composition_func_M_D' int2str(dim)]);
        M={M1,M2,M3,M4,M5};
        switch(fun_num)
            case 2
                func_handles={@fsphere,@fsphere,@fsphere,@fsphere,@fsphere};
            case 3
                func_handles={@frastrigin,@frastrigin,@frastrigin,@frastrigin,@frastrigin};
            case 4
                func_handles={@fgriewank,@fgriewank,@fgriewank,@fgriewank,@fgriewank};
            case 5
                func_handles={@fackley,@fackley,@fackley,@fackley,@fackley};
            case 6
                func_handles={@fsphere,@fackley,@fgriewank,@frastrigin,@fweierstrass};
        end
    else
        %         load o;
        %         load h;
    end
    if FES==FES_last_change+freq    % dynamic change
        change_count=change_count+1;
        FES_last_change=FES;
        %         save Dynamic_Change_Info change_count FES_last_change;
        if change_instance>=1 & change_instance<=6
            h = DynamicChange(h,change_instance,h_min,h_max,h_severity,change_count);
        elseif change_instance==7
            h = DynamicChange(h,3,h_min,h_max,h_severity,change_count);
            %             load dim_change;
            if dim+dim_change>15 | dim+dim_change<5
                dim_change=-1*dim_change;
                %                 save dim_change dim_change;
            end
            dim = dim+dim_change;
            if dim_change>0           % Dimension is increased by 1.
                x = [x bounds(1)+rand*(bounds(2)-bounds(1))];
                load composition_func_data;
                saved_o = [saved_o o_original(1:10,dim)];
                o = saved_o;
            else                      % Dimension is decreased by 1.
                x = x(:,1:dim);
                saved_o = saved_o(:,1:dim);
                o = saved_o;
            end
            eval(['load composition_func_M_D' int2str(dim)]);
            M={M1,M2,M3,M4,M5,M6,M7,M8,M9,M10};
        else
            disp('Incorrect arguements')
        end
        if change_instance==4
            saved_o = DynamicChange(saved_o,4,bounds(1),bounds(2),[],change_count);
            o = saved_o;
        else
            l = (dim-1)*mod(dim,2)+dim*(1-mod(dim,2));
            r = randperm(dim);
            r = (r(1:l));
            if change_count==1 && (change_instance == 5 || change_instance == 6)
                    theta = 0;
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
            else
                %                 load theta;
                if change_instance>=1 && change_instance<=4
                    theta = DynamicChange(0,change_instance,-pi,pi,1,change_count);
                elseif change_instance==5 || change_instance==6
                    theta = DynamicChange(theta,change_instance,0,pi/6,1,change_count);
                else
                    theta = DynamicChange(theta,3,-pi,pi,1,change_count);
                end
                %                 save theta theta;
            end
            rotation_matrix = eye(dim);
            for i=1:l/2
                rotation_matrix(r(i*2-1),r(i*2-1)) = cos(theta);
                rotation_matrix(r(i*2),r(i*2)) = cos(theta);
                rotation_matrix(r(i*2-1),r(i*2)) = -sin(theta);
                rotation_matrix(r(i*2),r(i*2-1)) = sin(theta);
            end
            if change_instance==5 || change_instance==6
                load composition_func_data;
                saved_o = o_original(1:10,1:dim);
            end
            saved_o = saved_o*rotation_matrix;
            o = saved_o;
            o(o>bounds(2))=bounds(2);
            o(o<bounds(1))=bounds(1);
        end
    end
    %%
%     weight = zeros(size(x,1),10);
%     for k = 1:size(x,1)
%         weight(k,:) = (exp(-sqrt(sum((ones(10,1)*x(k,:)-o).^2,2)./2./(dim*sigma^2))))';
%         [tmp,tmpid] = sort(weight(k,:),2);     % weight is a 10*1 column vector.
%         weight(k,:) = (weight(k,:)==tmp(10)).*weight(k,:)+(weight(k,:)~=tmp(10)).*(weight(k,:).*(1-tmp(10).^10));
%         tmp = sum(weight(k,:));
%         weight(k,:) = weight(k,:)./tmp;
%     end
%     weightold = weight;
    %%
    sx = sum(x.^2,2);
    so = sum(o.^2,2);
    weight = exp(-sqrt(abs(bsxfun(@plus,bsxfun(@plus,-2*x*o', sx), so'))./(2*dim*sigma^2)));
    [max_weight,~] = max(weight,[],2);
%     weight = bsxfun(@times,weight,1-power(max_weight,10));
%     weight = bsxfun(@lt, weight, max_weight).*bsxfun(@times,weight,1-power(max_weight,10)) + bsxfun(@ge, weight, max_weight).*weight;
    extended_max_weight = repmat(max_weight,[1,num_basic_fun]);
    weight = (weight==extended_max_weight).*weight + (weight~=extended_max_weight).*(weight.*(1-extended_max_weight.^10));
    sum_weight = sum(weight,2);
    weight = bsxfun(@rdivide,weight,sum_weight);
    
%     delta = weightold - weight;
    %%
    lamda = ones(10,1);
    f = 0;
    switch(fun_num)
        case 2
            x_max = ones(1,dim)*domain1(2);
            lamda = sigma*(bounds(2)-bounds(1))/(domain1(2)-domain1(1))*lamda;
        case 3
            x_max = ones(1,dim)*domain2(2);
            lamda = sigma*(bounds(2)-bounds(1))/(domain2(2)-domain2(1))*lamda;
        case 4
            x_max = ones(1,dim)*domain4(2);
            lamda = sigma*(bounds(2)-bounds(1))/(domain4(2)-domain4(1))*lamda;
        case 5
            x_max = ones(1,dim)*domain5(2);
            lamda = sigma*(bounds(2)-bounds(1))/(domain5(2)-domain5(1))*lamda;
    end
    for i=1:5
        if(fun_num==6)
            lamda = ones(10,1);
            switch (i)
                case {1,2}
                    x_max = ones(1,dim)*domain1(2);
                    lamda = sigma*(bounds(2)-bounds(1))/(domain1(2)-domain1(1))*lamda;
                case {3,4}
                    x_max = ones(1,dim)*domain5(2);
                    lamda = sigma*(bounds(2)-bounds(1))/(domain5(2)-domain5(1))*lamda;
                case {5,6}
                    x_max = ones(1,dim)*domain4(2);
                    lamda = sigma*(bounds(2)-bounds(1))/(domain4(2)-domain4(1))*lamda;
                case {7,8}
                    x_max = ones(1,dim)*domain2(2);
                    lamda = sigma*(bounds(2)-bounds(1))/(domain2(2)-domain2(1))*lamda;
                case {9,10}
                    x_max = ones(1,dim)*domain3(2);
                    lamda = sigma*(bounds(2)-bounds(1))/(domain3(2)-domain3(1))*lamda;
            end
        end
        fmax = feval(func_handles{i},x_max*M{i});
        f = f + weight(:,i).*(C*feval(func_handles{i},(bsxfun(@minus,x,o(i,:))./lamda(i))*M{i})/fmax+ h(i));
    end
%     FES = FES+size(x,1);
else
    disp('Incorrect arguements')
end
if(fun_num == 1)
    error = max(h)-f;
else
    error = f - min(h);
end
% performance(f,fun_num,change_instance,FES,dim,num_runs,h,fun_opts);


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
for i=1:D
    f = f+sum((ones(ps,1)*c1).*cos(x(:,i)*c2),2);
end
f = f-D*sum(c1.*cos(c2/2));
%--------------------------------
function f = fgriewank(x)
[ps,D] = size(x);
f = ones(ps,1);
for i=1:D
    f = f.*cos(x(:,i)./sqrt(i));
end
f = sum(x.^2,2)./4000-f+1;
%--------------------------------
function f = fackley(x)
D = size(x,2);
f = sum(x.^2,2);
f = 20-20.*exp(-0.2.*sqrt(f./D))-exp(sum(cos(2.*pi.*x),2)./D)+exp(1);