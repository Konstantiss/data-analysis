clc 
clear 

tempData = readmatrix('tempThes59_97.txt');
rainData = readmatrix('rainThes59_97.txt');
M = 12;
n = 39;
L = 1000;
a = 0.05;
rPermutated = zeros(L, 1);
sampleSquared = 1; % change this to 1 for sample,^2.
results = zeros(1,M);
counter = 0;
for j = 1:M
    monthlyTempData = tempData(:,j);
    monthlyRainData = rainData(:,j);
    corrCoef = corrcoef(monthlyTempData, monthlyRainData);
    r = corrCoef(1,2);
    for i = 1:L
        random = randperm(n);
        monthlyTempData = monthlyTempData(random);
        corrCoefNew = corrcoef(monthlyTempData, monthlyRainData);
        rPermutated(i) = corrCoefNew(1,2);
    end
    t0 = r*sqrt((n-2)/(1-r^2));
    t = rPermutated.*sqrt((n-2)./(1-rPermutated.^2));
    t = sort(t);
    tLower = t(L * (a/2));
    tUpper = t(L * (1 - a/2));
    
    if t0 < tUpper && t0 > tLower
        counter = counter + 1;
        results(1,j) = 1;
    end
end

percentage = counter / M
results


