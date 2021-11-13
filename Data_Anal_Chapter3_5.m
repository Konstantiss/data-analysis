erruptionData = readmatrix("erruption.txt");

waitingTime1989 = erruptionData(:,1);
duration1989 = erruptionData(:,2);
waitingTime2006 = erruptionData(:,3);

%First question:
ciStdWaitingTime1989(1,1) = sqrt(((length(waitingTime1989)-1) * var(waitingTime1989)) / chi2inv(0.975, length(waitingTime1989)-1));
ciStdWaitingTime1989(2,1) = sqrt(((length(waitingTime1989) - 1) * var(waitingTime1989)) / chi2inv(0.025, length(waitingTime1989)-1));
hWaitingTime1989 = vartest(waitingTime1989, 100);

ciStdDuration1989(1,1) = sqrt(((length(duration1989)-1) * var(duration1989)) / chi2inv(0.975, length(duration1989)-1));
ciStdDuration1989(2,1) = sqrt(((length(duration1989) - 1) * var(duration1989)) / chi2inv(0.025, length(duration1989)-1));
hDuration1989 = vartest(duration1989, 100);

ciStdWaitingTime2006(1,1) = sqrt(((length(waitingTime2006)-1) * var(waitingTime2006)) / chi2inv(0.975, length(waitingTime2006)-1));
ciStdWaitingTime2006(2,1) = sqrt(((length(waitingTime2006) - 1) * var(waitingTime2006)) / chi2inv(0.025, length(waitingTime2006)-1));
hWaitingTime2006 = vartest(waitingTime2006, 100);

%Second question:
ciMeanWaitingTime1989 = ttest(waitingTime1989);
hMeanWaitingTime1989 = ttest(waitingTime1989, 75);

ciMeanDuration1989 = ttest(duration1989);
hMeanDuration1989 = ttest(duration1989, 2.5);

ciMeanWaitingTime2006 = ttest(waitingTime2006); 
hMeanWaitingTime2006 = ttest(waitingTime2006);

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

[hMeanShortWaitingTime,pMeanShortWaitingTime,ciMeanShortWaitingTime,statsMeanShortWaitingTime] = ttest(shortWatingTime(:,1),65);
hVarShortWaitingTime = vartest(shortWaitingTime, 100);

[hMeanLongtWaitingTime,pMeanLongWaitingTime,ciMeanLongWaitingTime,statsMeanLongWaitingTime] = ttest(longWatingTime(:,1),91);
hVarLongWaitingtime = vartest(longWaitingTime, 100);
