%% collect data
clc
close all;
clear;

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

figure(1)
hold on
for i = 1:size(positivityRateCountries2021,1)
    scatter(1:size(positivityRateCountries2021,2),positivityRateCountries2021(i,:),'filled')
end
scatter(1:size(positivityRateCountries2021,2),positivityRateGreece2021,'filled')
legend(countryNames);
hold off

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
chosenCountry = countryNames(sortedIndexes(end));
fprintf("Strongest Correlation is between Greece and " + chosenCountry);

iterations = 100;
hypothesisCorrect = zeros(size(positivityRateCountries2021,1),1);
alpha = [5,1] ;

for i = 1:5
    
    t0 = pearson(i)*sqrt((size(positivityRateCountries2021,2)-2)/(1-pearson(i)^2)); %Equation 5.5 page 86
    tTemp = zeros(iterations,1);
    
    for j = 1:iterations
        greeceData = positivityRateCountries2021(i,:);
        greeceData = randperm(length(greeceData));
        
        rTemp = corrcoef(greeceData,positivityRateGreece2021);
        tTemp(j) = rTemp(1,2)*sqrt((size(positivityRateCountries2021,2)-2)/(1-rTemp(1,2)^2));
    end
    sort(tTemp);
    
    percentiles = [alpha(1)/2 (100-alpha(1))/2];
    CI = prctile(tTemp,percentiles);
    
    if(t0>CI(1) && t0<CI(2))
        hypothesisCorrect(i) = 1;
    end
end

%Since pearson value is in the Confidence Interval for every country, we can assume that it
%can be trusted. Also every absolute value of the pearson coeficient is smaller 
%than 0.9. Consequently, we understand that there is no strong correlation between
%any country and Greece. The strongest correlation is between Greece and
%Croatia. Since our data sample is very small (n = 13) results may vary for
%small changes. This assumption can be verified by the random permutation
%test, whose null hypothesis test results, don't match with the results shown above.