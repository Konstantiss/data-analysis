% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
clear

estoniaId = 8;
data = readtable('ECDC-7Days-Testing.xlsx');
greeceData = data(contains(data.country, "Greece"), :);
countries = readtable('EuropeanCountries.xlsx');
weeks2021 = ["2021-W38" "2021-W39" "2021-W40" "2021-W41" "2021-W42" "2021-W43" "2021-W44" "2021-W45" "2021-W46" "2021-W47" "2021-W48" "2021-W49" "2021-W50"];
weeks2020 = ["2020-W38" "2020-W39" "2020-W40" "2020-W41" "2020-W42" "2020-W43" "2020-W44" "2020-W45" "2020-W46" "2020-W47" "2020-W48" "2020-W49" "2020-W50"];
countryIds = [estoniaId - 4 estoniaId - 3 estoniaId - 2 estoniaId - 1 estoniaId];

weeklyPositivityRatesGreece2021 = zeros(1, length(weeks2021));
weeklyPositivityRatesGreece2020 = zeros(1, length(weeks2020));
weeklyPositivityRatesCountry2021 = zeros(length(countryIds), length(weeks2021));
weeklyPositivityRatesCountry2020 = zeros(length(countryIds), length(weeks2020));


for i=1:length(countryIds)
    countryData = data(contains(data.country, countries{countryIds(i),2}), :);
    for j=1:length(weeks2021)
        weeklyDataGreece2021 = greeceData(contains(greeceData.year_week, weeks2021(j)), :);
        weeklyPositivityRatesGreece2021(j) = mean(weeklyDataGreece2021.positivity_rate);
        
        weeklyCountryData2021 = countryData(contains(countryData.year_week, weeks2021(j)), :);
        weeklyPositivityRatesCountry2021(i,j) = mean(weeklyCountryData2021.positivity_rate);
        
        weeklyDataGreece2020 = greeceData(contains(greeceData.year_week, weeks2020(j)), :);
        weeklyPositivityRatesGreece2020(j) = mean(weeklyDataGreece2020.positivity_rate);
        
        weeklyCountryData2020 = countryData(contains(countryData.year_week, weeks2020(j)), :);
        weeklyPositivityRatesCountry2020(i,j) = mean(weeklyCountryData2020.positivity_rate);
    end
end

weeklyPositivityRatesCountry2021(isnan(weeklyPositivityRatesCountry2021))=0;
weeklyPositivityRatesCountry2020(isnan(weeklyPositivityRatesCountry2020))=0;



correlationCoefficients2021 = zeros(1,length(countryIds));
correlationCoefficients2020 = zeros(1,length(countryIds));

confidenceIntervals2021 = zeros(length(countryIds), 2);
confidenceIntervals2020 = zeros(length(countryIds), 2);

parametricResults2021 = 0;
parametricResults2020 = 0;
permutationResults2021 = 0;
permutationResults2020 = 0;
numberOfPermutations = 1000;

for i=1:length(countryIds)
    corrCoefMatrix = corrcoef(weeklyPositivityRatesGreece2021, weeklyPositivityRatesCountry2021(i,:));
    correlationCoefficients2021(i) = corrCoefMatrix(1,2);
    [~,~,confidenceIntervals2021(i,:),~] = ttest2(weeklyPositivityRatesGreece2021, weeklyPositivityRatesCountry2021(i,:));
    
    if 0 > confidenceIntervals2021(i,1) && 0 < confidenceIntervals2021(i,2)
        parametricResults2021 = parametricResults2021 + 1;
    end
    
    permutationResults2021 = permutationResults2021 + Group19Exe5Fun1(weeklyPositivityRatesGreece2021, weeklyPositivityRatesCountry2021(i,:), numberOfPermutations, correlationCoefficients2021(i));
    
    corrCoefMatrix = corrcoef(weeklyPositivityRatesGreece2020, weeklyPositivityRatesCountry2020(i,:));
    correlationCoefficients2020(i) = corrCoefMatrix(1,2);
    [~,~,confidenceIntervals2020(i,:),~] = ttest2(weeklyPositivityRatesGreece2020, weeklyPositivityRatesCountry2020(i,:));
    
    if 0 > confidenceIntervals2020(i,1) && 0 < confidenceIntervals2020(i,2)
        parametricResults2020 = parametricResults2020 + 1;
    end
    
    permutationResults2020 = permutationResults2020 + Group19Exe5Fun1(weeklyPositivityRatesGreece2020, weeklyPositivityRatesCountry2020(i,:), numberOfPermutations, correlationCoefficients2020(i));

end

%Display the correlation for each country.
for i=1:length(countryIds)
    disp([countries{countryIds(i),2},(abs(correlationCoefficients2021(i)) + abs(correlationCoefficients2020(i))) / 2]);
end