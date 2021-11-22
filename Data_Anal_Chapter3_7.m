clc
clear

X = rand(10,100);

%First question:
[hX,pX,ciX,statsX] = ttest(X);

ciBootX = bootci(100,@mean,X);

figure(1)
histogram(ciX,50)
hold on
grid on
histogram(ciBootX,50)
hold off

%Second question:
Y = X.^2;

[hY,pY,ciY,statsY] = ttest(Y);

ciBootY = bootci(100,@mean,Y);

figure(2)
histogram(ciY,50)
hold on
grid on
histogram(ciBootY,50)
hold off
