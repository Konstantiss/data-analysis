clc;
clear;

data = importdata("physical.txt");

X = data(:,2:end);
Y = data(:,1);

adjR2 = @(ypred,y,n,k) ( 1 - (n-1)/(n-1-k)*sum((ypred-y).^2)/sum((y-mean(y)).^2) );

regressionModel = fitlm(X,Y)
coefficients = table2array(regressionModel.Coefficients);
coefficients = coefficients(:,1);
rSquared(1) = regressionModel.Rsquared.Ordinary
adjustedRSquared(1) = regressionModel.Rsquared.Adjusted
rootMeanSquaredError(1) = regressionModel.RMSE

[b,se,pval,finalmodel,stats] = stepwisefit(X,Y);
b0 = stats.intercept;
b = [b0; b(finalmodel)];

yPrediction = [ones(length(X),1) X(:,finalmodel)]*b;
rmse(2) = stats.rmse;

rSquared(2) = 1 - stats.SSresid/stats.SStotal
adjustedRSquared(2) = adjR2(yPrediction,Y,length(Y),length(b))