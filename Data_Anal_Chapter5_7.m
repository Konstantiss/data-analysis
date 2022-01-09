clc;
clear;

data = [1 0.76 110; 2 0.86 105; 3 0.97 100; 4 1.11 95; 5 1.45 85; 6 1.67 80; 7 1.92 75 ...
; 8 2.23 70 ;9 2.59 65; 10 3.02 60; 11 3.54 55; 12 4.16 50; 13 4.91 45; 14 5.83 40; 15 6.94 35 ...
; 16 8.31 30; 17 10.00 25; 18 12.09 20; 19 14.68 15; 20 17.96 10; 21 22.05 5; 22 27.28 0 ;23 33.89 -5 ...
; 24 42.45 -10; 25 53.39 -15; 26 67.74 -20; 27 86.39 -25; 28 111.30 -30; 29 144.00 -35; 30 188.40 -40 ...
; 31 247.50 -45; 32 329.20 -50];

k = 5;
R2 = zeros(k+1,1);
adjustedR2 = zeros(k+1,1);
maxAdjR2 = zeros(2,1);

resistance = data(:,2);
temperature = data(:,3) + 273.15;

X = log(resistance);
Y = 1./temperature;

% A

% Functions
r2 = @(ypred,y) 1-sum((ypred-y).^2)/sum((y-mean(y)).^2);
adjR2 = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2) );
rmse = @(residuals, n, dof) ( sqrt( 1/(n-dof) * sum(residuals.^2) ));

for i=1:5
    b = polyfit(X,Y,i);
    yPrediction = polyval(b,X);
    
    R2(i) = r2(yPrediction, Y);
    adjustedR2(i) = adjR2(yPrediction, Y, length(Y), i);
    if(adjustedR2(i) > maxAdjR2(1))
        maxAdjR2(1) = adjustedR2(i);
        maxAdjR2(2) = i;
    end
    
    %Plot data and regression
    figure();
    scatter(X,Y);
    hold on;
    plot(X,yPrediction);
    title("data and regression, k = "+ i);
    
    %diagnostic plot
    residuals = Y - yPrediction;
    se = sqrt( 1/(length(X)-k-1) * (sum(residuals.^2)));
    figure();
    scatter(Y,residuals./se);
    hold on;
    yline(2, 'r');
    yline(0, 'g');
    yline(-2, 'b');
    title("Diagnostic plot, k = " + i);
    xlabel("1/T");
    ylabel("Standardised Error");
end