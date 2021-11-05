n = 1000;
lambda = 100;

poiss = poissrnd(lambda, 1, n);

maxLikelihoodEstimate = mle(poiss, 'distribution', 'poisson');

%Prove that they're equal
maxLikelihoodEstimate == mean(poiss)
