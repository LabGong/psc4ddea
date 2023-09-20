function [XXs,YYs] = Delequalsamples(XXs,YYs)

    zerosindex = YYs ==0;
    XXs(zerosindex,:) = [];
    YYs(zerosindex) = [];
    
end

