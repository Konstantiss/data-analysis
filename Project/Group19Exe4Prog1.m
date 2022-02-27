% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
clear

M = 1000;
estoniaId = 8;
data = readtable('ECDC-7Days-Testing.xlsx');
countries = readtable('EuropeanCountries.xlsx');
weeks2021 = ["2021-W42" "2021-W43" "2021-W44" "2021-W45" "2021-W46" "2021-W47" "2021-W48" "2021-W49" "2021-W50"];
weeks2020 = ["2020-W42" "2020-W43" "2020-W44" "2020-W45" "2020-W46" "2020-W47" "2020-W48" "2020-W49" "2020-W50"];
estoniaData = data(contains(data.country, countries{estoniaId,2}), :);
%% Estonia
estoniaData2021 = estoniaData(contains(estoniaData.year_week, weeks2021), :);
estoniaData2020 = estoniaData(contains(estoniaData.year_week, weeks2020), :); %2020-W43 is missing.

positivityRates2021 = estoniaData2021.positivity_rate;
positivityRates2020 = estoniaData2020.positivity_rate;

%Make data row vectors.
positivityRates2021 = reshape(positivityRates2021,[],length(positivityRates2021));
positivityRates2020 = reshape(positivityRates2020,[],length(positivityRates2020));

meanDiffOriginal = mean(positivityRates2021) -  mean(positivityRates2020);
h_parametric = ones(5,1);
p_parametric = ones(5,1);
[h_parametric(1),p_parametric(1),ci,stats] = ttest2(positivityRates2021,positivityRates2020);

%Resample data.
positivityRates2021boot = bootstrp(M,@mean,positivityRates2021);
positivityRates2020boot = bootstrp(M,@mean,positivityRates2020);

meanDiffBoot = positivityRates2021boot - positivityRates2020boot;

alpha = 0.05;
limits = floor([M*alpha/2 M*(1-alpha/2)]);

h = ones(5,1);

if meanDiffBoot(limits(1)) <= meanDiffOriginal && meanDiffOriginal <= meanDiffBoot(limits(2))
    h(1) = 0;
end

%% Other countries
countryIds = [estoniaId - 2 estoniaId - 1 estoniaId + 1 estoniaId + 3];

countryPValues = zeros(length(countryIds),1);
bootCountryPValues = zeros(length(countryIds), M);
correlatedSamplesCountries = zeros(length(countryIds),1);

for i=1:length(countryIds)
    countryData = data(contains(data.country, countries{countryIds(i),2}), :);
    
    for j=1:length(weeks2021)
        weekData2021 = countryData(contains(countryData.year_week, weeks2021(j)), :);
        positivityRatesCountries2021(j) = mean(weekData2021.positivity_rate);
        
        weekData2020 = countryData(contains(countryData.year_week, weeks2020(j)), :);
        positivityRatesCountries2020(j) = mean(weekData2020.positivity_rate);
    end
    
    [h_parametric(i+1),p_parametric(i+1),~,~] = ttest2(positivityRatesCountries2021,positivityRatesCountries2020);
    
    meanDiffOriginal = mean(positivityRatesCountries2021) - mean(positivityRatesCountries2021);
    
    positivityRatesCountries2021Boot = bootstrp(M,@mean,positivityRatesCountries2021);
    positivityRatesCountries2020Boot = bootstrp(M,@mean,positivityRatesCountries2020);
    
    meanDiffBoot = positivityRatesCountries2021Boot - positivityRatesCountries2020Boot;
    
    if meanDiffBoot(limits(1)) <= meanDiffOriginal && meanDiffOriginal <= meanDiffBoot(limits(2))
        h(i+1) = 0;
    end
   
end

disp(h)
disp(h_parametric)

%We come to the conclusion that the positivity rates of 2021 and 2020
%differ significantly. We need to take into consideration the small sample
%size, which means that we cannot be very confident about the results we
%are getting. Also, it is important to note that resampling our data when
%we have such a small sample, whether it is with bootstrap or with random
%permutation, does not make up for the lack of data.
