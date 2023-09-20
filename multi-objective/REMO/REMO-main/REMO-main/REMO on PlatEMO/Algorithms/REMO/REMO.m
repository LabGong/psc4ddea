function REMO(Global)
% <algorithm> <R>


    %% Parameterr setting
    [k,gmax] = Global.ParameterSet(6,3000);
    
    %% Initalize the population by Latin hypercube sampling
    if Global.D <= 10
        N          = 11*Global.D-1;
    else
        N = 100;
    end
    PopDec     = lhsamp(N,Global.D);
    Population = INDIVIDUAL(repmat(Global.upper-Global.lower,N,1).*PopDec+repmat(Global.lower,N,1));
    Arc        = Population;
    
    %% Optimization
	while Global.NotTermination(Arc)
        % Select reference solutions and preprocess the data
        Ref    = RefSelect(Population,k);
        Input  = Population.decs; 
        
        Catalog = GetOutput_PBI(Population.objs,Ref.objs); 
        [XXs,YYs] = GetRelationPairs(Input,Catalog);

        

        [TrainIn,TrainOut,TestIn,TestOut] = DataProcess(XXs,YYs);
        
        xDim = size(TrainIn,2);
        % Train relation model
        
        [TrainIn_nor,TrainIn_struct] = mapminmax(TrainIn');
        TrainIn_nor = TrainIn_nor';
        TrainOut_onehot = onehotconv(TrainOut,1);
        
        net = patternnet([ceil(xDim*1.5),xDim*1,ceil(xDim/2)]);
        net.trainParam.showWindow =0;

        net = train(net,TrainIn_nor',TrainOut_onehot');

               
        TestIn_nor = mapminmax('apply',TestIn',TrainIn_struct)';
        TestPre = onehotconv(net(TestIn_nor')',2);             
        p_err = sum(TestPre ~= TestOut)/size(TestPre,1);
        
        Smodel.X = Input;
        Smodel.Y = Catalog;
        Smodel.mp_struct = TrainIn_struct;
        Smodel.net = net;
        Smodel.p_err = p_err;
        
        Next = RSurrogateAssistedSelection(Ref,Population.decs,gmax,Smodel);
           
        if ~isempty(Next)
            Arc = [Arc,INDIVIDUAL(Next)];
        end
        Population = RefSelect(Arc,Global.N);
	end
end
