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
        figureCV1        = figure();%('visible','off'); 
        haxCV1           = axes;
        figureCV2        = figure();%('visible','off'); 
        haxCV2           = axes;

        % Iterate over all the pin states
        for q = 1:totalPlots % Gets the number of CV plots
            % If the pin is conneted plot the results
            if pinStates(q)
                % Get the bias voltage and capacitance values for the selected
                % measurement unit
                V = MD(mu).ExpData.Pin(q).V;
                C = (app.MD(mu).ExpData.Pin(q).C).*1e12;
                dt = MD(mu).ExpData.Setup.biastime_sec;
                % Get the number of lines to be plotted
                nLines = size(V,2);
                % Get a colormap for the dataset
                c = hot(nLines);
                % Get the time at each CV plot
                stressTime = (1:nLines).*(dt/3600); 
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
                hold(cvax,'on');
                for i=1:nLines
                    plot(cvax,V(:,i),C(:,i),'Color',c(i,:),'LineWidth',2);
                end
                hold(cvax,'off');
                % Get a colorbar
                hc = colorbar;
                cb = linspace(0,max(stressTime),11);
                set(hc, 'YTick',cb, 'YTickLabel',cb);
                % Add labels
                title( cvax,"Pin "+q+" (Bias = "+stressBias+"V, T = "+stressTemp+" °C)");
                xlabel(cvax,'Voltage (V)');
                ylabel(cvax,'Capacitance (pF)');
                ylabel(hc, 'Time (hr)');
            end % pinStates(q) ends 
            set(gca, 'FontSize',14)
        end % p = 1:length(PinState) ends
        tstamp = TimeStamp;
        filetag1 = "Figure_MU"+mu+"_CV1" + tstamp;
        filetag2 = "Figure_MU"+mu+"_CV2" + tstamp;
        % TODO : get the save directory
        try
            savefig(haxCV1,strcat(filetag1,'.fig'));
            savefig(haxCV2,strcat(filetag2,'.fig'));
        catch e
            display(e.message);
        end
    end % mu=1:3 ends 
end