function[Xtrain Ytrain]=my_initial(Dat,Doe)
%���������������ʵ����Ʒ�����������Ϣ��Ƴ�ʼ������
switch func2str(Doe)
    
    case 'DOEOLHS'       %�����������������
        npoints=Dat.npoints;
        ndv=Dat.ndv;
        method= 'ESEA';
        LHS = DOEOLHS(npoints, ndv, method);
        LHS = ScaleVariable(LHS, [0 1]'*ones(1,Dat.ndv), Dat.designspace);
        Xtrain=LHS;
        Ytrain=feval(Dat.myFN, Xtrain);
        
    case 'DOETPLHS'       %ƽ���������������
        npoints=Dat.npoints;
        ndv=Dat.ndv;
        LHS =DOETPLHS(nPoints, ndv);
        LHS = ScaleVariable(LHS , [0 1]'*ones(1,Dat.ndv), Dat.designspace);
        Xtrain=LHS;
        Ytrain=feval(Dat.myFN, Xtrain);
    case 'DOELHS'       %�������������
        npoints=Dat.npoints;
        ndv=Dat.ndv;
        LHS =DOELHS(npoints, ndv,5);
        LHS = ScaleVariable(LHS , [0 1]'*ones(1,Dat.ndv), Dat.designspace);
        Xtrain=LHS;
        Ytrain=feval(Dat.myFN, Xtrain);
        
end


        
