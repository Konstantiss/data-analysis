clc
clear

data = importdata('lightair.txt');

airDensityData = data(:,1);
lightSpeedData = data(:,2);

M = 1000;
n = 100;
b = zeros(M,2);
alpha = 0.05;
percentiles = [alpha/2 (1 - alpha/2)];

for i=1:M
    bootstrapData = data(unidrnd(n,n,1), :);
    
    X = bootstrapData(:,1);
    Y = bootstrapData(:,2);
    linearRegressionModel = fitlm(X,Y);
    
    btemp = table2array(linearRegressionModel.Coefficients);
    b(i,:) = btemp(:,1)';
end
b0Ci = prctile(sort(b(:,1)), percentiles)
b1Ci = prctile(sort(b(:,2)), percentiles)


linearRegressionModel = fitlm(airDensityData, lightSpeedData);
b = linearRegressionModel.Coefficients.Estimate;
coefficientConfidenceIntervals = coefCI(linearRegressionModel)