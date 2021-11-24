clc
clear

n = 10;
M = 100;
m = 12;

X = normrnd(0,1,M,n);

Y = normrnd(0,1,M,m);

for i=1:M
   means(i) = mean(X(i,:)) - mean(Y(i,:)); 
end

%First question:

%i:
[~,~,ciDiff,~] = ttest(means);

%ii:
ciDiffBoot = bootci(100,@mean,means);

percentage(1) = abs((ciDiffBoot(1,1) - ciDiff(1))) * 100;
percentage(2) = abs((ciDiffBoot(2,1) - ciDiff(2))) * 100;


%Second question:

X2 = X.^2;
Y2 = Y.^2;

for i=1:M
   means2(i) = mean(X2(i,:)) - mean(Y2(i,:)); 
end

[~,~,ciDiff2,~] = ttest(means2);

ciDiff2Boot = bootci(100,@mean,means2);

%Third question:

Y = normrnd(0.2,1,M,m);

for i=1:M
   means3(i) = mean(X(i,:)) - mean(Y(i,:)); 
end

[~,~,ciDiff3,~] = ttest(means3);

ciDiff3Boot = bootci(100,@mean,means3);
