% Konstantinos Michopoulos, webmail: michopoul@ece.auth.gr, AEM: 9839
% Georgios Skiadas, webmail: skiadasg@ece.auth.gr, AEM: 9907

clc
close all;
clear

M = 1000;
%Get necessary data.
[bestCountryIds, positivityRatesBestCountries, positivityRatesGreece] = Group19Exe6Fun1();

weeklyPositivityRatesGreeceCroatia = [positivityRatesGreece' positivityRatesBestCountries(1,:)'];
weeklyPositivityRatesGreeceCzechia = [positivityRatesGreece' positivityRatesBestCountries(2,:)'];

%Resample data. Because we want the correlation coefficient of the array,
%we resample it this unconventional way in order to maintain two columns.
% temp = weeklyPositivityRatesGreeceCroatia(:,1);
% [~,bootsam] = bootstrp(M,[],temp);
% bootsam = reshape(bootsam, length(bootsam), []);
% temp2 = temp(bootsam);
% weeklyPositivityRatesGreeceCroatiaResampled(:,1) = temp2(:,1);
% temp = weeklyPositivityRatesGreeceCroatia(:,2);
% [~,bootsam] = bootstrp(M,[],temp);
% bootsam = reshape(bootsam, length(bootsam), []);
% temp2 = temp(bootsam);
% weeklyPositivityRatesGreeceCroatiaResampled(:,2) = temp2(:,2);
% corrcoef(weeklyPositivityRatesGreeceCroatiaResampled)
[~,bootsam] = bootstrp(M,[],weeklyPositivityRatesGreeceCroatia);
bootsam = reshape(bootsam, length(bootsam), []);
weeklyPositivityRatesGreeceCroatiaResampled = weeklyPositivityRatesGreeceCroatia(bootsam);
corrcoef(weeklyPositivityRatesGreeceCroatiaResampled)

[~,bootsam] = bootstrp(M,[],weeklyPositivityRatesGreeceCzechia);
bootsam = reshape(bootsam, length(bootsam), []);
weeklyPositivityRatesGreeceCzechiaResampled = weeklyPositivityRatesGreeceCzechia(bootsam);

% temp = weeklyPositivityRatesGreeceCzechia(:,1);
% [~,bootsam] = bootstrp(M,[],temp);
% bootsam = reshape(bootsam, length(bootsam), []);
% temp2 = temp(bootsam);
% weeklyPositivityRatesGreeceCzechiaResampled(:,1) = temp2(:,1);
% temp = weeklyPositivityRatesGreeceCzechia(:,2);
% [~,bootsam] = bootstrp(M,[],temp);
% bootsam = reshape(bootsam, length(bootsam), []);
% temp2 = temp(bootsam);
% weeklyPositivityRatesGreeceCzechiaResampled(:,2) = temp2(:,2);
corrcoef(weeklyPositivityRatesGreeceCzechiaResampled)


