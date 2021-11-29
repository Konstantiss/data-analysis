clc
clear

n = 10;
M = 100;
B = 1000;
m = 12;
mu = 0;
sigma = 1;
a = [0.05, 0.025, 0.1];

X = normrnd(mu,sigma,M,n);

Y = normrnd(mu,sigma,M,m);

lowerLim = (B+1)*a(1)/2;
upperLim = B+1-lowerLim;
limits = [lowerLim upperLim];

pValuesParametric = NaN(1,100);
pValuesBoot = NaN(1,100);
result = zeros(M,1);

% Randomisation test
for i = 1:M
    samples = [X(i,:) Y(i,:)];
    difference = NaN(B,1);
    for j = 1:B
        samplesTemp = samples(randperm(length(samples)));
        newX = samplesTemp(1:n);
        newY = samplesTemp(n+1:end);
        mx = mean(newX);
        my = mean(newY);
        difference(j) = mx - my;
    end
    stat = mean(X(i,:)) - mean(Y(i,:));
    difference = [difference; stat];
    difference = sort(difference);
    
    rankStat = find(difference == stat);
    if( length(rankStat) > 1)
        L = length(rankStat);
        sample = randsample(L,1);
        rankStat = rankStat(sample);
    end
    
    if( rankStat < limits(1) || rankStat > limits(2) )
        result(i) = 1;
    end
    
    if rankStat > 0.5*(B+1)
        pd = 2*(1-rankStat/(B+1));
    else
        pd = 2*rankStat/(B+1);
    end
    
end

for i=1:M
    [~,pValuesParametric(1,i),~,~] = ttest2(X(i,:),Y(i,:), 'Alpha', a(1));
    bootstrapMeanX = bootstrp(B,@mean,X(i,:));
    bootstrapMeanY = bootstrp(B,@mean,Y(i,:)); 
    [~,pValuesBoot(1,i),~,~] = ttest2(bootstrapMeanX,bootstrapMeanY, 'Alpha', a(1));
end



rejectionPercentageRandomisation = sum(result == 1) / M
rejectionPercentageParametric = sum(pValuesParametric(1,:) <= a(1)) / M
rejectionPercentageBoot = sum(pValuesBoot(1,:) <= a(1)) / M
