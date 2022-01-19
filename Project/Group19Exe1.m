clc

data = readtable('ECDC-7Days-Testing.xlsx');
countries = readtable('EuropeanCountries.xlsx');
weeks2021 = ["2021-W45" "2021-W46" "2021-W47" "2021-W48" "2021-W49" "2021-W50"];
weeks2020 = ["2020-W45" "2020-W46" "2020-W47" "2020-W48" "2020-W49" "2020-W50"];

positivityRates2021 = zeros(height(countries),1);
positivityRates2020 = zeros(height(countries),1);


for i = 1:height(countries)
    countryData = data(contains(data.country, countries{i,2}), :);
    for j = 1:length(weeks2021)
        weekData2021 = countryData(contains(countryData.year_week, weeks2021(j)), :);
        maxWeekPositivityRate = max(weekData2021.positivity_rate);
        
        if maxWeekPositivityRate > positivityRates2021(i,1) 
            if maxWeekPositivityRate < 100
                positivityRates2021(i,1) = maxWeekPositivityRate;
            end
        end
    end
    
    for j = 1:length(weeks2020)
        weekData2020 = countryData(contains(countryData.year_week, weeks2020(j)), :);
        maxWeekPositivityRate = max(weekData2020.positivity_rate);

        if maxWeekPositivityRate > positivityRates2020(i,1)
            if maxWeekPositivityRate < 100
                positivityRates2020(i,1) = maxWeekPositivityRate;
            end
        end
    end
end

figure()
title('Maximum positivity rates for week 45-50, 2021')
histogram(positivityRates2021, 20)

figure()
title('Maximum positivity rates for week 45-50, 2021 - exponential distribution fit')
histfit(positivityRates2021, 20, 'exponential')

figure()
title('Maximum positivity rates for week 45-50, 2021 - normal distribution fit')
histfit(positivityRates2021, 20, 'normal')

figure()
title('Maximum positivity rates for week 45-50, 2020')
histogram(positivityRates2020, 20)

figure()
title('Maximum positivity rates for week 45-50, 2020 - exponential distribution fit')
histfit(positivityRates2020, 20, 'exponential')

figure()
title('Maximum positivity rates for week 45-50, 2020 - normal distribution fit')
histfit(positivityRates2020, 20, 'normal')

fitdist(positivityRates2021, 'Normal')
fitdist(positivityRates2021, 'Exponential')

fitdist(positivityRates2020, 'Normal')
fitdist(positivityRates2020, 'Exponential')

