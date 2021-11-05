M = 1000;
n = 5;
mu = 15;

exp = exprnd(mu, M, n);

[h,p,ci,stats] = ttest(exp);
ci;
counter = 0;

for i=1:1:M
    for j=1:1:n
        if exp(i, j) < ci(2, j) && exp(i, j) > ci(1, j)
            counter = counter + 1;
        end
    end
end

counter
succesRate = counter / (M * n) 