clc
clear

% Question 1:

% P = sqrt((sv*I*cos(f))^2 + (si*V*cos(f))^2 + (sf*V*I*(-sin(f)))^2)

% Question 2:

meanV = 77.78;
meanI = 1.21;
meanF = 0.283;
stdV = 0.71;
stdI = 0.071;
stdF = 0.017;
M = 1000;

sigmaP = sqrt((stdV*meanI*cos(meanF))^2 + (stdI*meanV*cos(meanF))^2 + (stdF*meanV*meanI*(-sin(meanF)))^2);
pValues = zeros(M,1);
V = normrnd(meanV,stdV,M,1);
I = normrnd(meanI,stdI,M,1);
f = normrnd(meanF,stdF,M,1);
pValues(:,1) = V(:).*I(:).*cos(f(:));
sigmaP == std(pValues) %Check if they're equal
sigmaP
std(pValues)

% Question 3:
covVF = 0.5;

sigmaP2 = sqrt((meanI*cos(meanF))^2*stdV^2+...
2*(meanI*cos(meanF))*meanV*meanI*(-sin(meanF))*covVF*stdV*stdF+...
    (meanV*cos(meanF))^2*stdI^2+...
    (meanV*meanI*(-sin(meanF)))^2*stdF^2);

Sigma = [stdI^2 0 0;...
    0 stdV^2 covVF*stdV*stdF;...
    0 covVF*stdV*stdF stdF^2]; 

mu=[meanI, meanV, meanF];
variables = mvnrnd(mu,Sigma,M);

pValues2(:)= variables(:,1).*variables(:,2).*cos(variables(:,3));
sigmaP2 == std(pValues2) %Check if they're equal
sigmaP2
std(pValues2)



