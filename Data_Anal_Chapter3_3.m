%first question
M = 1000;
n = 5;
mu = 15;

exp = exprnd(mu, n, M);

expMean = mean(exp);

[h,p,ci,stats] = ttest(exp);
ciMean(1,1) = mean(ci(1,:));
ciMean(2,1) = mean(ci(2,:));
counter = 0;

for i=1:1:M
    if expMean(1, i) < ciMean(2, 1) && expMean(1, i) > ciMean(1, 1)
        counter = counter + 1;
    end
end

succesRatePercentage = (counter / M) * 100 
%second question
M = 1000;
n = 100;
mu = 15;

exp = exprnd(mu, n, M);

expMean = mean(exp);

[h,p,ci,stats] = ttest(exp);
ciMean(1,1) = mean(ci(1,:));
ciMean(2,1) = mean(ci(2,:));
counter = 0;

for i=1:1:M
    if expMean(1, i) < ciMean(2, 1) && expMean(1, i) > ciMean(1, 1)
        counter = counter + 1;
    end
end

succesRatePercentage = (counter / M) * 100
%The succes rate is reduced for higher ns.
