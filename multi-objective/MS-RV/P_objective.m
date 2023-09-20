function [population,maxvalue,minvalue] = P_objective(operation,KIND,parameter1,M,K)
% ■P_objective 返回对于多目标测试函数的相关操作所产生的结果
%               DTLZ1~7是常用的可扩展多目标优化测试函数集
%               WFG1~9是更难的可扩展多目标优化测试函数集
%
% 输入:
%       ■operation:  字符串.用来指定操作的类型,其取值如下:
%                     1.'init',产生指定大小的初始种群
%                     2.'value',计算种群的目标函数值
%                     3.'true',产生指定大小的真实种群
%       ■KIND:       字符串.指定要采用的DTLZ函数,其取值如下:
%                     1.'DTLZ1',采用DTLZ1函数进行计算
%                     2.'DTLZ2',采用DTLZ2函数进行计算
%                     3.'DTLZ3',采用DTLZ3函数进行计算
%                     4.'DTLZ4',采用DTLZ4函数进行计算
%                     5.'DTLZ5',采用DTLZ5函数进行计算
%                     6.'DTLZ6',采用DTLZ6函数进行计算
%                     7.'DTLZ7',采用DTLZ7函数进行计算
%                     8.'WFG1',采用WFG1函数进行计算
%                     9.'WFG2',采用WFG2函数进行计算
%                     10.'WFG3',采用WFG3函数进行计算
%                     11.'WFG4',采用WFG4函数进行计算
%                     12.'WFG5',采用WFG5函数进行计算
%                     13.'WFG6',采用WFG6函数进行计算
%                     14.'WFG7',采用WFG7函数进行计算
%                     15.'WFG8',采用WFG8函数进行计算
%                     16.'WFG9',采用WFG9函数进行计算
%       ■parameter1: 数值或二维矩阵.含义如下:
%                     1.当operation取值为'init'时,为 要初始化的种群大小(数值)
%                     2.当operation取值为'value'时,为 要计算目标函数值的种群(二维矩阵),其中每一行对应一个个体,每一列对应一维决策变量
%                     3.当operation取值为'true'时,为 要产生的真实种群大小(数值).由于须保持均匀分布,最终产生的种群大小与设置值有偏差 
%       ■M:          数值.目标函数的维数
%       ■K:          数值或一维向量.目标函数的相关参数(集合)
%
% 输出: 
%       ■population: 二维矩阵.含义如下:
%                     1.当operation取值为'init'时,为 产生的初始种群,其中每一行对应一个个体,每一列对应一维决策变量
%                     2.当operation取值为'value'时,为 计算出的目标函数值,其中每一行对应一个个体,每一列对应一维目标函数值
%                     3.当operation取值为'true'时,为 产生的真实种群,其中每一行对应一个个体,每一列对应一维决策变量
%       ■maxvalue:   一维向量.决策变量的取值上界,其中每一位对应一维决策变量的上界.仅在operation取值为'init'时有效
%       ■minvalue:   一维向量.决策变量的取值下界,其中每一位对应一维决策变量的下界.仅在operation取值为'init'时有效

    if strcmp(KIND(1:end-1),'DTLZ')
        switch operation
            case 'init'
                [population,maxvalue,minvalue]=P_DTLZ(operation,KIND,parameter1,M,K(1));
            otherwise
                population=P_DTLZ(operation,KIND,parameter1,M,K(1));
        end
    elseif strcmp(KIND(1:end-1),'WFG')
        switch operation
            case 'init'
                [population,maxvalue,minvalue]=P_WFG(operation,KIND,parameter1,M,K(1),K(2));
            otherwise
                population=P_WFG(operation,KIND,parameter1,M,K(1),K(2));
        end
    end
end

