function [M, n, lower, upper] = F_funcinit(probIdx)
%intialization for the benchmark test functions

%input: probIdx - poblem index
%output: M - objective number
%        n - decision variable number
%        lower - lower boundary of decision variables
%        upper - upper boundary of decision variables

%parameters in the test functions
alpha = 5; beta = 3;
global AA BB;

%objective number
if(probIdx == 4 || probIdx == 8)
    M = 3;
else
    M = 2;
end
%decision variable number
n = 10;
%test function initialization
if(M == 2)
    AA = 1 + alpha.*([2:n]/n);
    BB = 1./(1 + beta.*[2:n]/n);
else
    AA = 1 + alpha.*[3:n]/n;
    BB = 1./(1 + beta.*[3:n]/n);
end
%boundary settings of the functions
lower = zeros(1,n);
if( probIdx == 9 || probIdx == 10 )
    upper = 10*ones(1,n);
    upper(1) = 1;
else
    upper = ones(1,n);
end

end