clc
clear

X = rand(10,1)

%First question:
bootstatX = bootstrp(1000,@mean,X);
histogram(bootstat,50)
hold on
grid on
histogram(X,50)
hold off

%Second question:
std(bootstatX)
std(X)

%Third question:
Y = exp(X);
bootstatY = bootstrp(1000,@mean,Y);
histogram(bootstat,50)
hold on
grid on
histogram(Y,50)
hold off
std(bootstatY)
std(Y)
