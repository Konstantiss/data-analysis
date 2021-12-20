clc 
clear

data = importdata('lightair.txt');

airDensityData = data(:,1);
lightSpeedData = data(:,2);

%Question 1:

figure(1)
scatter(airDensityData, lightSpeedData);

corrCoeffArray = corrcoef(airDensityData, lightSpeedData);
corrCoeff = corrCoeffArray(1,2);

%Question 2:

linearRegressionModel = fitlm(airDensityData, lightSpeedData);
b = linearRegressionModel.Coefficients.Estimate;
coefficientConfidenceIntervals = coefCI(linearRegressionModel);

%Question 3:
figure(2)
plot(linearRegressionModel);
Xnew = 1.29;
[ypred,ypredCi] = predict(linearRegressionModel,Xnew,'Prediction','curve');
[~,yobserveCi] = predict(linearRegressionModel,Xnew,'Prediction','observation');

%Question 4:
Xones = [ones(length(airDensityData),1) airDensityData];
bReal = zeros(2,1);
bReal(1,1) = 299792.458;
bReal(2,1) = 299792.458 * 0.00029 / 1.29;
regression = Xones*bReal - 299000;
figure(3)
plot(airDensityData,regression,'LineWidth',2,'LineStyle','-','Color','r')
bReal(1) = bReal(1) - 299000;