% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

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

figure()
histogram(positivityRates2021, 20)
title('Maximum positivity rates 2021')

figure()
histogram(positivityRates2020, 20)
title('Maximum positivity rates 2020')

% distributions = ["Exponential", "Lognormal", "Normal", "Poisson"];
distributions = ["Normal"];


for i=1:length(distributions)
    figure()
    histfit(positivityRates2021, 20, distributions(i))
    title("Maximum positivity rates 2021 - "+ distributions(i))
    
    pd = fitdist(positivityRates2021, distributions(i));
    figure()
    qqplot(positivityRates2021, pd)
    title("Quantile plot 2021 - "+ distributions(i))
    
    figure()
    histfit(positivityRates2020, 20, distributions(i))
    title("Maximum positivity rates 2020 - "+ distributions(i))
    
    pd = fitdist(positivityRates2020, distributions(i));
    figure()
    qqplot(positivityRates2020, pd)
    title("Quantile plot 2020 - "+ distributions(i))
end

chi2gof(positivityRates2020)
chi2gof(positivityRates2021)

%Judging by the quantile plots, the histfit, and the chi2gof, we can say that both the data
%from 2020 and 2021 fit the normal distribution to some extent.
