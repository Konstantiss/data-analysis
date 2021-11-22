clc
clear

X = rand(10,1)

%First question:
figure(1)
bootstatX = bootstrp(1000,@mean,X);
histogram(bootstatX,50)
hold on
grid on
xline(mean(X),'-r','LineWidth',5)
hold off

%Second question:
std(bootstatX)
std(X)

%Third question:
Y = exp(X);
bootstatY = bootstrp(1000,@mean,Y);

figure(2)
histogram(bootstatY,50)
hold on
grid on
xline(mean(Y),'-r','LineWidth',5)
hold off
std(bootstatY)
std(Y)
