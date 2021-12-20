clc 
clear

data = [1 2 98.2; 2 3 91.7; 3 8 81.3; 4 16 64.0; 5 32 36.4; 6 48 32.6; 7 64 17.1; 8 80 11.3];

distance = data(:,2);
usability = data(:,3);

% A
% Data Scatterplot
figure(50)
scatter(distance,usability)

% Functions
inverse = @(b,x)( b(1) + b(2)./x);
logarithmic = @(b,x)( b(1)+b(2)*log(x));
exponential = @(b,x)( b(1)*exp(b(2)*x) );
power = @(b,x)( b(1)*x.^(b(2)) );

functions = {inverse ; logarithmic; exponential; power};
functionNames = ["Inverse" ; "Logarithmic"; "Exponential"; "Power"];
mse = zeros(length(functions),1);

for i = 1:length(functions)
    % Calculate non linear regression model
    beta0 = [13 ; -0.2];
    model = fitnlm(distance,usability,functions{i},beta0);
    mse(i) = model.MSE;
    
    beta = table2array(model.Coefficients);
    beta = beta(:,1);
    pred = functions{i}(beta,distance);
    
    % Plot data and regression
    figure(i)
    scatter(distance,usability)
    hold on;
    plot(distance,pred)
    title(strcat(functionNames(i)," regression"));
    
    % B
    x0 = 25;
    prediction = functions{i}(beta,x0);
    hold on;
    plot(x0,prediction,'x','MarkerEdgeColor','k','MarkerSize',5);

    
    % Diagnostic plot of standardised error
    standardisedError = (usability - pred)/sqrt(mse(i));
    figure(i*10)
    scatter(usability,standardisedError);
    hold on;
    yline(2, 'r');
    hold on;
    yline(0, 'g');
    hold on;
    yline(-2, 'b');
    title(strcat(functionNames(i)," regression standardised error"));
end