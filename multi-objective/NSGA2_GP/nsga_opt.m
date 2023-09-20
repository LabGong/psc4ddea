function chrom=nsga_opt(tr_x, tr_y, Problem, ceng, itr, iter, mat_coef)
    
    global M V L1 Ke;
    inf=@infExact;
    cov =  @covSEiso; %cov=@covLIN;
    lik = @likGauss;

    %模型更新，不断找使EI最大的点
    for i=1:iter
        for j=1:M
            hyp(j).mean = [];   
            hyp(j).cov = [0;0];%hyp.cov = [];
            hyp(j).lik = log(0.01);
            hyp(j) = minimize(hyp(j), @gp, -100, inf, [], cov, lik, tr_x, tr_y(:,j));
        end
        [center, U] = FCMClust(tr_x); 
        data=zeros(size(center,1),L1);
        if ~isempty(center)
            for j=1:size(center,1)
                [result1, index]=sort(U(j,:));
                indice=index(end:-1:1);%highest membership
                data(j,:)=(indice(1:L1));%属于center(i)的训练数据索引
            end
        end
        
        xnew=nsga_2(hyp, center, data, tr_x, tr_y);
        comb=nchoosek([1:V],2);
        for j=1:size(comb,1)
            X(:,j)=xnew(:,comb(j,1)).*xnew(:,comb(j,2));
        end
        XX=[X, xnew.^2, xnew, ones(Ke,1)];
        for j=1:M
            ynew(:,j)=sum(repmat(mat_coef(j,:), Ke, 1).*XX,2);
        end  
        tr_x=[tr_x;xnew];tr_y=[tr_y;ynew];
        disp(sprintf('%s :  %u / %u inner loop of %u / %u outside loop finished', Problem, i, iter, ceng, itr));
    end
    chrom(:,1:V)=tr_x;chrom(:,V+1:V+M)=tr_y;
