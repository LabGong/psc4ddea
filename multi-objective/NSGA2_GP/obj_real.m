function f = obj_real(x,Problem)
    
    global M V
    switch Problem
        case {'DTLZ1'}   
            g = 100*(V+1-M+sum((x(:,M:end)-0.5).^2-cos(20.*pi.*(x(:,M:end)-0.5)),2));
            for i = 1 : M
                f(:,i) = 0.5.*prod(x(:,1:M-i),2).*(1+g);
                if i > 1
                    f(:,i) = f(:,i).*(1-x(:,M-i+1));
                end
            end       
                
        case {'DTLZ3'}   
            g = 100*(V+1-M+sum((x(:,M:end)-0.5).^2-cos(20.*pi.*(x(:,M:end)-0.5)),2));
            for i = 1 : M
                f(:,i) = (1+g).*prod(cos(0.5.*pi.*x(:,1:M-i)),2);
                if i > 1
                    f(:,i) = f(:,i).*sin(0.5.*pi.*x(:,M-i+1));
                end
            end           
            
        case {'DTLZ4'} 
            alpha=5;
            g = sum((x(:,M:end)-0.5).^2,2);
            for i = 1 : M
                f(:,i) = (1+g).*prod(cos(0.5.*pi.*(x(:,1:M-i).^alpha)),2);
                if i > 1
                    f(:,i) = f(:,i).*sin(0.5.*pi.*(x(:,M-i+1).^alpha));
                end
            end              
            
        case {'DTLZ5'}  
            g = sum((x(:,M:end)-0.5).^2,2);
            x(:,2:M-1)=0.5*(1+2*repmat(g,1,M-2).*x(:,2:M-1))./(repmat(g,1,M-2)+1);
            for i = 1 : M
                f(:,i) = (1+g).*prod(cos(0.5.*pi.*x(:,1:M-i)),2);
                if i > 1
                    f(:,i) = f(:,i).*sin(0.5.*pi.*x(:,M-i+1));
                end
            end    
            
        case {'ZDT6'}
            [m,n]=size(x);
            f(:,1) = 1-exp(-4*x(:,1)).*(sin(6*pi*x(:,1)).^6);
            summ = zeros(m,1);
            for i = 2 : n
                summ = summ + x(:,i);
            end
            g_x = 1 + 9*((summ)/(n-1)).^0.25;
            f(:,2) = g_x.*(1 - (f(:,1)./g_x).^2);   
            
        case {'ZDT3'}    
            f(:,1) = x(:,1);
            g_x = 1 +9*sum(x(:,2:end),2)/(size(x,2)-1);
            f(:,2) = g_x.*(1 - (x(:,1)./g_x).^0.5-x(:,1)./g_x.*sin(10*pi*x(:,1)));
            
        case {'ZDT4'}
            [m,n]=size(x);
            f(:,1) = x(:,1);
            summ = zeros(m,1);
            for i = 2 : n
                summ = summ + x(:,i).^2-10*cos(4*pi*x(:,i));
            end
            g_x = 1 +10*(n-1)+summ;
            f(:,2) = g_x.*(1 - (x(:,1)./g_x).^0.5);
            
        case {'WFG2'} 
            [N,V]=size(x);
            x=x./repmat(2*(1:V),N,1);
            k=4;l=2;
            %t1
            A=0.35;x(:,k+1:V)=abs(x(:,k+1:V)-A)./abs(floor(A-x(:,k+1:V))+A);
            %t2
            A=2;x(:,k+1)=(x(:,k+1)+abs(x(:,k+1)-x(:,k+2))+x(:,k+2)+abs(x(:,k+2)-x(:,k+1)))/3;
            xx=x(:,1:k+1); 
            %t3
            for i=1:M-1
                xxx(:,i)=(xx(:,2*i-1)+xx(:,2*i))/2;
            end
            xxx(:,M)=xx(:,k+1);

            alpha=1;belta=1;A=5;

            for j=1:M
                if j==1
                    h(:,j)=prod(1-cos(xxx(:,1:M-1)*pi/2),2);
                elseif j==M
                    h(:,j)=1-xxx(:,1).^alpha.*(cos(A*(xxx(:,1)).^belta*pi)).^2;
                else   
                    h(:,j)=prod(1-cos(xxx(:,1:M-j)*pi/2),2).*(1-sin(xxx(:,M-j+1)*pi/2));
                end
            end

            f=repmat(xxx(:,M),1,M)+h.*repmat(2*(1:M),N,1);
            
        case {'WFG3'} 
            [N,V]=size(x);
            x=x./repmat(2*(1:V),N,1);
            k=4;l=2;
            %t1
            A=0.35;x(:,k+1:V)=abs(x(:,k+1:V)-A)./abs(floor(A-x(:,k+1:V))+A);
            %t2
            A=2;x(:,k+1)=(x(:,k+1)+abs(x(:,k+1)-x(:,k+2))+x(:,k+2)+abs(x(:,k+2)-x(:,k+1)))/3;
            t2=x(:,1:k+1); 
            %t3
            for i=1:M-1
                t3(:,i)=(t2(:,2*i-1)+t2(:,2*i))/2;
            end
            t3(:,M)=t2(:,k+1);
            %x
            xx(:,1)=t3(:,1);
            for i=2:M-1
                xx(:,i)=t3(:,M).*(t3(:,i)-0.5)+0.5;
            end
            xx(:,M)=t3(:,M);
            
            for j=1:M
                h(:,j)=prod(xx(:,1:M-j),2);
                if j>1
                    h(:,j)=h(:,j).*(1-xx(:,M-j+1));
                end
            end

            f=repmat(xx(:,M),1,M)+h.*repmat(2*(1:M),N,1);   
            
        case {'WFG4'} 
            t=x;
            [N,V]=size(t);
            t=t./repmat(2*(1:V),N,1);
            k=4;l=2;A=30;B=10;C=0.35;
            %t1
            t1=(1+cos((4*A+2)*pi*(0.5-abs(t-C)./2./(floor(C-t)+C)))+...
                4*B*(abs(t-C)./2./(floor(C-t)+C)).^2)/(B+2);
            %t2
            for i=1:M-1
                x(:,i)=(t1(:,2*i-1)+t1(:,2*i))/2;
            end
            x(:,M)=mean(t1(:,k+1:end),2);
            
            for j=1:M
                h(:,j)=prod(sin(x(:,1:M-j)*pi/2),2);
                if j>1
                    h(:,j)=h(:,j).*cos(x(:,M-j+1)*pi/2);
                end
            end

            f=repmat(x(:,M),1,M)+h.*repmat(2*(1:M),N,1); 
            
        case {'WFG5'} 
            t=x;
            [N,V]=size(t);
            t=t./repmat(2*(1:V),N,1);
            k=4;l=2;A=0.35;B=0.001;C=0.05;
            %t1
            t1=1+(abs(t-A)-B).*(floor(t-A+B)*(1-C+(A-B)/B)/(A-B)+...
                floor(A+B-t)*(1-C+(1-A-B)/B)/(1-A-B)+1/B);
            %t2
            for i=1:M-1
                xx(:,i)=(t1(:,2*i-1)+t1(:,2*i))/2;
            end
            xx(:,M)=mean(t1(:,k+1:end),2);
            
            for j=1:M
                h(:,j)=prod(sin(xx(:,1:M-j)*pi/2),2);
                if j>1
                    h(:,j)=h(:,j).*cos(xx(:,M-j+1)*pi/2);
                end
            end

            f=repmat(xx(:,M),1,M)+h.*repmat(2*(1:M),N,1);
    end








