clc
clear
n = 10;
m = 100;
X = normrnd(0,1,n,m);

%First question:

for i=1:m
    [h,p,ci,stats] = vartest(X(:,i), n);
    stdCisX(:,i) = ci;
end

stdCisX = sqrt(stdCisX);
ciBootX = bootci(m,@std,X);

figure(1)
histogram(stdCisX,50)
hold on
grid on
histogram(ciBootX,50)
hold off

%Second question:
Y = X.^2;
for i=1:m
    [h,p,ci,stats] = vartest(Y(:,i), n);
    stdCisY(:,i) = sqrt(ci);
end

ciBootY = bootci(m,@std,Y);

figure(2)
histogram(stdCisY,50)
hold on
grid on
histogram(ciBootY,50)
hold off
