clc 
clear

M = 1000;
n = 20;
mu = [0 0];
sigmaX = 1;
sigmaY = 1;
pDesired = [0 0.5];
sigma1 = [sigmaX^2 pDesired(1)*sigmaX*sigmaY; pDesired(1)*sigmaX*sigmaY sigmaY^2]; 
sigma2 = [sigmaX^2 pDesired(2)*sigmaX*sigmaY; pDesired(2)*sigmaX*sigmaY sigmaY^2];
sigmas(:,:,1) = sigma1;
sigmas(:,:,2) = sigma2;
sample = zeros(1,n);
r = zeros(M, 1);
sampleSquared = 0; % change this to 1 for question 4.

%Question 1:

for i=1:M
    for j=1:2
        sample = mvnrnd(mu, sigmas(:,:,j), n);
        if sampleSquared == 1
            sample = sample.^2;
        end
        corrCoefArray = corrcoef(sample);
        r(i) = corrCoefArray(1,2);
    end
end

z = 0.5*log((1+r)./(1-r));
zCritical = norminv(1- 0.05/2);
lowerBounds = z - zCritical.*(sqrt(1/(n-3)));
upperBounds = z + zCritical.*(sqrt(1/(n-3)));

 figure(1)
 histogram(lowerBounds)
 hold on 
 histogram(upperBounds)
 hold off

%Question 2:

t = r.*sqrt((n-2)./(1-r.^2));
tCritical = tinv(1-0.05/2,n-2); 

tLower = t - tCritical;
tUpper = t + tCritical;

counters = zeros(1,2);

for i=1:M
   for j=1:2
      if pDesired(j)<tUpper(i) && pDesired(j)>tLower(i)
        counters(1,j) = counters(1,j) + 1;
      end
    end
end

percentage1 = counters(1,1) / M %p = 0
percentage2 = counters(1,2) / M % p = 0.5

%Question 3:

% Both percentages drop to zero.

%Question 4:

% Both percentages increase by about 40-50%.

