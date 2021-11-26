clc
clear

n = 10;
M = 100;
B = 1000;
m = 12;
mu = 0;
sigma = 1;
a = [0.05, 0.025, 0.1];

X = normrnd(mu,sigma,M,n);

Y = normrnd(mu,sigma,M,m);

allValues = zeros(100,22);

allValues(1:100,1:10) = X;
allValues(1:100,11:22) = Y;

iterations = 1000;
pValuesRandomisation = NaN(1,100);
pValuesParametric = NaN(1,100);
pValuesBoot = NaN(1,100);
meanDifferenceResults = NaN(M,iterations);

for i=1:M
    [~,pValuesParametric(1,i),~,~] = ttest2(X(i,:),Y(i,:), 'Alpha', a(1));
    bootstrapMeanX = bootstrp(B,@mean,X(i,:));
    bootstrapMeanY = bootstrp(B,@mean,Y(i,:)); 
    [~,pValuesBoot(1,i),~,~] = ttest2(bootstrapMeanX,bootstrapMeanY, 'Alpha', a(1));
end

%Randomisation test:
for i=1:M
    for j=1:iterations
       meanDifference1 = mean(X(i,:)) - mean(Y(i,:));
       shuffledSample = allValues(i,:);
       shuffledSample=shuffledSample(randperm(length(shuffledSample)));
       newX = shuffledSample(1:n);
       newY = shuffledSample((n+1):m);
       meanDifference2 = mean(newX) - mean(newY);
       if abs(meanDifference2) >= meanDifference1
           meanDifferenceResults(i,j) = 1;
       else
           meanDifferenceResults(i,j) = 0;
       end
    end
    pValuesRandomisation(1,i) = sum(meanDifferenceResults(i,:) == 1) / iterations;
end

rejectionPercentageRandomisation = sum(pValuesRandomisation(:) <= a(1)) / M
rejectionPercentageParametric = sum(pValuesParametric(:) <= a(1)) / M
rejectionPercentageBoot = sum(pValuesBoot(:) <= a(1)) / M
%pValue = sum(meanDifferenceResults(:) == 1) / (M * iterations)
