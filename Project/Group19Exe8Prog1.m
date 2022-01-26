% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907


%% collect data
clc
close all;
clear

greece = readtable("FullEodyData.xlsx");


week1 = [ "2020-W46" "2020-W47" "2020-W48" "2020-W49" "2020-W50" "2020-W51" "2020-W52" "2020-W53" "2021-W01"...
    "2021-W02" "2021-W03" "2021-W04" "2021-W05" "2021-W06" "2021-W07" "2021-W08" "2021-W09" "2021-W10" "2021-W11"...
    "2021-W12" "2021-W13" "2021-W14" "2021-W15" "2021-W16"];
week2 = [ "2020-W17" "2020-W18" "2020-W19" "2020-W20" "2020-W21" "2020-W22" "2020-W23" "2020-W24" "2021-W25"...
    "2021-W26" "2021-W27" "2021-W28"];


%236-403 are the rows of data corresponding to the weeks of the first
%period. Because there is no row for daily tests, we calculate them as
%follows: Daily tests = Total tests the day before - Total tests the current day.
%So we need to get one extra day in our data in order to be able to
%calculate the test for the first day.

% pcr_daily1 = zeros((length(pcr_tests1)-1),1);
% pcr_daily2 = zeros((length(pcr_tests2)-1),1);
% 
% 
% for i = 2:length(pcr_tests1)
%     pcr_daily1(i-1) = pcr_tests1(i)-pcr_tests1(i-1);
% end
% 
% for i = 2:length(pcr_tests2)
%     pcr_daily2(i-1) = pcr_tests2(i)-pcr_tests2(i-1);
% end
% 
% rapid_tests1 = greece.Rapid_Tests(235:403);
% rapid_tests2 = greece.Rapid_Tests(402:486);
% rapid_daily1 = zeros((length(rapid_tests1)-1),1);
% rapid_daily2 = zeros((length(rapid_tests2)-1),1);
% for i = 2:length(rapid_tests1)
%     rapid_daily1(i-1) = rapid_tests1(i)-rapid_tests1(i-1);
% end
% 
% for i = 2:length(rapid_tests2)
%     rapid_daily2(i-1) = rapid_tests2(i)-rapid_tests2(i-1);
% end
% 
% tests_daily1 = rapid_daily1+pcr_daily1;
% tests_daily2 = rapid_daily2+pcr_daily2;
% 
% 
% daily_cases1 = greece.NewCases(236:403);
% daily_cases2 = greece.NewCases(403:486);
% 
% daily_positivity1 = daily_cases1./tests_daily1;
% daily_positivity2 = daily_cases2./tests_daily2;

%since we need to collect daily deaths on a n*7 matrix (where n are the
%weeks we examine and 7 the days of each week), we initialize a 1*7 matrix
%as shown below, and we add the remaining data on its rows. After we have
%collected the data, we delete the first row.

%Data for first period.
greece_deaths1 = zeros(1,7);
pcr_tests1 = zeros(1,7);
rapid_tests1 = zeros(1,7);

for i = 1:length(week1)
    greece_week1 = greece(contains(greece.Week , week1(i)),:);
    greece_deaths1 = [greece_deaths1;greece_week1.New_Deaths'];
    pcr_tests1 = [pcr_tests1; greece_week1.PCR_Tests'];
    rapid_tests1 = [rapid_tests1; greece_week1.Rapid_Tests'];
end

%Remove row with zeros only.
greece_deaths1(1,:) = [];
greece_deaths1 = reshape(greece_deaths1,1,[]);

pcr_tests1 = reshape(pcr_tests1,1,[]);
rapid_tests1 = reshape(rapid_tests1,1,[]);

%Get the last element of 2020-W45 in order to be able to calculate the
%daily tests.
pcr_tests1(1) = greece.PCR_Tests(234);
rapid_tests1(1) = greece.Rapid_Tests(234);

pcr_tests1 = pcr_tests1(pcr_tests1~=0); %Remove zeros
rapid_tests1 = rapid_tests1(rapid_tests1~=0);

rapid_daily1 = zeros((length(rapid_tests1)-1),1);
rapid_daily2 = zeros((length(rapid_tests2)-1),1);
for i = 2:length(rapid_tests1)
    rapid_daily1(i-1) = rapid_tests1(i)-rapid_tests1(i-1);
end

%Data for second period.
greece_deaths2 = zeros(1,7);
pcr_tests2 = zeros(1,7);
rapid_tests2 = zeros(1,7);

for i = 1:length(week2)
    greece_week2 = greece(contains(greece.Week , week2(i)),:);
    greece_deaths2 = [greece_deaths2;greece_week2.New_Deaths'];
    pcr_tests2 = [pcr_tests2; greece_week2.PCR_Tests'];
    rapid_tests2 = [rapid_tests2; greece_week2.Rapid_Tests'];
end

%Remove row with zeros only.
greece_deaths2(1,:) = [];
greece_deaths2 = reshape(greece_deaths2,1,[]);

pcr_tests2 = reshape(pcr_tests2,1,[]);
rapid_tests2 = reshape(rapid_tests2,1,[]);

%Get the last element of 2020-W45 in order to be able to calculate the
%daily tests.
pcr_tests2(1) = greece.PCR_Tests(234);
rapid_tests2(1) = greece.Rapid_Tests(234);

pcr_tests2 = pcr_tests2(pcr_tests2~=0); %Remove zeros
rapid_tests2 = rapid_tests2(rapid_tests2~=0);
% 
% %in order to use regress model from MATLAB we need our X values rows to
% %match our Y values columns. To do so we use reshape() function, to rearange
% %matrice's dimensions.
% 
% days_back = [1,2,3,6,7,12,14,21,28];
% 
% r_squared1 = zeros(length(days_back),1);
% 
% for i = days_back
%     daily_positivity1 = reshape(daily_positivity1,(numel(daily_positivity1)/i),[]);
%     j = i;
%     k = 1;
%     daily_deaths_for_model = [];
%     while j <= numel(greece_deaths1)
%         daily_deaths_for_model(k) = greece_deaths1(j);
%         k = k+1;
%         j = j+i;
%     end
%     [~,~,~,~,stats] = regress(daily_deaths_for_model',[ones(size(daily_positivity1)) daily_positivity1])
%     r_squared1(i) = stats(1);
% end
% 
% r_squared1 = r_squared1(r_squared1~=0)
% 
% r_squared2 = zeros(length(days_back),1);
% 
% for i = days_back
%     daily_positivity2 = reshape(daily_positivity2,(numel(daily_positivity2)/i),[]);
%     j = i;
%     k = 1;
%     daily_deaths_for_model = [];
%     while j <= numel(greece_deaths2)
%         daily_deaths_for_model(k) = greece_deaths2(j);
%         k = k+1;
%         j = j+i;
%     end
%     [~,~,~,~,stats] = regress(daily_deaths_for_model',[ones(size(daily_positivity2)) daily_positivity2])
%     r_squared2(i) = stats(1);
% end
% 
% r_squared2 = r_squared2(r_squared2~=0)


%We changed the length of the first period to 6 months because for 3
%months we do not have enough data to calculate the regression for many
%days back. In the 6 month period, we can calculate the R squared for up
%untill 12 days back, and we can see that it is strongly correlated. In the
%3 month period we can calculate the R squared for up untill 7 days back,
%and the correlation is weak.
