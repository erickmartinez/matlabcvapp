function [timeUnit,factor] = adjustTimeUnits(t)
% adjustTimeUnits 
% For a time interval in seconds determines the best units (according to my
% personal choice :P) to display the time. It also returns a factor to
% convert to the corresponding units.
%
% Rules:
% ------
% 1. If the t <= 10 min, display s
% 2. Else, if 10 < t <= 2 hr, display minutes
% 3. Else, if 2hr < t display hr
% 
% Parameters
% ----------
% t : int or float
%   The time interval in seconds
%
% Returns
% -------
% timeUnit : str
%   The time unit: s, min, hr, day
% factor : int
%   The factor to divide the input time to get the time in the chosen unit
    factor = 1;
    if t <= 600 % ten minutes
        factor = 1;
        timeUnit        = "s";
    elseif 600 < t & t <= 7200 % 2 hours
        factor = 60;
        timeUnit        = "min";
    elseif 7200 < t
        factor = 3600;
        timeUnit        = "hr";
    end
end

