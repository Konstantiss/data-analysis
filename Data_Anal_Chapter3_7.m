X = rand(10,100);

%First question:
[hX,pX,ciX,statsX] = ttest(X);

ciBootX = bootci(100,@mean,X);

%Second question:
Y = X.^2;
[hY,pY,ciY,statsY] = ttest(Y);

ciBootY = bootci(100,@mean,Y);