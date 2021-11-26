clc
clear

mu = 0;
sigma = 1;
M = 100;
n = 10;
B = 1000;
a = [0.05, 0.025, 0.1];
%for question beta change xsquared to 1
xSquared = 0;

if xSquared == 1
    X = X.^2;
end

X = normrnd(mu,sigma,M,n);

pValues0 = NaN(1,M);
pValues05 = NaN(1,M);
pValuesBoot0 = NaN(1,M);
pValuesBoot05 = NaN(1,M);


%for different as, change the a index

for i=1:M
    [~,pValues0(1,i),~,~] = ttest(X(i,:),0, 'Alpha', a(1));
    [~,pValues05(1,i),~,~] = ttest(X(i,:),0.5, 'Alpha', a(1));
    bootstat = bootstrp(B,@mean,X(i,:));
    [~,pValuesBoot0(1,i),~,~] = ttest(bootstat,0, 'Alpha', a(1));
    [~,pValuesBoot05(1,i),~,~] = ttest(bootstat,0.5, 'Alpha', a(1));        
end

percentage0 = sum(pValues0(1,:) <= a(1)) / M
percentage05 = sum(pValues05(1,:) <= a(1)) / M
percentageBoot0 = sum(pValuesBoot0(1,:) <= a(1)) / M
percentageBoot05 = sum(pValuesBoot05(1,:) <= a(1)) / M

