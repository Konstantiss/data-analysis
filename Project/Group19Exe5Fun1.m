function result = Group19Exe5Fun1(sampleX, sampleY, numberOfPermutations, correlationCoefficient)
    correlationCoefficientPermutated = zeros(1,numberOfPermutations);
    a = 0.05;

    for j=1:numberOfPermutations
        random = randperm(length(sampleX));
        sampleX = sampleX(random);
        corrCoefNew = corrcoef(sampleX, sampleY);
        correlationCoefficientPermutated(j) = corrCoefNew(1,2);
    end

    t0 = correlationCoefficient*sqrt((length(sampleX)-2)/(1-correlationCoefficient^2));
    t = correlationCoefficientPermutated.*sqrt((length(sampleX)-2)./(1-correlationCoefficientPermutated.^2));
    t = sort(t);
    tLower = t(numberOfPermutations * (a/2));
    tUpper = t(numberOfPermutations * (1 - a/2));

    if t0 < tUpper && t0 > tLower
        result = 1;
    else
        result = 0;
    end

end