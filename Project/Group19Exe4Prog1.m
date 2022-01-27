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


mean(positivityRates2021)
mean(positivityRates2020)

[h,p,ci,stats] = ttest2(positivityRates2021,positivityRates2020)

%Resample data.
[~,bootsam] = bootstrp(M,[],positivityRates2021);
bootsam = reshape(bootsam, length(bootsam), []);
positivityRates2021Resampled = positivityRates2021(bootsam);

[~,bootsam] = bootstrp(M,[],positivityRates2020);
bootsam = reshape(bootsam, length(bootsam), []);
positivityRates2020Resampled = positivityRates2020(bootsam);
pvaluesEstoniaBoot = zeros(1,M);

correlatedSamplesEstonia = 0;
for i=1:M
    [h,pvaluesEstoniaBoot(1,i),ci,stats] = ttest2(positivityRates2021Resampled(i,:),positivityRates2020Resampled(i,:));
    %Check if ci contains 0.
    if ci(1) < 0 && ci(2) > 0
        correlatedSamplesEstonia = correlatedSamplesEstonia + 1;
    end
end
correlationPercentage = (correlatedSamplesEstonia / M) * 100;
fprintf("Correlated samples percentage for Estonia: %0.2f ",correlationPercentage);

%% Other countries
countryIds = [estoniaId - 4 estoniaId - 3 estoniaId - 2 estoniaId - 1];

positivityRatesCountries2021 = zeros(length(countryIds),length(weeks2021));
positivityRatesCountries2020 = zeros(length(countryIds),length(weeks2020));
countryPValues = zeros(length(countryIds),1);
bootCountryPValues = zeros(length(countryIds), M);
correlatedSamplesCountries = zeros(length(countryIds),1);

for i=1:length(countryIds)
    countryData = data(contains(data.country, countries{countryIds(i),2}), :);
    for j=1:length(weeks2021)
        weekData2021 = countryData(contains(countryData.year_week, weeks2021(j)), :);
        positivityRatesCountries2021(i,j) = mean(weekData2021.positivity_rate);
        
        weekData2020 = countryData(contains(countryData.year_week, weeks2020(j)), :);
        positivityRatesCountries2020(i,j) = mean(weekData2020.positivity_rate);
    end
    
    [h,countryPValues(i,1),ci,stats] = ttest2(positivityRatesCountries2021(i,:),positivityRatesCountries2020(i,:));
    
    %Resample data.
    temp = positivityRatesCountries2021(i,:);
    [~,bootsam] = bootstrp(M,[],temp);
    bootsam = reshape(bootsam, length(bootsam), []);
    positivityRatesCountry2021Resampled = temp(bootsam);
    
    temp = positivityRatesCountries2020(i,:);
    [~,bootsam] = bootstrp(M,[],temp);
    bootsam = reshape(bootsam, length(bootsam), []);
    positivityRatesCountry2020Resampled = temp(bootsam);
    for j=1:M
        [h,bootCountryPValues(i,j),ci,stats] = ttest2(positivityRatesCountry2021Resampled(j,:),positivityRatesCountry2020Resampled(j,:));
        %Check if ci contains 0.
        if ci(1) < 0 && ci(2) > 0
            correlatedSamplesCountries(i,1) = correlatedSamplesCountries(i,1) + 1;
        end
    end
end

figure()
histogram(pvaluesEstoniaBoot,20)
title('P values for resampled data of Estonia')

figure()
histogram(countryPValues,4)
title('P values for 4 europe countries')

figure()
histogram(bootCountryPValues,20)
title('P values for resampled data of 4 europe countries')


%We come to the conclusion that the positivity rates of 2021 and 2020
%differ significantly. We need to take into consideration the small sample
%size, which means that we cannot be very confident about the results we
%are getting. Also, it is important to note that resampling our data when
%we have such a small sample, whether it is with bootstrap or with random
%permutation, does not make up for the lack of data.
