% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
close all;
clear

estoniaId = 8;
data = readtable('ECDC-7Days-Testing.xlsx');
deathsData = readtable('v_countries_summary.csv');
countries = readtable('EuropeanCountries.xlsx');
firstPeriodWeeks = ["2020-W49" "2020-W50" "2020-W51" "2020-W52" "2020-W53" "2021-W01" "2021-W02" "2021-W03" "2021-W04"...
    "2021-W05" "2021-W06" "2021-W407" "2021-W08" "2021-W09" "2021-W10" "2021-W11" "2021-W12" "2021-W13"...
    "2021-W14" "2021-W15" "2021-W16"];
secondPeriodWeeks = ["2020-W31" "2020-W32" "2020-W33" "2020-W34" "2020-W35" "2020-W36" "2020-W37" "2020-W38" "2020-W39"...
    "2020-W39" "2020-W40" "2020-W41" "2020-W42" "2020-W43" "2020-W44" "2020-W45" "2020-W46" "2020-W47"...
    "2020-W48" "2020-W49" "2020-W50"];
%Different format for the csv file.
firstPeriodWeeksForDeaths = ["2021-01" "2021-02" "2021-03" "2021-04"...
    "2021-05" "2021-06" "2021-407" "2021-08" "2021-09" "2021-10" "2021-11" "2021-12" "2021-13"...
    "2021-14" "2021-15" "2021-16"];
secondPeriodWeeksForDeaths = ["2020-36" "2020-37" "2020-38" "2020-39"...
    "2020-39" "2020-40" "2020-41" "2020-42" "2020-43" "2020-44" "2020-45" "2020-46" "2020-47"...
    "2020-48" "2020-49" "2020-50"];

estoniaData = data(contains(data.country, countries{estoniaId,2}), :);
estoniaDeathsData = deathsData(contains(deathsData.Country_Code, 'EST'), :);
weeklyPositivityRatesFirstPeriod = zeros(1, length(firstPeriodWeeks));
weeklyPositivityRatesSecondPeriod = zeros(1, length(secondPeriodWeeks));
weeklyDeathsFirstPeriod = zeros(1, length(firstPeriodWeeksForDeaths));
weeklyDeathsSecondPeriod = zeros(1, length(secondPeriodWeeksForDeaths));

for i = 1:length(firstPeriodWeeks)
    weekDataFirstPeriod = estoniaData(contains(estoniaData.year_week, firstPeriodWeeks(i)), :);
    weeklyPositivityRatesFirstPeriod(i) = mean(weekDataFirstPeriod.positivity_rate);
    
    weekDataSecondPeriod = estoniaData(contains(estoniaData.year_week, secondPeriodWeeks(i)), :);
    weeklyPositivityRatesSecondPeriod(i) = mean(weekDataSecondPeriod.positivity_rate);
    
end

for i = 1:length(firstPeriodWeeksForDeaths)
    weeklyDeathsDataFirstPeriod = estoniaDeathsData(contains(estoniaDeathsData.Year_Week, firstPeriodWeeksForDeaths(i)), :);
    weeklyDeathsFirstPeriod(i) = mean(str2double(weeklyDeathsDataFirstPeriod.Weekly_Deaths));
    
    weeklyDeathsDataSecondPeriod = estoniaDeathsData(contains(estoniaDeathsData.Year_Week, secondPeriodWeeksForDeaths(i)), :);
    weeklyDeathsSecondPeriod(i) = mean(str2double(weeklyDeathsDataSecondPeriod.Weekly_Deaths));
end
 
latencies = [1:4];
for i = 1:length(latencies)
    positivityRateFirstIndex = 5 - latencies(i);
    for j = positivityRateFirstIndex:length(weeklyPositivityRatesFirstPeriod) - latencies(i) - 1
        X(j - positivityRateFirstIndex + 1) = weeklyPositivityRatesFirstPeriod(j);
    end
    for j = 1:length(weeklyDeathsFirstPeriod)
        Y(j) = weeklyDeathsFirstPeriod(j);
    end
    linearModel = fitlm(X,Y)
    adjustedRsFirstPeriod(i) = linearModel.RMSE;
end

for i = 1:length(latencies)
    positivityRateFirstIndex = 5 - latencies(i);
    for j = positivityRateFirstIndex:length(weeklyPositivityRatesSecondPeriod) - latencies(i) - 1
        X(j - positivityRateFirstIndex + 1) = weeklyPositivityRatesSecondPeriod(j);
    end
    for j = 1:length(weeklyDeathsSecondPeriod)
        Y(j) = weeklyDeathsSecondPeriod(j);
    end
    linearModel = fitlm(X,Y)
    adjustedRsSecondPeriod(i) = linearModel.RMSE;
end

adjustedRsFirstPeriod = sort(adjustedRsFirstPeriod);
adjustedRsSecondPeriod = sort(adjustedRsSecondPeriod);





