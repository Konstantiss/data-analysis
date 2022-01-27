function [bestCountryIds, positivityRatesBestCountries, positivityRatesGreece] = Group19Exe6Fun1()

data = readtable("ECDC-7Days-Testing.xlsx");
countries = readtable("EuropeanCountries.xlsx");

weeks2021 = ["2021-W38" "2021-W39" "2021-W40" "2021-W41" ...
    "2021-W42" "2021-W43" "2021-W44" "2021-W45" "2021-W46" "2021-W47"...
    "2021-W48" "2021-W49" "2021-W50"];

estoniaId = 8;
countryIds = [estoniaId - 4 estoniaId - 3 estoniaId - 2 estoniaId - 1 estoniaId];

positivityRateCountries2021 = zeros(5,length(weeks2021));

for i = 1:length(countryIds)
    greeceData = data(contains(data.country,countries{countryIds(i),2}),:);
    countryNames(i) = countries{countryIds(i),2};
    for j = 1:length(weeks2021)
        weeklyData2021 = greeceData(contains(greeceData.year_week,weeks2021(j)),:);
        positivityRateCountries2021(i,j) = mean(weeklyData2021.positivity_rate);
    end
    
end

countryNames = [countryNames 'Greece'];

% Data Greece
greeceData = data(contains(data.country,"Greece"),:);

positivityRateGreece2021 = zeros(1,length(weeks2021));

for i = 1:length(weeks2021)
    weekly_data = greeceData(contains(greeceData.year_week,weeks2021(i)),:);
    positivityRateGreece2021(i) = mean(weekly_data.positivity_rate);
end

pearson = zeros(size(positivityRateCountries2021,1),1);
roInConfidenceInterval005 = zeros(size(positivityRateCountries2021,1),1);
roInConfidenceInterval001 = zeros(size(positivityRateCountries2021,1),1);

for i = 1:size(positivityRateCountries2021,1)
    
    %for a confidence level equal to 97.5%
    [coef_matrix,~,lowerBound,upperBound] = corrcoef(positivityRateGreece2021,...
        positivityRateCountries2021(i,:),'Alpha',0.05);
    pearson(i) = coef_matrix(1,2);
    
    if pearson(i)<upperBound(1,2) && pearson(i)>lowerBound(1,2)
        roInConfidenceInterval005(i) = 1;
    end
    
    %for a confidence level equal to 99%
    [~,p,lowerBound,upperBound] = corrcoef(positivityRateGreece2021,...
        positivityRateCountries2021(i,:),'Alpha',0.01);
    
    if pearson(i)<upperBound(1,2) && pearson(i)>lowerBound(1,2)
        roInConfidenceInterval001(i) = 1;
    end
end

[~,sortedIndexes] = sort(abs(pearson));
bestCountryIds = [sortedIndexes(end), sortedIndexes(end-1)];
positivityRatesBestCountries(1,:) = positivityRateCountries2021(sortedIndexes(end),:);
positivityRatesBestCountries(2,:) = positivityRateCountries2021(sortedIndexes(end-1),:);
positivityRatesGreece = positivityRateGreece2021;