clc
clear

length = 500;
width = 300;
s = 5;

% Question 1:

sSurf = sqrt((s * width)^2 + (s * length)^2);

% Question 2:
n = 100;
lengths = 1:1:n;
widths = 1:1:n;
S = zeros(n);

for i=1:n
    for j=1:n
       S(i,j) =  sqrt((s * widths(i))^2 + (s * lengths(j))^2);
    end
end

surf(lengths,widths,S);
