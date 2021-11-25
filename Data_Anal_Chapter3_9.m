clc
clear

n = 10;
M = 100;
m = 12;
mu = 0;
B = 1000;
a = 0.05;
sigma = 1;
nbins= 20;

X = normrnd(mu,sigma,M,n);

Y = normrnd(mu,sigma,M,m);

cis = NaN(M,2);
ciBootstrap = NaN(M,2); 

lowerLimit = (B+1)*(a/2);
upperLimit = (B+1 - lowerLimit); 
limits = floor([lowerLimit,upperLimit]);



%First question:

%i:
for i=1:M
    %i:
    [h,p,ci,stats] = ttest2(X(i,:),Y(i,:));
    cis(i,1) = ci(1);
    cis(i,2) = ci(2);
    %ii:
    bootstrapMeanX = bootstrp(B,@mean,X(i,:));
    bootstrapMeanY = bootstrp(B,@mean,Y(i,:)); 
    difference = bootstrapMeanX - bootstrapMeanY;
    difference = sort(difference);
    ciBootstrap(i,:) = difference(limits);
end

figure(1)
clf;
histfit(cis(:,1),nbins);
hold on
histfit(cis(:,2),nbins);
legend('lower limit','', 'uper limit','')

figure(2)
clf;
histfit(ciBootstrap(:,1),nbins);
hold on
histfit(ciBootstrap(:,2),nbins);
legend('lower limit','', 'uper limit','')

%Second question:

X2 = X.^2;
Y2 = Y.^2;
cis2 = NaN(M,2);
ciBootstrap2 = NaN(M,2); 


for i=1:M
    %i:
    [h,p,ci,stats] = ttest2(X2(i,:),Y2(i,:));
    cis2(i,1) = ci(1);
    cis2(i,2) = ci(2);
    %ii:
    bootstrapMeanX = bootstrp(B,@mean,X2(i,:));
    bootstrapMeanY = bootstrp(B,@mean,Y2(i,:)); 
    difference = bootstrapMeanX - bootstrapMeanY;
    difference = sort(difference);
    ciBootstrap2(i,:) = difference(limits);
end

figure(3)
clf;
histfit(cis2(:,1),nbins);
hold on
histfit(cis2(:,2),nbins);
legend('lower limit','', 'uper limit','')

figure(4)
clf;
histfit(ciBootstrap2(:,1),nbins);
hold on
histfit(ciBootstrap2(:,2),nbins);
legend('lower limit','', 'uper limit','')

%Third question:

Y = normrnd(0.2,1,M,m);
cis3 = NaN(M,2);
ciBootstrap3 = NaN(M,2); 


for i=1:M
    %i:
    [h,p,ci,stats] = ttest2(X(i,:),Y(i,:));
    cis3(i,1) = ci(1);
    cis3(i,2) = ci(2);
    %ii:
    bootstrapMeanX = bootstrp(B,@mean,X(i,:));
    bootstrapMeanY = bootstrp(B,@mean,Y(i,:)); 
    difference = bootstrapMeanX - bootstrapMeanY;
    difference = sort(difference);
    ciBootstrap3(i,:) = difference(limits);
end

figure(5)
clf;
histfit(cis3(:,1),nbins);
hold on
histfit(cis3(:,2),nbins);
legend('lower limit','', 'uper limit','')

figure(6)
clf;
histfit(ciBootstrap3(:,1),nbins);
hold on
histfit(ciBootstrap3(:,2),nbins);
legend('lower limit','', 'uper limit','')
