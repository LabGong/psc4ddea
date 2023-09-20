function [TX,TY] = updateGX(GTX,GTY,Maxgt)
if size(GTX,1)> Maxgt
    Next   = zeros(1,Maxgt);
    [IDX,~] = kmeans(GTX,Maxgt);
    for i   = unique(IDX)'
        current = find(IDX==i);
        if length(current)>1
            best = randi(length(current),1);
        else
            best = 1;
        end
        Next(i)  = current(best);
    end
    TX = GTX(Next,:);
    TY = GTY(Next,:);
else
    TX = GTX;
    TY = GTY;
end
end