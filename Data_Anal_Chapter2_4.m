n = 300
a = 1
b = 2
means = zeros(n, 2);
for i = 1:n
    uniformNumbers = unifrnd(a, b, 1, i);
    means(i, 1) = 1 / mean(uniformNumbers);
    means(i, 2) = mean(1 ./ uniformNumbers);
end
plot(means)


