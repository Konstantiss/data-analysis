clc
clear

erruptionData = readmatrix("erruption.txt");

waitingTime1989 = erruptionData(:,1);
duration1989 = erruptionData(:,2);
waitingTime2006 = erruptionData(:,3);

%First question:
[hWaitingTime1989,pWaitingTime1989,ciWaitingTime1989,statsWaitingTime1989] = vartest(waitingTime1989, 10); %10 is given randomly as an argument in order to get the real ci
ciStdWaitingTime1989 = sqrt(ciWaitingTime1989);
hWaitingTime1989 = vartest(waitingTime1989, 100);

[hDuration1989,pDuration1989,ciDuration1989,statsDuration1989] = vartest(duration1989, 10);
ciStdDuration1989 = sqrt(ciDuration1989);
hDuration1989 = vartest(duration1989, 1);

[hWaitingTime2006,pWaitingTime2006,ciWaitingTime2006,statsWaitingTime2006] = vartest(waitingTime2006, 10);
ciStdWaitingTime2006 = sqrt(ciWaitingTime2006);
hWaitingTime2006 = vartest(waitingTime2006, 100);

%Second question:
[hMeanWaitingTime1989,pMeanWaitingTime1989,ciMeanWaitingTime1989,statsMeanWaitingTime1989] = ttest(waitingTime1989,75);

[hMeanDuration1989,pMeanDuration1989,ciMeanDuration1989,statsMeanDuration1989] = ttest(duration1989,2.5);

[hMeanWaitingTime2006,pMeanWaitingTime2006,ciMeanWaitingTime2006,statsMeanWaitingTime2006] = ttest(waitingTime2006,75);

%Third question:
[hChiWaitingTime1989,pChiWaitingTime1989] = chi2gof(waitingTime1989);

[hChiDuration1989,pChiDuration1989] = chi2gof(duration1989);

[hChiWaitingTime2006,pChiWaitingTime2006] = chi2gof(waitingTime2006);
j = 1;
k = 1;

for i=1:1:298
   if duration1989(i) < 2.5
       shortWaitingTime(j,1) = waitingTime1989(i);
       j = j + 1;
   else
       longWaitingTime(k,1) = waitingTime1989(i);
       k = k + 1;
   end
end

[hMeanShortWaitingTime,pMeanShortWaitingTime,ciMeanShortWaitingTime,statsMeanShortWaitingTime] = ttest(shortWaitingTime(:,1),65);
hVarShortWaitingTime = vartest(shortWaitingTime, 100);

[hMeanLongtWaitingTime,pMeanLongWaitingTime,ciMeanLongWaitingTime,statsMeanLongWaitingTime] = ttest(longWaitingTime(:,1),91);
hVarLongWaitingtime = vartest(longWaitingTime, 100);
