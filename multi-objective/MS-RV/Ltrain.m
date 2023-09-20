function [CLModel,CLdata,partition] = Ltrain(TX,TY,univec,CK,Lnum)

[N,M] = size(TY);
D = size(TX,2);


partition = F_partition(TY,TX, univec,Lnum); %population partition



THETA = 5.*ones(M,D);
for k = 1:CK      %收敛性local模型
    select = partition(k).c;
    if(~isempty(select))
        Lsampx = TX(select,:);
        Lsampy = TY(select,:);
        [~,uind] = unique(Lsampx,'rows');
        Lsampx = Lsampx(uind,:);
        Lsampy = Lsampy(uind,:);
            for m = 1:M
%                 PRmodel=POLY(Lsampx,Lsampy(:,m),'quad');
                GPmodel     = dacefit(Lsampx,Lsampy(:,m),'regpoly0','corrgauss',THETA(m,:),1e-5.*ones(1,D),100.*ones(1,D));
                THETA(m,:) = GPmodel.theta;
%                [RBFmodel, time] = rbfbuild(Lsampx,Lsampy(:,m), 'G');
                CLModel{k,m}   = GPmodel;
            end
            CLdata{k} = Lsampx;

    end
end
end