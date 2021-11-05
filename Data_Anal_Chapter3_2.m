n = 1000;
lambda = 100;

exp = exprnd(1/lambda, 1, n); %E[X] = 1 / lambda

maxLikelihoodEstimate = mle(exp, 'distribution', 'exponential');

%Prove that they're equal
maxLikelihoodEstimate == mean(exp)
