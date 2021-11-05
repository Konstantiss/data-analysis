data = [41 46 47 47 48 50 50 50 50 50 50 50 48 50 50 50 50 50 50 50 52 52 53 55 50 50 50 50 52 52 53 53 53 53 53 57 52 52 53 53 53 53 53 53 54 54 55 68];

ciVar(1,1) = ((length(data)-1) * var(data)) / chi2inv(0.975, length(data)-1);
ciVar(2,1) = ((length(data) - 1) * var(data)) / chi2inv(0.025, length(data)-1);

[hVar,pVar,ciVar,statsVar] = vartest(data,25);

[hMean,pMean,ciMean,statsMean] = ttest(data);

[hMean52,pMean52,ciMean52,statsMean52] = ttest(data,52);

[hChi,pChi] = chi2gof(data);