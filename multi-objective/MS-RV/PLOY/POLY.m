function b=POLY(S,Y,flag)
%POLY.m computes the coefficients of a regression polynomial of the 
%specified degree
%
%--------------------------------------------------------------------------
%Copyright (c) 2013 by Juliane Mueller
%
%This file is part of MATSuMoTo.m - the MATLAB Surrogate Model Toolbox
%MATSuMoTo is free software: you can redistribute it and/or modify it under
%the terms of the GNU General Public License as published by the Free 
%Software Foundation, either version 3 of the License, or (at your option) 
%any later version.
%
%MATSuMoTo is distributed in the hope that it will be useful, but WITHOUT 
%ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
%FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for 
%more details.
%
%You should have received a copy of the GNU General Public License along 
%with MATSuMoTo.  If not, see <http://www.gnu.org/licenses/>.
%--------------------------------------------------------------------------
%Author information
%Juliane Mueller
%juliane.mueller2901@gmail.com
%--------------------------------------------------------------------------        
%
%Input:
%S - sample site matrix
%Y - objective function values corresponding to the points in S
%flag - determines the order of polynomial model
%
%Output:
%b - vector with parameters
%--------------------------------------------------------------------------

[m,n]=size(S); %determine number of points and dimension of S

%linear model
if strcmp(flag,'lin') %first order polynomial
    X=[ones(m,1) S]; %matrix augmented with vector of ones for intercept
    b=((X'*X)\X')*Y;  %solve least squares problem
%full quadratic    
elseif strcmp(flag,'quad') % f= b0 + b1 x1 + b2 x2+...+bn  xn + b12 x1x2 + b13 x1x3+...+b11 x1^2 + ...+bnn xn^2 
    X=[ones(m,1) S S.^2]; %set up matrix with entries for each term
    ii=1;
    while ii < n
        jj=ii+1;
        while jj <= n
            x=S(:,ii).*S(:,jj);
            jj=jj+1;
            X=[X,x];
        end
        ii=ii+1;
    end
    b=((X'*X)\X')*Y; %solve least squares problem
%full cubic    
elseif strcmp(flag,'cub') % f= b0 + b1x1 + b1b2 x1x2 + b1b2b3 x1x2x3+...+b11 x1^2 + ...+bnnn xn^3 
    X=[ones(m,1) S S.^2 S.^3]; %set up matrix with entries for each term
    ii=1;
    while ii < n %x_i x_j type terms
        jj=ii+1;
        while jj <= n            
            x=S(:,ii).*S(:,jj);
            jj=jj+1;
            X=[X,x];
        end
        ii=ii+1;
    end
    
    ii=1;
    while ii < n-1 %x_i x_j x_k type terms
        jj=ii+1;
        while jj < n
            kk= jj +1; 
            while kk <= n
                x=S(:,ii).*S(:,jj).*S(:,kk);
                kk=kk+1;
                X=[X,x];
            end
            jj=jj+1;
        end
        ii=ii+1;
    end   
    b=((X'*X)\X')*Y;  %solve least squares problem   
%reduced quadratic    
elseif strcmp(flag,'quadr') %f = b0+ b1 x1 + b2 x2 + ...  bn xn + b11 x1^2 + b22 x2^2...
    X=[ones(m,1) S S.^2]; %set up matrix with entries for each term
    b=((X'*X)\X')*Y;    %solve least squares problem 
%reduced cubic    
elseif strcmp(flag,'cubr') %f = b0+ b1 x1 + b2 x2 + ...  bn xn + b11 x1^2 + b22 x2^2...+b111 x1^3 + b222 x2^3+...
    X=[ones(m,1) S S.^2 S.^3]; %set up matrix with entries for each term
    b=((X'*X)\X')*Y;     %solve least squares problem
end

end %function