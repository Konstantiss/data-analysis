clc 
clear

eIdeal = 0.76;
h1 = 100;
M = 1000;
n = 5;
mu = 58;
sigma = 2;
samples = zeros(n,1);
eMean = zeros(M,1);
eStd = zeros(M,1);
rebounds = [60 54 58 60 56];


% Question 1:
e = sqrt(rebounds/h1);
[h,~,~,~] = ttest(e,eIdeal);

% Question 2:
for i = 1:M
    samples = normrnd(mu, sigma, n, 1);
    meanSamples = mean(samples);
    stdSamples = std(samples);
    e = sqrt(samples/h1);
    eMean(i) = mean(e);
    eStd(i) = std(e);
end

figure(1);
histogram(eMean);
hold on
xline(eIdeal,'r')

% Question 3:

h1 = [80 100 90 120 95];
h2 = [48 60 50 75 56];

std(h1);
std(h2);

e = sqrt(h2./h1);

[h,~,~,~] = ttest(e,eIdeal);



