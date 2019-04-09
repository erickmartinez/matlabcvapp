%Convert Function from Desired Temperature Thermocouple to Hotplate Set Temperature Based on Calibration Fit
function Tnew = CorrectT_ext(app,T,MUnb)

switch MUnb
    % Calibration for hotplate number 1
    case 1
        a1 = 0.00112759470035273;
        a2 = 0.820085915455346;
        b = 11.0122612663442;
        Tnew = a1*T^2+a2*T+b;
        % Calibration 4/5/2019
        %                 a1,a2,b
        % [0.00112759470035273,0.820085915455346,11.0122612663442]
        
    % Calibration for hotplate number 2
    case 2
        a1 = 0.001240094001752;
        a2 = 0.938131307698908;
        b = 8.511123118723250;
        Tnew = a1*T^2+a2*T+b; %Calibration fit determines how to set hotplate to get desired thermocouple temperature to within +/- 1C
        
    % Calibration for hotplate number 3
    case 3
        a1 = 0.000287543659539014;
        a2 = 0.867801163146551;
        b = 13.2453441588129;
        Tnew = a1*T^2+a2*T+b;
        % Calibration 4/5/2019
        %                 a1,a2,b
        %                 0.000287543659539014	0.867801163146551	13.2453441588129
    otherwise
        error('Wrong hotplate number entered');
end