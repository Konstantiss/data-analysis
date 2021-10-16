uniformNumbers = unifrnd(1, 2, 1, 10000)
mean(uniformNumbers)
mean(1 ./ uniformNumbers)
ns = 10:10:500
means1 = zeros(1, length(ns))
means2 = zeros(1, length(ns))
for i= 1:length(ns)
   uniformNumbers = unifrnd(1, 2, 1, ns(i)) 
   means1(i) = 1 / mean(uniformNumbers)
   means2(i) = mean(1 ./ uniformNumbers)
end

barArray = [means1; means2]
bar(ns, barArray)
xlabel('n')
ylabel('Blue: 1 / E[x], Orange: E[1/x]')