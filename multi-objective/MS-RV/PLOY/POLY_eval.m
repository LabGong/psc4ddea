function Yest=POLY_eval(X,b,flag)
%POLY_EVAL.m uses polynomial regression model to predict objective function
%values
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
%Input 
%X - matrix containing points where prediction wanted
%b - parameter vector computed with POLY.m
%flag - order of polynomial, must be same as flag used for computing vector b
%
%Output
%Yest - predicted objective function values corresponding to the points in
%S
%--------------------------------------------------------------------------

[m,n]=size(X); %number of points in X and dimension

if strcmp(flag,'lin') %first order polynomial
    Xs=[ones(m,1) X];
    Yest=Xs*b;    %predict function values
elseif strcmp(flag,'quad') %  full quadratic polynomial
    Xs=[ones(m,1) X X.^2];
    ii=1;
    while ii < n
        jj=ii+1;
        while jj <= n
            x=X(:,ii).*X(:,jj);
            jj=jj+1;
            Xs=[Xs,x];
        end
        ii=ii+1;
    end
    Yest=Xs*b; %predict function values
elseif strcmp(flag,'cub') %full cubic polynomial
    Xs=[ones(m,1) X X.^2 X.^3];
    ii=1;
    while ii < n %x_i x_j type terms
        jj=ii+1;
        while jj <= n            
            x=X(:,ii).*X(:,jj);
            jj=jj+1;
            Xs=[Xs,x];
        end
        ii=ii+1;
    end    
    ii=1;
    while ii < n-1 %x_i x_j x_k type terms
        jj=ii+1;
        while jj < n
            kk= jj +1; 
            while kk <= n
                x=X(:,ii).*X(:,jj).*X(:,kk);
                kk=kk+1;
                Xs=[Xs,x];
            end
            jj=jj+1;
        end
        ii=ii+1;
    end   
    Yest=Xs*b;%predict function values
elseif strcmp(flag,'quadr') %reduced quadratic polynomial.
    Xs=[ones(m,1) X X.^2];
    Yest=Xs*b; %predict function values
elseif strcmp(flag,'cubr') %reduced cubic polynomial
    Xs=[ones(m,1) X X.^2 X.^3];
    Yest=Xs*b; %predict function values
end
end %function