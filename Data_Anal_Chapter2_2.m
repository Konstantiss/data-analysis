clc
clear

n = 1000
l = 1 %lambda
x = rand(n, 1)
y = -(1 / l) * log(1 - x)
histfit(y, 50, 'exponential')