function [population,maxvalue,minvalue] = P_DTLZ(operation,KIND,parameter1,M,K)
% ■P_DEBDK 返回对于测试函数DTLZ的相关操作所产生的结果
%           DTLZ1~7是常用的可扩展多目标优化测试函数集
%           支持任意维的DTLZ1~7测试函数
%
% 输入:
%       ■operation:  字符串.用来指定操作的类型,其取值如下:
%                     1.'init',产生指定大小的初始种群
%                     2.'value',计算种群的目标函数值
%                     3.'true',产生指定大小的真实种群
%       ■KIND:       字符串.指定要采用的DTLZ函数,其取值如下:
%                     1.'DTLZ1',采用DTLZ1函数进行计算
%                     2.'DTLZ2',采用DTLZ2函数进行计算
%                     3.'DTLZ3',采用DTLZ3函数进行计算
%                     4.'DTLZ4',采用DTLZ4函数进行计算
%                     5.'DTLZ5',采用DTLZ5函数进行计算
%                     6.'DTLZ6',采用DTLZ6函数进行计算
%                     7.'DTLZ7',采用DTLZ7函数进行计算
%       ■parameter1: 数值或二维矩阵.含义如下:
%                     1.当operation取值为'init'时,为 要初始化的种群大小(数值)
%                     2.当operation取值为'value'时,为 要计算目标函数值的种群(二维矩阵),其中每一行对应一个个体,每一列对应一维决策变量
%                     3.当operation取值为'true'时,为 要产生的真实种群大小(数值).由于须保持均匀分布,最终产生的种群大小与设置值有偏差 
%       ■M:          数值.目标函数的维数
%       ■K:          数值.目标函数的相关参数
%
% 输出: 
%       ■population: 二维矩阵.含义如下:
%                     1.当operation取值为'init'时,为 产生的初始种群,其中每一行对应一个个体,每一列对应一维决策变量
%                     2.当operation取值为'value'时,为 计算出的目标函数值,其中每一行对应一个个体,每一列对应一维目标函数值
%                     3.当operation取值为'true'时,为 产生的真实种群,其中每一行对应一个个体,每一列对应一维决策变量
%       ■maxvalue:   一维向量.决策变量的取值上界,其中每一位对应一维决策变量的上界.仅在operation取值为'init'时有效
%       ■minvalue:   一维向量.决策变量的取值下界,其中每一位对应一维决策变量的下界.仅在operation取值为'init'时有效

    switch operation
        %产生初始种群
        case 'init'
            poplength=M+K-1;
            population=rand(parameter1,poplength);
            maxvalue=ones(1,poplength);
            minvalue=zeros(1,poplength);
        %计算目标函数值
        case 'value'
            population=parameter1;
            functionvalue=zeros(size(population,1),M);
            switch KIND
                %DTLZ1问题
                case 'DTLZ1'
                    g=100*(K+sum((population(:,M:end)-0.5).^2-cos(20.*pi.*(population(:,M:end)-0.5)),2));
                    for i=1:M
                        functionvalue(:,i)=0.5.*prod(population(:,1:M-i),2).*(1+g);
                        if i>1
                            functionvalue(:,i)=functionvalue(:,i).*(1-population(:,M-i+1));
                        end
                    end
                %DTLZ2问题
                case 'DTLZ2'
                    g=sum((population(:,M:end)-0.5).^2,2);
                    for i=1:M
                        functionvalue(:,i)=(1+g).*prod(cos(0.5.*pi.*population(:,1:M-i)),2);
                        if i>1
                            functionvalue(:,i)=functionvalue(:,i).*sin(0.5.*pi.*population(:,M-i+1));
                        end
                    end
                %DTLZ3问题
                case 'DTLZ3'
                    g=100*(K+sum((population(:,M:end)-0.5).^2-cos(20.*pi.*(population(:,M:end)-0.5)),2));
                    for i=1:M
                        functionvalue(:,i)=(1+g).*prod(cos(0.5.*pi.*population(:,1:M-i)),2);
                        if i>1
                            functionvalue(:,i)=functionvalue(:,i).*sin(0.5.*pi.*population(:,M-i+1));
                        end
                    end
                %DTLZ4问题
                case 'DTLZ4'
                    population(:,1:M-1)=population(:,1:M-1).^100;
                    g=sum((population(:,M:end)-0.5).^2,2);
                    for i=1:M
                        functionvalue(:,i)=(1+g).*prod(cos(0.5.*pi.*population(:,1:M-i)),2);
                        if i>1
                            functionvalue(:,i)=functionvalue(:,i).*sin(0.5.*pi.*population(:,M-i+1));
                        end
                    end
                %DTLZ5问题
                case 'DTLZ5'
                    g=sum((population(:,M:end)-0.5).^2,2);
                    temp=repmat(g,1,M-2);
                    population(:,2:M-1)=(1+2*temp.*population(:,2:M-1))./(2+2*temp);
                    for i=1:M
                        functionvalue(:,i)=(1+g).*prod(cos(0.5.*pi.*population(:,1:M-i)),2);
                        if i>1
                            functionvalue(:,i)=functionvalue(:,i).*sin(0.5.*pi.*population(:,M-i+1));
                        end
                    end
                %DTLZ6问题
                case 'DTLZ6'
                    g=sum(population(:,M:end).^0.1,2);
                    temp=repmat(g,1,M-2);
                    population(:,2:M-1)=(1+2*temp.*population(:,2:M-1))./(2+2*temp);
                    for i=1:M
                        functionvalue(:,i)=(1+g).*prod(cos(0.5.*pi.*population(:,1:M-i)),2);
                        if i>1
                            functionvalue(:,i)=functionvalue(:,i).*sin(0.5.*pi.*population(:,M-i+1));
                        end
                    end
                %DTLZ7问题
                case 'DTLZ7'
                    g=1+9*mean(population(:,M:end),2);
                    functionvalue(:,1:M-1)=population(:,1:M-1);
                    temp=repmat(g,1,M-1);
                    h=M-sum(functionvalue(:,1:M-1)./(1+temp).*(1+sin(3*pi.*functionvalue(:,1:M-1))),2);
                    functionvalue(:,M)=(1+g).*h;
            end
            population=functionvalue;
        %产生真实种群
        case 'true'
            if strcmp(KIND,'DTLZ1')
                population=T_uniform(parameter1,M);
                population=population/2;
            elseif strcmp(KIND,'DTLZ2') || strcmp(KIND,'DTLZ3') || strcmp(KIND,'DTLZ4')
                population=T_uniform(parameter1,M);
                for i=1:size(population,1)
                    k=find(population(i,:)~=0,1);
                    temp=population(i,[1:k-1,k+1:end])./population(i,k);
                    population(i,k)=sqrt(1/(sum(temp.^2)+1));
                    population(i,[1:k-1,k+1:end])=temp*population(i,k);
                end
            elseif strcmp(KIND,'DTLZ5') || strcmp(KIND,'DTLZ6')
                temp=[0:1/(parameter1-1):1]';
                population=zeros(size(temp,1),M);
                population(:,1:M-1)=repmat(cos(0.5.*pi.*temp),1,M-1);
                population(:,M)=sin(0.5.*pi.*temp);
                population(:,1)=population(:,1)/sqrt(2)^(M-2);
                population(:,2:M)=population(:,2:M)./sqrt(2).^repmat(M-2:-1:0,size(temp,1),1);
            elseif strcmp(KIND,'DTLZ7')
                temp=T_repeat(parameter1,M-1);
                population=zeros(size(temp,1),M);
                population(:,1:M-1)=temp;
                population(:,M)=2*(M-sum(population(:,1:M-1).*(1+sin(3*pi.*population(:,1:M-1))),2));
                population=population(T_sort(population),:);
            end
    end
