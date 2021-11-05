n = 1000;
lambda = 100;

exp = exprnd(lambda, 1, n);

maxLikelihoodEstimate = mle(exp, 'distribution', 'exponential');

%Prove that they're equal
maxLikelihoodEstimate == mean(exp)