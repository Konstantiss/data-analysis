function difference = Group19Exe3Fun1(dailyPositivityRatesGreece, weeklyPositivityRateEurope)
    ci = bootci(1000,@mean,dailyPositivityRatesGreece);
    
    if weeklyPositivityRateEurope > ci(1)
       if weeklyPositivityRateEurope < ci(2)
          difference = 0; 
       else
          difference = weeklyPositivityRateEurope - ci(2);
       end
    elseif weeklyPositivityRateEurope < ci(2)
        if weeklyPositivityRateEurope > ci(1)
            difference = 0;
        else
          difference = weeklyPositivityRateEurope - ci(1);
       end
    end
    
end