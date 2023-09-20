function [univec] = F_univec(popnum, M)

    H=floor((popnum*prod(1:M-1))^(1/(M-1)));
    while nchoosek(H+M-1,M-1)>=popnum && H>0
        H=H-1;
    end
    if nchoosek(H+M,M-1)<=2*popnum || H==0
        H=H+1;
    end
    popnum=nchoosek(H+M-1,M-1);
    temp=nchoosek(1:H+M-1,M-1)-repmat(0:M-2,nchoosek(H+M-1,M-1),1)-1;
    W=zeros(popnum,M);
    W(:,1)=temp(:,1)-0;
    for i=2:M-1
        W(:,i)=temp(:,i)-temp(:,i-1);
    end
    W(:,end)=H-temp(:,end);
    W=W/H;

    for i = 1:size(W,1)
        univec(i,:) = W(i,:)/norm(W(i,:));
    end;
    
    if(M == 3)
%          [sorted rank] = sort(univec(:,3) + univec(:,2), 'ascend');
%          univec = univec(rank,:);
        
        lines = unique(univec(:, 3));
        [lines rank] = sort(lines, 'ascend');
        tunivec = [];
        for i = 1:length(lines)
            idx = find(univec(:,3) == lines(i));
            seg = univec(idx,:);
            [sorted rank] = sort(seg(:,2), 'ascend');
            seg = seg(rank, :);
            tunivec = [tunivec; seg];
        end;
        univec = tunivec;
        
%         [sorted rank] = sort(univec(:,2), 'ascend');
%         univec = univec(rank,:);
    end;

end
    