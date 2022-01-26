% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
clear

greeceData = readtable('FullEodyData.xlsx');

%Because there were many NaN values in the last two weeks of the data, we
%decided to start our measurements 2 weeks earlier. Also, in order to
%calculate the daily tests, since there is no column with daily PCR and
%Rapid tests, we need to subtract the totals for each day. So the weeks are
%13 in order to keep the last day of 2021-W34 in our data.

weeks = ["2021-W34" "2021-W35" "2021-W36" "2021-W37" "2021-W38" "2021-W39" "2021-W40" "2021-W41" "2021-W42"...
    "2021-W43" "2021-W44" "2021-W45" "2021-W46"];

% The data for the weekly positivity rates of europe were taken from  https://www.stelios67pi.eu/testing.html
europeWeeklyPositivityRates = [3.7 4.5 5 5.5 6.1 6 6.2 6.1 5.7 6.2 11.9 14.2];
greeceData = greeceData(contains(greeceData.Week, weeks),:);

greecePCR = greeceData.PCR_Tests;
greeceRapid = greeceData.Rapid_Tests;

%Remove the first 6 days of 2021-W34
greecePCR = greecePCR(7:end,:);
greeceRapid = greeceRapid(7:end,:);

%Remove the extra week.
greeceData = greeceData(~contains(greeceData.Week, weeks(1)),:);

greeceCases = greeceData.NewCases;

%Get the daily PCR and Rapid tests.
for i=2:length(greeceRapid)
    greecePCR(i-1) = greecePCR(i) - greecePCR(i-1);
    greeceRapid(i-1) = greeceRapid(i) - greeceRapid(i-1);
end

% 
% dailyPositivityRate = zeros(1,7);
% europeWeeklyPositivityRatesIndex = 1;
% differences = zeros(1,12);
% 
% for i=1:7:height(greeceData) - 7
%     upperBound = i + 6;
%     weeklyPCR = greecePCR(i:upperBound);
%     weeklyRapid = greeceRapid(i:upperBound);
%     weeklyCases = greeceCases(i:upperBound);
%     for j = 1:7
%         dailyPositivityRate(1,j) = (weeklyCases(j) / (weeklyPCR(j) + weeklyRapid(j))) * 100;
%     end
%     dailyPositivityRate = dailyPositivityRate(~isnan(dailyPositivityRate));
%     differences(europeWeeklyPositivityRatesIndex) = Group19Exe3Fun1(dailyPositivityRate, europeWeeklyPositivityRates(europeWeeklyPositivityRatesIndex));
%     europeWeeklyPositivityRatesIndex = europeWeeklyPositivityRatesIndex + 1;
% end
% 
% differences
% 
% figure()
% plot(differences)

