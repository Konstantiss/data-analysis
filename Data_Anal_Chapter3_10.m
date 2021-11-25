clc
clear

n = 10;
M = 100;
m = 12;

X = normrnd(0,1,M,n);

Y = normrnd(0,1,M,m);

allValues = zeros(100,22);

allValues(1:100,1:10) = X;
allValues(1:100,11:22) = Y;

iterations = 1000;
pValues = zeros(1,100);
meanDifferenceResults = NaN(M,iterations);

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
end

pValue = sum(meanDifferenceResults(:) == 1) / (M * iterations)
