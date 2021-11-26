clc
clear

n = 10;
M = 100;
B = 1000;
lambda = 0.1;
mu = 0;
sigma = 1;
a = [0.05, 0.025, 0.1];

X = normrnd(mu,sigma,M,n);

Y = poissrnd(lambda,M,n);

pValuesParametric = NaN(1,100);
pValuesBoot = NaN(1,100);

for i=1:M
    [~,pValuesParametric(1,i),~,~] = ttest2(X(i,:),Y(i,:), 'Alpha', a(1));
    bootstrapMeanX = bootstrp(B,@mean,X(i,:));
    bootstrapMeanY = bootstrp(B,@mean,Y(i,:)); 
    [~,pValuesBoot(1,i),~,~] = ttest2(bootstrapMeanX,bootstrapMeanY, 'Alpha', a(1));
end

rejectionPercentageParametric = sum(pValuesParametric(1,:) <= a(1)) / M
rejectionPercentageBoot = sum(pValuesBoot(1,:) <= a(1)) / M


