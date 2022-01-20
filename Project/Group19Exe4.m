% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
clear

estoniaId = 8;
data = readtable('ECDC-7Days-Testing.xlsx');
countries = readtable('EuropeanCountries.xlsx');
weeks2021 = ["2021-W42" "2021-W43" "2021-W44" "2021-W45" "2021-W46" "2021-W47" "2021-W48" "2021-W49" "2021-W50"];
weeks2020 = ["2020-W42" "2020-W43" "2020-W44" "2020-W45" "2020-W46" "2020-W47" "2020-W48" "2020-W49" "2020-W50"];
estoniaData = data(contains(data.country, countries{estoniaId,2}), :);
positivityRates2021 = zeros(1, length(weeks2021));
positivityRates2020 = zeros(1, length(weeks2020));
importances = zeros(1,5);

for i = 1:length(weeks2021)
    weekData2021 = estoniaData(contains(estoniaData.year_week, weeks2021(i)), :);
    positivityRates2021(i) = mean(weekData2021.positivity_rate);
    
    weekData2020 = estoniaData(contains(estoniaData.year_week, weeks2020(i)), :);
    positivityRates2020(i) = mean(weekData2020.positivity_rate);
end

positivityRates2021 = rmmissing(positivityRates2021);
positivityRates2020 = rmmissing(positivityRates2020);

ttest2(positivityRates2021,positivityRates2020);

positivityRates2021Boot = bootstrp(1000,@mean,positivityRates2021);
positivityRates2020Boot = bootstrp(1000,@mean,positivityRates2020);

[~,~,ci,~] = ttest2(positivityRates2021Boot,positivityRates2021Boot)

if 0 > ci(1) && 0 < ci(2)
    importances(1) = 1;
end

countryIds = [estoniaId - 4 estoniaId - 3 estoniaId - 2 estoniaId - 1];

positivityRatesCountries2021 = zeros(length(countryIds),length(weeks2021));
positivityRatesCountries2020 = zeros(length(countryIds),length(weeks2020));

for i=1:length(countryIds)
    countryData = data(contains(data.country, countries{countryIds(i),2}), :);
    for j=1:length(weeks2021)
        weekData2021 = countryData(contains(countryData.year_week, weeks2021(j)), :);
        positivityRatesCountries2021(i,j) = mean(weekData2021.positivity_rate);
        
        weekData2020 = countryData(contains(countryData.year_week, weeks2020(j)), :);
        positivityRatesCountries2020(i,j) = mean(weekData2020.positivity_rate);
    end
    positivityRatesCountries2021 = rmmissing(positivityRatesCountries2021);
    positivityRatesCountries2020 = rmmissing(positivityRatesCountries2020);
    
    ttest2(positivityRatesCountries2021,positivityRatesCountries2020)
    
    positivityRatesCountries2021Boot = bootstrp(1000,@mean,positivityRatesCountries2021(i,:));
    positivityRatesCountries2020Boot = bootstrp(1000,@mean,positivityRatesCountries2020(i,:));
    
    [~,~,ci,~] = ttest2(positivityRatesCountries2021Boot,positivityRatesCountries2020Boot)
    
    if 0 > ci(1) && 0 < ci(2)
        importances(1) = 1;
    end
end
