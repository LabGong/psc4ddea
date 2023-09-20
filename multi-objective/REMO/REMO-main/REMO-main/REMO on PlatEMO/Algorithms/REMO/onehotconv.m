function varargout = onehotconv(varargin)
    if varargin{2}== 1
        %% conv onehot
        l = varargin{1};      
        l_onehot = zeros(size(l,1),3);
     
        l_onehot(l == 1 ,1) = 1;
        l_onehot(l == 0,2) = 1;
        l_onehot(l == -1,3) = 1;
        
        varargout = {l_onehot};
        
    elseif varargin{2} == 2
        %% deconv onehot
        
        % ÐèÒªÐÞ¸Ä
        
        onehot_l = varargin{1};
        res_l = zeros(size(onehot_l,1),1);
        
        [~,maxind] = max(onehot_l,[],2);
        
        res_l(maxind==1) = 1;
        res_l(maxind==3) = -1;
        
        
        varargout = {res_l};
    end

end

