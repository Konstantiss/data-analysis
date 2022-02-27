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

X = positivityRates2021;
Y = positivityRates2020;
mutualSample = [X;Y];

M = 1000;
fHatX = zeros(length(Y),1);
fHatY = zeros(length(Y),1);

for j = 1:length(Y)
    fHatX(j) = sum(X(:) <= X(j)); 
    fHatY(j) = sum(Y(:) <= Y(j)); 
end
kolmogorovStatOriginal = max(abs(fHatX(1:22) - fHatY));

kolmogorovStat = zeros(M,1);

for i = 1:M
    mutualSample = mutualSample(randperm(length(mutualSample)));
    xRand = mutualSample(1:length(X));
    yRand = mutualSample(length(X)+1:end);
    
    for j = 1:length(Y)
        fHatX(j) = sum(xRand(:) <= xRand(j)); 
        fHatY(j) = sum(yRand(:) <= yRand(j)); 
    end
    absolutDif = abs(fHatX(1:22) - fHatY);
    kolmogorovStat(i) = max(absolutDif);    
end

kolmogorovStat = sort(kolmogorovStat);
alpha = 0.5;
limits = floor([M*alpha/2 M*(1-alpha/2)]);
boundaries = [kolmogorovStat(limits(1)) kolmogorovStat(limits(2))];

if kolmogorovStatOriginal >= boundaries(1) && kolmogorovStatOriginal <= boundaries(2)
    h = 0;
end

disp(h)

%Given that h = 0, we cannot reject the null hypothesis that 
%the two periods come from the same distribution.