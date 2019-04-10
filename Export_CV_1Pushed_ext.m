function Export_CV_1Pushed_ext(app)
% Export_CV_1Pushed_ext
% Exports all the CV plots
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object

% Clear all figures
clf; shg;

% Iterate over all the measurement units
for mu=1:3
    % Get the pin states for the current unit
    pinStates        = MD(mu).PinState;
    % Get the value of the stress bias
    stressBias      = MD(mu).ExpData.Setup.StressBiasValue;
    % Get the value of the stress temperature
    stressTemp      = MD(mu).ExpData.Setup.TempH;
    
    % Get the total number of plots
    totalPlots = length(app.MD(mu).Plots.CV);
    rows = 2; % The number of rows for subplots
    cols = 2; % The number of cols for subplots
    
    % Create the CV figure
    figureCV1        = figure('visible','off'); 
    haxCV1           = axes;
    figureCV2        = figure('visible','off'); 
    haxCV2           = axes;
    
    % Iterate over all the pin states
    for q = 1:totalPlots % Gets the number of CV plots
        % If the pin is conneted plot the results
        if pinStates(q)
            % Get the bias voltage and capacitance values for the selected
            % measurement unit
            V = MD(mu).ExpData.Pin(q).V;
            C = (app.MD(mu).ExpData.Pin(q).C).*1e12;
            % Get the number of lines to be plotted
            nLines = size(V,2);
            % Get a colormap for the dataset
            c = hot(nLines);
            % Plot the results in two different figures to avoid having 8
            % subplots in the same figure.
            if q <= 4
                % Selects the axis for the first CV figure
                cvax = haxCV1;
            else
                % Selects the axis of the second CV figure
                cvax = haxCV2;
            end
            % Select the subplot
            subplot(rows,cols,mod(q,4));
            % plot each line with the color defined previously
            for i=1:nLines
                plot(cvax,V(:,i),C(:,i),'Color',c(i,:),'LineWidth',2);
            end
            % Add labels
            title( cvax,"Capacitance vs. Voltage (Bias = "+stressBias+"V, T = "+stressTemp+" �C)");
            xlabel(cvax,'Voltage (V)');
            ylabel(cvax,'Capacitance (pF)');
        end % pinStates(q) ends 
        set(gca, 'FontSize',14)
    end % p = 1:length(PinState) ends
    
    
end % mu=1:3 ends 

try
    pinStates = [app.P1_1.Value, app.P2_1.Value, app.P3_1.Value, app.P4_1.Value];
    CVPlots = [app.CV1_1,app.CV2_1,app.CV3_1,app.CV4_1];
    ValidCVPlots = CVPlots(pinStates==1);
    for e1 = 1:length(CVPlots)
        if (pinStates(e1))
            MD=PlotCV(app,MD(MUnb).ExpData.Pin(q).C,MD(MUnb).ExpData.Pin(q).V,MD(MUnb).Plots.CV(q),MUnb); %Plot CV curve and temperature
            subplot(2,2,e1)
            hold on
            set(gca, 'ColorOrder', jet(app.Iter_tot_1.Value+1),'FontSize',14)
            colormap('jet');
            IterM_1 = app.IterM_1.Value;
            map = fliplr(hot(length(CVPlots(e1).Children)/IterM_1+2));
            t_off = tInSec(app, string(app.t_offset_unit_1.Value), app.TimeOffset_1.Value);
            TimeArray = t_off+(0:app.Iter_tot_1.Value).*app.dt_1.Value
            if (app.dt_1.Value == 0)
                lgn = "Iter: " + (0:app.Iter_tot_1.Value);
            else
                lgn = (TimeArray) + " " + string(app.t_inc_unit_1.Value);
            end
            h= [];
            for e2 =  (length(CVPlots(e1).Children)/IterM_1):-1:1
                x = [];
                y = [];
                ind = e2*IterM_1;
                for e3 = 0:1:IterM_1-1
                    x = [(CVPlots(e1).Children(ind-e3).XData)' x]
                    y = [(CVPlots(e1).Children(ind-e3).YData)' y]
                end
                htemp = plot(x,y,'LineWidth', 2,'Color',map(end-e2,:))
                h = [h, htemp(1)];
            end
            legend(h,lgn)
            title("Pin "+e1);
            xlabel(CVPlots(e1).XLabel.String);
            ylabel(CVPlots(e1).YLabel.String);
            hold off
        end
    end
end