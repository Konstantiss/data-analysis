clc 
clear

M = 1000;
n = 20;
L = 1000;
a = 0.05;
mu = [0 0];
sigmaX = 1;
sigmaY = 1;
pDesired = 0.5;
covarianceMatrix = [sigmaX^2 pDesired*sigmaX*sigmaY; pDesired*sigmaX*sigmaY sigmaY^2]; 
sample = zeros(n,2);
r = zeros(M, 1);
rPermutated = zeros(M, 1);
sampleSquared = 1; % change this to 1 for sample,^2.
counter = 0;

for i=1:M
    sample = mvnrnd(mu, covarianceMatrix, n);
    if sampleSquared == 1
        sample = sample.^2;
    end
    corrCoef = corrcoef(sample);
    r(i) = corrCoef(1,2);
    
    sampleX = sample(:,1);
    sampleY = sample(:,2);
    
    for j=1:L
       random = randperm(n);
       sampleX = sampleX(random);
       corrCoefNew = corrcoef(sampleX, sampleY);
       rPermutated(j) = corrCoefNew(1,2);
    end
    
    t0 = r(i)*sqrt((n-2)/(1-r(i)^2));
    t = rPermutated.*sqrt((n-2)./(1-rPermutated.^2));
    t = sort(t);
    tLower = t(L * (a/2));
    tUpper = t(L * (1 - a/2));
    
    if t0 < tUpper && t0 > tLower
        counter = counter + 1;
    end
    
 end

percentage = counter / M 