% -------------------------Rastrigin FUNCTION
function [y] = Rastrigin(x)
    [ps,D]=size(x);
    y=sum(x.^2-10.*cos(2.*pi.*x)+10,2);
    y= y';
end