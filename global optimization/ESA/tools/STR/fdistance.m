function [ d ] = fdistance( a,A )
%FDISTANCE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if isempty(A)
    d=1;
else
    d=min(pdist2(a,A));
end

end

