mu = [5 6];
Sigma = [2 2.5; 2.5 4];
R = mvnrnd(mu,Sigma,1000);
plot(R(:,1),R(:,2),'+')
var(R(:,1) + R(:,2)) == var(R(:,1)) + var(R(:,2))