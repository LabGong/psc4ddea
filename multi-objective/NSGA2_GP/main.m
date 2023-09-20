clear;clc;%3h:50-50

tic;
load ini10.mat
itr=10;
global M V L1 MaxValue MinValue Ke
L1=130; Ke=5;
Problems={'DTLZ1','DTLZ4','DTLZ5','WFG2','WFG3','WFG4','WFG5','ZDT3','ZDT6'};
rand('seed', sum(100 * clock));

for Prob = 9:length(Problems)
    clear result
    Problem=Problems{Prob};
    [V,M,iter,MaxValue,MinValue]=settings(Problem);
    for k=1:itr
        clear mat_coef X
        tr_x=ini(k).chrom;
        tr_x = tr_x.*repmat(MaxValue,11*V-1,1)+(1-tr_x).*repmat(MinValue,11*V-1,1);
        tr_y=obj_real(tr_x,Problem);        
        maxx=max(tr_y, [],1);minn=min(tr_y,[],1);
        NoiseVar = 0.1;SN=11*V-1;
        Noise = (2*rand(SN,M)-1).*NoiseVar.*repmat((maxx-minn),SN,1);
        tr_y=tr_y+Noise;
        comb=nchoosek([1:V],2);
        for i=1:size(comb,1)
            X(:,i)=tr_x(:,comb(i,1)).*tr_x(:,comb(i,2));
        end
        XX=[X, tr_x.^2, tr_x, ones(SN,1)];
        for i=1:M
            [b,bint,r,rint,stats]=regress(tr_y(:,i),XX);
            mat_coef(i,:)=b;
        end
        expr(k).b=mat_coef;
        chrom=nsga_opt(tr_x, tr_y, Problem, k, itr, iter, mat_coef);
        result(k).ch=chrom;
    end 
    num = find(~isstrprop(Problem,'digit'),1,'last');
    str=[Problem(1) Problem(num+1)];
    a=[str,'.mat'];save(a,'result');
    a=[str,'para','.mat'];save(a,'expr'); 
end
toc;