end

function [population,maxvalue,minvalue] = P_WFG(operation,KIND,parameter1,M,K,L)
% ■P_WFG 返回对于测试函数WFG的相关操作所产生的结果
%         WFG1~9是较难的可扩展多目标优化测试函数集
%
% 输入:
%       ■operation:  字符串.用来指定操作的类型,其取值如下:
%                     1.'init',产生指定大小的初始种群
%                     2.'value',计算种群的目标函数值
%                     3.'true',产生指定大小的真实种群
%       ■KIND:       字符串.指定要采用的WFG函数,其取值如下:
%                     1.'WFG1',采用WFG1函数进行计算
%                     2.'WFG2',采用WFG2函数进行计算
%                     3.'WFG3',采用WFG3函数进行计算
%                     4.'WFG4',采用WFG4函数进行计算
%                     5.'WFG5',采用WFG5函数进行计算
%                     6.'WFG6',采用WFG6函数进行计算
%                     7.'WFG7',采用WFG7函数进行计算
%                     8.'WFG8',采用WFG8函数进行计算
%                     9.'WFG9',采用WFG9函数进行计算
%       ■parameter1: 数值或二维矩阵.含义如下:
%                     1.当operation取值为'init'时,为 要初始化的种群大小(数值)
%                     2.当operation取值为'value'时,为 要计算目标函数值的种群(二维矩阵),其中每一行对应一个个体,每一列对应一维决策变量
%                     3.当operation取值为'true'时,为 要产生的真实种群大小(数值).由于须保持均匀分布,最终产生的种群大小与设置值有偏差 
%       ■M:          数值.目标函数的维数
%       ■K:          数值.目标函数的位置参数
%       ■L:          数值.目标函数的距离参数
%
% 输出: 
%       ■population: 二维矩阵.含义如下:
%                     1.当operation取值为'init'时,为 产生的初始种群,其中每一行对应一个个体,每一列对应一维决策变量
%                     2.当operation取值为'value'时,为 计算出的目标函数值,其中每一行对应一个个体,每一列对应一维目标函数值
%                     3.当operation取值为'true'时,为 产生的真实种群,其中每一行对应一个个体,每一列对应一维决策变量
%       ■maxvalue:   一维向量.决策变量的取值上界,其中每一位对应一维决策变量的上界.仅在operation取值为'init'时有效
%       ■minvalue:   一维向量.决策变量的取值下界,其中每一位对应一维决策变量的下界.仅在operation取值为'init'时有效

    switch operation
        %产生初始种群
        case 'init'
            poplength=K+L;
            maxvalue=[1:poplength]*2;
            minvalue=zeros(1,poplength);
            population=rand(parameter1,poplength).*repmat(maxvalue,parameter1,1);
        %计算目标函数值
        case 'value'
            population=parameter1;
            N=size(population,1);
            D=1;
            S=repmat([1:M]*2,N,1);
            if strcmp(KIND,'WFG3')
                A=[ones(N,1),zeros(N,M-2)];
            else
                A=ones(N,M-1);
            end
            z01=population./repmat([1:size(population,2)]*2,N,1);
            switch KIND
                %WFG1问题
                case 'WFG1'                    
                    t1=zeros(N,K+L);
                    t1(:,1:K)=z01(:,1:K);
                    t1(:,K+1:end)=s_linear(z01(:,K+1:end),0.35);

                    t2=zeros(N,K+L);
                    t2(:,1:K)=t1(:,1:K);
                    t2(:,K+1:end)=b_flat(t1(:,K+1:end),0.8,0.75,0.85);

                    t3=zeros(N,K+L);
                    t3=b_poly(t2,0.02);

                    t4=zeros(N,M);
                    for i=1:M-1
                        t4(:,i)=r_sum(t3(:,(i-1)*K/(M-1)+1:i*K/(M-1)),2*((i-1)*K/(M-1)+1):2:2*i*K/(M-1));
                    end
                    t4(:,M)=r_sum(t3(:,K+1:K+L),2*(K+1):2:2*(K+L));

                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t4(:,M),A(:,i)).*(t4(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t4(:,M);
                    
                    h=convex(x);
                    h(:,M)=mixed(x);
                %WFG2问题
                case 'WFG2'                    
                    t1=zeros(N,K+L);
                    t1(:,1:K)=z01(:,1:K);
                    t1(:,K+1:end)=s_linear(z01(:,K+1:end),0.35);
                    
                    t2=zeros(N,K+L/2);
                    t2(:,1:K)=t1(:,1:K);
                    for i=K+1:K+L/2
                        t2(:,i)=r_nonsep(t1(:,K+2*(i-K)-1:K+2*(i-K)),2);
                    end
                    
                    t3=zeros(N,M);
                    for i=1:M-1
                        t3(:,i)=r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M)=r_sum(t2(:,K+1:K+L/2),ones(1,L/2));
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t3(:,M);
                    
                    h=convex(x);
                    h(:,M)=disc(x);
                %WFG3问题
                case 'WFG3'
                    t1=zeros(N,K+L);
                    t1(:,1:K)=z01(:,1:K);
                    t1(:,K+1:end)=s_linear(z01(:,K+1:end),0.35);
                    
                    t2=zeros(N,K+L/2);
                    t2(:,1:K)=t1(:,1:K);
                    for i=K+1:K+L/2
                        t2(:,i)=r_nonsep(t1(:,K+2*(i-K)-1:K+2*(i-K)),2);
                    end
                    
                    t3=zeros(N,M);
                    for i=1:M-1
                        t3(:,i)=r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M)=r_sum(t2(:,K+1:K+L/2),ones(1,L/2));
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t3(:,M);
                    
                    h=linear(x);
                %WFG4问题
                case 'WFG4'
                    t1=zeros(N,K+L);
                    t1=s_multi(z01,30,10,0.35);

                    t2=zeros(N,M);
                    for i=1:M-1
                        t2(:,i)=r_sum(t1(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t2(:,M)=r_sum(t1(:,K+1:K+L),ones(1,L));
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t2(:,M),A(:,i)).*(t2(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t2(:,M);
                    
                    h=concave(x);
                %WFG5问题
                case 'WFG5'
                    t1=zeros(N,K+L);
                    t1=s_decept(z01,0.35,0.001,0.05);
                    
                    t2=zeros(N,M);
                    for i=1:M-1
                        t2(:,i)=r_sum(t1(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t2(:,M)=r_sum(t1(:,K+1:K+L),ones(1,L));
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t2(:,M),A(:,i)).*(t2(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t2(:,M);
                    
                    h=concave(x);
                %WFG6问题
                case 'WFG6'
                    t1=zeros(N,K+L);
                    t1(:,1:K)=z01(:,1:K);
                    t1(:,K+1:end)=s_linear(z01(:,K+1:end),0.35);
                    
                    t2=zeros(N,M);
                    for i=1:M-1
                        t2(:,i)=r_nonsep(t1(:,(i-1)*K/(M-1)+1:i*K/(M-1)),K/(M-1));
                    end
                    t2(:,M)=r_nonsep(t1(:,K+1:end),L);
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t2(:,M),A(:,i)).*(t2(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t2(:,M);
                    
                    h=concave(x);                    
                %WFG7问题
                case 'WFG7'
                    t1=zeros(N,K+L);
                    for i=1:K
                        t1(:,i)=b_param(z01(:,i),r_sum(z01(:,i+1:end),ones(1,K+L-i)),0.98/49.98,0.02,50);
                    end
                    t1(:,K+1:end)=z01(:,K+1:end);
                    
                    t2=zeros(N,K+L);
                    t2(:,1:K)=t1(:,1:K);
                    t2(:,K+1:end)=s_linear(t1(:,K+1:end),0.35);
                    
                    t3=zeros(N,M);
                    for i=1:M-1
                        t3(:,i)=r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M)=r_sum(t2(:,K+1:K+L),ones(1,L));
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t3(:,M);
                    
                    h=concave(x);
                %WFG8问题
                case 'WFG8'
                    t1=zeros(N,K+L);
                    t1(:,1:K)=z01(:,1:K);
                    for i=K+1:K+L
                        t1(:,i)=b_param(z01(:,i),r_sum(z01(:,1:i-1),ones(1,i-1)),0.98/49.98,0.02,50);
                    end
                    
                    t2=zeros(N,K+L);
                    t2(:,1:K)=t1(:,1:K);
                    t2(:,K+1:end)=s_linear(t1(:,K+1:end),0.35);
                    
                    t3=zeros(N,M);
                    for i=1:M-1
                        t3(:,i)=r_sum(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),ones(1,K/(M-1)));
                    end
                    t3(:,M)=r_sum(t2(:,K+1:K+L),ones(1,L));
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t3(:,M);
                    
                    h=concave(x);
                %WFG9问题
                case 'WFG9'
                    t1=zeros(N,K+L);
                    for i=1:K+L-1
                        t1(:,i)=b_param(z01(:,i),r_sum(z01(:,i+1:end),ones(1,K+L-i)),0.98/49.98,0.02,50);
                    end
                    t1(:,end)=z01(:,end);
                    
                    t2=zeros(N,K+L);
                    t2(:,1:K)=s_decept(t1(:,1:K),0.35,0.001,0.05);
                    t2(:,K+1:end)=s_multi(t1(:,K+1:end),30,95,0.35);
                    
                    t3=zeros(N,M);
                    for i=1:M-1
                        t3(:,i)=r_nonsep(t2(:,(i-1)*K/(M-1)+1:i*K/(M-1)),K/(M-1));
                    end
                    t3(:,M)=r_nonsep(t2(:,K+1:end),L);
                    
                    x=zeros(N,M);
                    for i=1:M-1
                        x(:,i)=max(t3(:,M),A(:,i)).*(t3(:,i)-0.5)+0.5;
                    end
                    x(:,M)=t3(:,M);
                    
                    h=concave(x);
            end
            population=repmat(D*x(:,M),1,M)+S.*h;
        %产生真实种群
        case 'true'
            if strcmp(KIND,'WFG1') || strcmp(KIND,'WFG2')
                h=T_uniform(parameter1,M);
                for i=1:size(h,1)
                    c=ones(1,M-1);
                    k=find(h(i,:)~=0,1);
                    for j=k+1:M
                        temp=h(i,j)/h(i,k)*prod(1-c(M-j+2:M-k));
                        if k>1
                            temp=temp*(1-sqrt(1-c(M-k+1)^2));
                        end
                        c(M+1-j)=(temp^2-temp+sqrt(2*temp))/(temp^2+1);
                    end
                    for j=1:M
                        h(i,j)=prod(1-c(1:M-j));
                        if j>1
                            h(i,j)=h(i,j).*(1-sqrt(1-c(M-j+1)^2));
                        end
                    end
                    temp=acos(c(1))*2/pi;
                    if strcmp(KIND,'WFG1')                      
                        h(i,M)=1-temp-cos(10*pi*temp+pi/2)/10/pi;
                    else
                        h(i,M)=1-temp.*(cos(5*pi*temp)).^2;
                    end
                end
                if strcmp(KIND,'WFG2')
                    h=h(T_sort(h),:);
                end
            elseif strcmp(KIND,'WFG3')
                population=[0:1/(parameter1-1):1]';
                population=[population,zeros(size(population,1),M-2)+0.5];
                population=[population,zeros(size(population,1),1)];
                h=linear(population);
            else
                h=T_uniform(parameter1,M);
                for i=1:size(h,1)
                    k=find(h(i,:)~=0,1);
                    temp=h(i,[1:k-1,k+1:end])./h(i,k);
                    h(i,k)=sqrt(1/(sum(temp.^2)+1));
                    h(i,[1:k-1,k+1:end])=temp*h(i,k);
                end
            end           
            population=repmat([1:M]*2,size(h,1),1).*h;
    end
end

%用于计算WFG函数值的变换函数
function output = b_poly(y,a)
    output=y.^a;
end

function output = b_flat(y,A,B,C)
    output=A+min(0,floor(y-B))*A.*(B-y)/B-min(0,floor(C-y))*(1-A).*(y-C)/(1-C);
    output=roundn(output,-10);
end

function output = b_param(y,Y,A,B,C)
    output=y.^(B+(C-B)*(A-(1-2*Y).*abs(floor(0.5-Y)+A)));
end

function output = s_linear(y,A)
    output=abs(y-A)./abs(floor(A-y)+A);
end

function output = s_decept(y,A,B,C)
    output=1+(abs(y-A)-B).*(floor(y-A+B)*(1-C+(A-B)/B)/(A-B)+floor(A+B-y)*(1-C+(1-A-B)/B)/(1-A-B)+1/B);
end

function output = s_multi(y,A,B,C)
    output=(1+cos((4*A+2)*pi*(0.5-abs(y-C)/2./(floor(C-y)+C)))+4*B*(abs(y-C)/2./(floor(C-y)+C)).^2)/(B+2);
end

function output = r_sum(y,w)
    output=sum(y.*repmat(w,size(y,1),1),2)./sum(w);
end

function output = r_nonsep(y,A)
    output=zeros(size(y,1),1);
    for j=1:size(y,2)
        temp=zeros(size(y,1),1);
        for k=0:A-2
            temp=temp+abs(y(:,j)-y(:,1+mod(j+k,size(y,2))));
        end
        output=output+y(:,j)+temp;
    end
    output=output./(size(y,2)/A)/ceil(A/2)/(1+2*A-2*ceil(A/2));
end

%用于计算WFG函数值的形状函数
function output = linear(x)
    output=zeros(size(x));
    for i=1:size(x,2)
        output(:,i)=prod(x(:,1:size(x,2)-i),2);
        if i>1
            output(:,i)=output(:,i).*(1-x(:,size(x,2)-i+1));
        end
    end
end

function output = convex(x)
    output=zeros(size(x));
    for i=1:size(x,2)
        output(:,i)=prod(1-cos(x(:,1:end-i)*pi/2),2);
        if i>1
            output(:,i)=output(:,i).*(1-sin(x(:,size(x,2)-i+1)*pi/2));
        end
    end
end

function output = concave(x)
    output=zeros(size(x));
    for i=1:size(x,2)
        output(:,i)=prod(sin(x(:,1:end-i)*pi/2),2);
        if i>1
            output(:,i)=output(:,i).*(cos(x(:,size(x,2)-i+1)*pi/2));
        end
    end
end

function output = mixed(x)
    output=1-x(:,1)-cos(10*pi*x(:,1)+pi/2)/10/pi;
end

function output = disc(x)
    output=1-x(:,1).*(cos(5*pi*x(:,1))).^2;
end

%用于产生真实前沿面的辅助函数
function W = T_uniform(k,M)
%产生(约)k个M维的均匀分布向量,每个向量各维之和恒为1
    H=floor((k*prod(1:M-1))^(1/(M-1)));
    while nchoosek(H+M-1,M-1)>=k && H>0
        H=H-1;
    end
    if nchoosek(H+M,M-1)<=2*k || H==0
        H=H+1;
    end
    k=nchoosek(H+M-1,M-1);
    temp=nchoosek(1:H+M-1,M-1)-repmat(0:M-2,nchoosek(H+M-1,M-1),1)-1;
    W=zeros(k,M);
    W(:,1)=temp(:,1)-0;
    for i=2:M-1
        W(:,i)=temp(:,i)-temp(:,i-1);
    end
    W(:,end)=H-temp(:,end);
    W=W/H;
end

function W = T_repeat(k,M)
%产生(约)k个M维的向量,向量的每维取值范围为[0,1],每一种组合对应一个向量
    if M>1
        k=(ceil(k^(1/M)))^M;
        temp=0:1/(k^(1/M)-1):1;
        code='[c1';
        for i=2:M
            code=[code,',c',num2str(i)];
        end
        code=[code,']=ndgrid(temp);'];
        eval(code);
        code='W=[c1(:)';
        for i=2:M
            code=[code,',c',num2str(i),'(:)'];
        end
        code=[code,'];'];
        eval(code);
    else
        W=[0:1/(k-1):1]';
    end
end

function choose = T_sort(functionvalue)
%选出种群中的所有非支配个体
    N=size(functionvalue,1);
    choose=true(1,N);
    [~,rank]=sortrows(functionvalue);
    for i=1:N-1
        for j=i+1:N
            if choose(rank(j))
                k=true;
                for m=2:size(functionvalue,2)
                    if functionvalue(rank(i),m)>functionvalue(rank(j),m)
                        k=false;
                        break;
                    end
                end
                if k
                    choose(rank(j))=false;
                end
            end
        end
    end
end