clc
clear

%a
M = 1000;
n = 1000;
lambda = 100;
ns = 2.^[2:12]';
for i=1:length(ns)
    poiss = poissrnd(lambda, 1, ns(i));

    maxLikelihoodEstimate = mle(poiss, 'distribution', 'poisson');

    %Prove that they're equal
    maxLikelihoodEstimate == mean(poiss) 
end


%b
for i=1:length(ns)
    figure(i);
    poiss = poissrnd(lambda,M,ns(i));
    y = 1/n * sum(poiss);
    histogram(y)
    histfit(poiss(:,1),20,'poisson')
    mean(y)
end
