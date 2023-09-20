function [f] = Bench_Func(operation,parameter,funcid)
%%%Benchmark Functions with Linear and Non-linear variable linkages%%%

% operation: 'value' fitness evaluation
%            'true'  true Pareto front sample
% parameter: if operation == 'value', parameter is x 
%            e.g. Bench_Func('value',x, funcid)
%            if operation == 'true', parameter is the sample size
%            e.g. Bench_Func('true',500, funcid)
    
    global AA BB;
    switch operation
        case 'value'
            x = parameter;
            switch funcid
                case 'F1'
                    [m n] = size(x); 
                    A = repmat(AA, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 9*(sum((A.*x(:,2:end) - repmat(x(:,1), [1 n - 1])).^2,2))/(n - 1);
                    f(:,1) = x(:,1); 
                    f(:,2) = g.*(1 - sqrt(f(:,1)./g));
                case 'F2'
                    [m n] = size(x); 
                    A = repmat(AA, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 9*(sum((A.*x(:,2:end) - repmat(x(:,1), [1 n - 1])).^2,2))/(n - 1);
                    f(:,1) = x(:,1); 
                    f(:,2) = g.*(1 - (f(:,1)./g).^2);
                case 'F3'
                    [m n] = size(x); 
                    A = repmat(AA, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 9*(sum((A.*x(:,2:end) - repmat(x(:,1), [1 n - 1])).^2,2)./(n-1));
                    f(:,1) = 1 - exp(-4*x(:,1)).*sin(6*pi*x(:,1)).^6; 
                    f(:,2) = g.*(1 - (f(:,1)./g).^2);
                case 'F4'
                    [m n] = size(x); 
                    A = repmat(AA, [m 1]);
                    f = zeros(m,3);
                    g = sum((A.*x(:,3:end) - repmat(x(:,1), [1 n - 2])).^2,2);
                    f(:,1) = cos(0.5*pi*x(:,1)).*cos(0.5*pi*x(:,2)).*(1 + g);
                    f(:,2) = cos(0.5*pi*x(:,1)).*sin(0.5*pi*x(:,2)).*(1 + g);
                    f(:,3) = sin(0.5*pi*x(:,1)).*(1 + g);
                case 'F5'
                    [m n] = size(x); 
                    B = repmat(BB, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 9*(sum((x(:,2:end).^(B) - repmat(x(:,1), [1 n - 1])).^2,2))/(n - 1);
                    f(:,1) = x(:,1); 
                    f(:,2) = g.*(1 - sqrt(f(:,1)./g));
                case 'F6'
                    [m n] = size(x); 
                    B = repmat(BB, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 9*(sum((x(:,2:end).^(B) - repmat(x(:,1), [1 n - 1])).^2,2))/(n - 1);
                    f(:,1) = x(:,1); 
                    f(:,2) = g.*(1 - (f(:,1)./g).^2);
                case 'F7'
                    [m n] = size(x); 
                    B = repmat(BB, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 9*((sum((x(:,2:end).^(B) - repmat(x(:,1), [1 n - 1])).^2,2)./(n - 1)));
                    f(:,1) = 1 - exp(-4*x(:,1)).*sin(6*pi*x(:,1)).^6; 
                    f(:,2) = g.*(1 - (f(:,1)./g).^2);
                case 'F8'
                    [m n] = size(x); 
                    B = repmat(BB, [m 1]);
                    f = zeros(m,3);
                    g = sum((x(:,3:end).^(B) - repmat(x(:,1), [1 n - 2])).^2,2);
                    f(:,1) = cos(0.5*pi*x(:,1)).*cos(0.5*pi*x(:,2)).*(1 + g);
                    f(:,2) = cos(0.5*pi*x(:,1)).*sin(0.5*pi*x(:,2)).*(1 + g);
                    f(:,3) = sin(0.5*pi*x(:,1)).*(1 + g);
                case 'F9'
                    [m n] = size(x); 
                    B = repmat(BB, [m 1]);
                    f = zeros(m,2);
                    g = 2 + (1/4000)*(sum((x(:,2:end).^(B) - repmat(x(:,1), [1 n - 1])).^2,2)) - prod(cos((x(:,2:end).^(B) - repmat(x(:,1), [1 n - 1]))./(repmat(1:n - 1,m,1)).^0.5),2);
                    f(:,1) = x(:,1); 
                    f(:,2) = g.*(1 - sqrt(f(:,1)./g));
                case 'F10'
                    [m n] = size(x); 
                    B = repmat(BB, [m 1]);
                    f = zeros(m,2);
                    g = 1 + 10*(n - 1) + sum((x(:,2:end).^B - repmat(x(:,1), [1 n - 1])).^2, 2) - 10*sum(cos(2 .* pi .*(x(:,2:end).^B - repmat(x(:,1), [1 n - 1]))), 2);
                    f(:,1) = x(:,1); 
                    f(:,2) = g.*(1 - sqrt(f(:,1)./g));
                    
            end;
        case 'true'
            m = parameter;
            switch funcid
                case {'F1', 'F5', 'F9', 'F10'}
                    f = zeros(m + 1,2);
                    f(:,1) = [0:m]./m;
                    f(:,2) = 1 - sqrt(f(:,1));
                case {'F2', 'F6'}
                    f = zeros(m + 1,2);
                    f(:,1) = [0:m]./m;
                    f(:,2) = 1 - (f(:,1)).^2;
                case {'F3', 'F7'}
                    f = zeros(m + 1,2);
                    x1 = [0:m]./m;
                    f(:,1) = 1 - exp(-4*x1).*sin(6*pi*x1).^6;
                    f(:,2) = 1 - (f(:,1)).^2;
                case {'F4', 'F8'}
                    m = ceil(sqrt(m));
                    temp = [0:m]./m;
                    [x1,x2] = ndgrid(temp);
                    x = [x1(:), x2(:)];
                    f = zeros((m + 1)*(m + 1),3);
                    f(:,1) = cos(0.5*pi*x(:,1)).*cos(0.5*pi*x(:,2));
                    f(:,2) = cos(0.5*pi*x(:,1)).*sin(0.5*pi*x(:,2));
                    f(:,3) = sin(0.5*pi*x(:,1));
            end;
    end;
end

