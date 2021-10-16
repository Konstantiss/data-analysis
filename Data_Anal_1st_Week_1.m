
ns = 10:50:1000
tailsPercentages = zeros(1, length(ns))
for i= 1:length(ns)
    heads = zeros(1, length(ns))
    tails = zeros(1, length(ns))
    for j = 1:ns(i)
       temp = rand
       if temp > 0.5
           tails(j) = temp
       else
           heads(j) = temp
       end
    end
    heads = heads(heads~=0)
    tails = tails(tails~=0)
    tailsPercentages(i) = (length(tails) / ns(i)) * 100
end
bar(ns, tailsPercentages)
xlabel('Number of attempts')
ylabel('Tails percentage')

