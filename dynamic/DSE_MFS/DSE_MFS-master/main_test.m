% Generate training data 
r = 20;
fprintf('Learning the function x^2 + y^2 < 1\n');
[XX,YY] = meshgrid(-1:1/r:1,-1:1/r:1);
X = [XX(:) YY(:)];
Y = 2*(sqrt(X(:,1).^2 + X(:,2).^2) < 1)-1 ;

Pin = find(Y==1);
X1 = X(Pin,:);
Y1 = Y(Pin);

% Plot training data
figure;hold on;
set(gca,'FontSize',16);    
for i = 1:length(Y1)
    if(Y1(i) > 0)
        plot(X1(i,1),X1(i,2),'g.');
    else
        plot(X1(i,1),X1(i,2),'r.');
    end
end

% Draw the decision boundary
theta = linspace(0,2*pi,100);
plot(cos(theta),sin(theta),'k-');
xlabel('x');
ylabel('y')
title(sprintf('Training data (%i points)',length(Y))); 
axis equal tight; box on;


%%train one class SVM with 10% instances to be set as outlier
model = svmtrain(Y1,X1,'-s 2 -n 0.001');
[Y1,Y2,Y3] = svmpredict(Y,X,model);

for i = 1:length(Y)
    if(Y1(i) > 0)
        plot(X(i,1),X(i,2),'g.');
    else
        plot(X(i,1),X(i,2),'r.');
    end
end

X21 = rand(100,1);
X22 = 1-X21;
X2 = [X21 X22];
Y2 = ones(100,1);
% X = [X;X2];
% Y = [Y;Y2];
[Y1,Y2,Y3] = svmpredict(Y2,X2,model);

for i = 1:length(Y1)
    if(Y1(i) > 0)
        plot(X2(i,1),X2(i,2),'g.');
    else
        plot(X2(i,1),X2(i,2),'r.');
    end
end