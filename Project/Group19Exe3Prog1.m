% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
clear

greeceData = readtable('FullEodyData.xlsx');

%10/10/2021 - 26/12/2021
%Because there were many NaN values in the last two weeks of the data, we
%decided to start our measurements 2 weeks earlier

europeWeeklyPositivityRates = [3.7 4.5 5 5.5 6.1 6 6.2 6.1 5.7 6.2 11.9 14.2];
greeceData = greeceData(529:614,:);
greecePCR = greeceData.PCR_Tests;
greeceRapid = greeceData.Rapid_Tests;
greeceCases = greeceData.NewCases;

for i=2:length(greeceRapid)
   greecePCR(i-1) = greecePCR(i) - greecePCR(i-1);
   greeceRapid(i-1) = greeceRapid(i) - greeceRapid(i-1);
end

dailyPositivityRate = zeros(1,7);
europeWeeklyPositivityRatesIndex = 1;
differences = zeros(1,12);

for i=1:7:height(greeceData) - 7
    upperBound = i + 6;
    weeklyPCR = greecePCR(i:upperBound);
    weeklyRapid = greeceRapid(i:upperBound);
    weeklyCases = greeceCases(i:upperBound);
    for j = 1:7 
        dailyPositivityRate(1,j) = (weeklyCases(j) / (weeklyPCR(j) + weeklyRapid(j))) * 100;
    end
    dailyPositivityRate = dailyPositivityRate(~isnan(dailyPositivityRate));
    differences(europeWeeklyPositivityRatesIndex) = Group19Exe3Fun1(dailyPositivityRate, europeWeeklyPositivityRates(europeWeeklyPositivityRatesIndex));
    europeWeeklyPositivityRatesIndex = europeWeeklyPositivityRatesIndex + 1;
end

differences

figure()
plot(differences)

