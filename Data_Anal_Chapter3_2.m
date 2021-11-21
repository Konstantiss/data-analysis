clc
clear

%a
M = 1000;
n = 1000;
lambda = 100;
ns = 2.^[2:12]';
for i=1:length(ns)
    exp = exprnd(1/lambda, 1, ns(i)); %E[X] = 1 / lambda

    maxLikelihoodEstimate = mle(exp, 'distribution', 'exponential');

    %Prove that they're equal
    maxLikelihoodEstimate == mean(exp) 
end


%b
for i=1:length(ns)
    figure(i);
    exp = exprnd(1/lambda,M,ns(i));
    y = 1/n * sum(exp);
    histogram(y)
    histfit(exp(:,1),20,'exponential')
    mean(y)
end
