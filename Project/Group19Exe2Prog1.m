% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907
%% Run this section to gather data for question 2.
clc
clear

estoniaId = 8;
data = readtable('ECDC-7Days-Testing.xlsx');
countries = readtable('EuropeanCountries.xlsx');
weeks2021 = ["2021-W45" "2021-W46" "2021-W47" "2021-W48" "2021-W49" "2021-W50"];
weeks2020 = ["2020-W45" "2020-W46" "2020-W47" "2020-W48" "2020-W49" "2020-W50"];
estoniaData = data(contains(data.country, countries{estoniaId,2}), :);

positivityRates2021 = zeros(height(countries),1);
positivityRates2020 = zeros(height(countries),1);

bestWeek2021Id = 0;
bestWeek2020Id = 0;

for j = 1:length(weeks2021)
        weekData2021 = estoniaData(contains(estoniaData.year_week, weeks2021(j)), :);
        maxWeekPositivityRate = max(weekData2021.positivity_rate);
        
        if maxWeekPositivityRate > positivityRates2021(estoniaId,1) 
            if maxWeekPositivityRate < 100
                positivityRates2021(estoniaId,1) = maxWeekPositivityRate;
                bestWeek2021Id = j;
            end
        end
end

for j = 1:length(weeks2020)
    weekData2020 = estoniaData(contains(estoniaData.year_week, weeks2020(j)), :);
    maxWeekPositivityRate = max(weekData2020.positivity_rate);

    if maxWeekPositivityRate > positivityRates2020(estoniaId,1)
        if maxWeekPositivityRate < 100
            positivityRates2020(estoniaId,1) = maxWeekPositivityRate;
            bestWeek2020Id = j;
        end
    end
end



for i = 1:height(countries)
    countryData = data(contains(data.country, countries{i,2}), :);
    weekData2021 = countryData(contains(countryData.year_week, weeks2021(bestWeek2021Id)), :);
    maxWeekPositivityRate2021 = mean(weekData2021.positivity_rate); %Get the mean because some countries have data for many regions.

    if maxWeekPositivityRate2021 > positivityRates2021(i,1) 
        if maxWeekPositivityRate2021 < 100
            positivityRates2021(i,1) = maxWeekPositivityRate2021;
        end
    end
    
    weekData2020 = countryData(contains(countryData.year_week, weeks2020(bestWeek2020Id)), :);
    maxWeekPositivityRate2020 = mean(weekData2020.positivity_rate); %Get the mean because some countries have data for many regions.

    if maxWeekPositivityRate2020 > positivityRates2020(i,1)
        if maxWeekPositivityRate2020 < 100
            positivityRates2020(i,1) = maxWeekPositivityRate2020;
        end
    end
end

 %Remove zeros.
positivityRates2021 = positivityRates2021(positivityRates2021~=0);
positivityRates2020 = positivityRates2020(positivityRates2020~=0);

%% Question 2:

M = 1000;
positivityRates2021Boot = bootstrp(M, @mean, positivityRates2021, length(positivityRates2021));
positivityRates2020Boot = bootstrp(M, @mean, positivityRates2020, length(positivityRates2020));

ksStats = zeros(M,1);
pValues = zeros(M,1);
h0 = zeros(M,1);
for i = 1:M
   [h,p,ksstat] = kstest2(positivityRates2021Boot(i,:),positivityRates2020Boot(i,:))
   ksStats(i,1) = ksstat;
   pValues(i,1) = p;
   h0(i) = h;
end
figure()
histogram(ksStats)
title("Kolmogorov - Shmirnov statistic histogram")

figure()
histogram(pValues)
title("P values histogram")

figure()
histogram(h0)
title("H0 histogram")

distributions = ["Exponential", "Lognormal", "Normal", "Poisson"];

for i=1:length(distributions)
    pd = fitdist(ksStats, distributions(i));
    figure()
    qqplot(ksStats, pd)
    title("Quantile plot - "+ distributions(i))
end

%It is apparent from the graphs that the positivity rates from 2020 and
%2021 do not follow the same distribution.