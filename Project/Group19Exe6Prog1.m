clear
clc

[positivityRateCountryA, positivityRateCountryB,positivityRateGreece] = Group19Exe6Fun1();

iterations = 100;
sampleAGreece = [positivityRateCountryA positivityRateGreece];
sampleBGreece = [positivityRateCountryB positivityRateGreece];

correlationMatrix = corrcoef(sampleAGreece,sampleBGreece);
corrCoef = correlationMatrix(1,2);

permutationCorrCoef = zeros(iterations,1);

for i = 1:iterations
    sampleAGreece = sampleAGreece(randperm(length(sampleAGreece)));
    tempCorrelationMatrix = corrcoef(sampleAGreece,sampleBGreece);
    permutationCorrCoef(i) = tempCorrelationMatrix(1,2);
end

coefficients = [permutationCorrCoef; corrCoef];
coefficients = sort(coefficients);

r_value = find(coefficients == corrCoef);
alpha = 5;

if r_value<(iterations+1)*(alpha/2) || r_value>(iterations+1)*(1-alpha/2)
    disp("Values are not following the same distribution"); 
end
