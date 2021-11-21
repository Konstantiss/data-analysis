clc
clear

X = rand(10,100);
stdCisX = zeros(10,2);

%First question:

for i=1:1:10
    [h,p,ci,stats] = vartest(X(i,:), 10);
    stdCisX(i,:) = sqrt(ci);
end
ciBootX = bootci(100,@std,X);

figure(1)
histogram(stdCisX)
hold on 
histogram(ciBootX)
hold off

%Second question:
Y = X.^2;
for i=1:1:10
    [h,p,ci,stats] = vartest(Y(i,:), 10);
    stdCisY(i,:) = sqrt(ci);
end

ciBootY = bootci(100,@std,Y);