%Convert Function from Desired Temperature Thermocouple to Hotplate Set Temperature Based on Calibration Fit
        function Tnew = CorrectT_ext(app,T,MUnb)
            a1 = 0.001240094001752;
            a2 = 0.938131307698908;
            b = 8.511123118723250;
            Tnew = a1*T^2+a2*T+b; %Calibration fit determines how to set hotplate to get desired thermocouple temperature to within +/- 1C
        end