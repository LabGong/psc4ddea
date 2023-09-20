function ind = F_associate(vec, cent)
%function to perform population partition

%input: x - decision vectors
%output: class - the partition of the population
 clear association
  unim = size(cent,1); 
  dis = pdist2(vec,cent); 
  [~,ind] = min(dis,[],2);
%   association = struct('c',cell(1,unim)); 
%   
%   for i = 1:unim
%       cc = find(ind==i); 
%      association(i).c = cc;
%   end