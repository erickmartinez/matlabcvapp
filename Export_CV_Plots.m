function Export_CV_Plots(app,MD)
% Export_CV_Plots
% Exports all the CV plots
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
% MD : struct
%   A data structure containing all measurement data
%
% Generate sample data to test:
% x = linspace(-pi,pi,20);
% V = zeros(20,10);
% C = zeros(20,10);
% for i=1:10 V(:,i) = x; C(:,i) = sin(x+0.1*(i-1)); end
% pinStates = ones(8);
% stressTemp = 40;
% stressBias = 3;
% cvPlots = 1:8;
% for i=1:3 MD(i).PinState = pinStates(i,:); MD(i).ExpData.Setup.StressBiasValue = stressBias; MD(i).ExpData.Setup.TempH = stressTemp; MD(i).Plots.CV=cvPlots; MD(i).ExpData.Setup.biastime_sec=600; for j=1:10 MD(i).ExpData.Pin(j).V=V; MD(i).ExpData.Pin(j).C = C; end; end
% app.FileLoc.Value = pwd;

    % Clear all figures
%     clf; shg;

    % Iterate over all the measurement units
    for k=1:3
        % Get the pin states for the current unit
        pinStates   = MD(k).PinState;
        % Get the value of the stress bias
        stressBias  = MD(k).ExpData.Setup.StressBiasValue;
        % Get the value of the stress temperature
        stressTemp  = MD(k).ExpData.Setup.TempH;
        % Get the stress time in seconds
        dt          = MD(k).ExpData.Setup.biastime_sec;

        % Get the total number of plots
        rows = 2; % The number of rows for subplots
        cols = 2; % The number of cols for subplots

        % Create the CV figure
        figureCV1        = figure;%('visible','off'); 
        set(gca, 'FontSize',14)
        figureCV2        = figure;%('visible','off'); 
        set(gca, 'FontSize',14)

        hold
        % Iterate over all the pin states
        for q = 1:8 % Gets the number of CV plots
            % If the pin is conneted plot the results
            if pinStates(q)
                % Get the bias voltage and capacitance values for the selected
                % measurement unit
                V = MD(k).ExpData.Pin(q).V;
                C = (MD(k).ExpData.Pin(q).C).*1e12;

                % Get the number of lines to be plotted
                nLines = size(V,2);
                % Get a colormap for the dataset
                c = flipud(hot(nLines));
                colormap(c);
                % Get the time at each CV plot
                stressTime = (1:nLines).*(dt/3600); 
                % Plot the results in two different figures to avoid having 8
                % subplots in the same figure.
                if q <= 4
                    % Select the subplot
                    set(0,'CurrentFigure',figureCV1);
                    subplot(rows,cols,mod(q,5));
                    % plot each line with the color defined previously
                    hold('on');
                    for i=1:nLines
                        plot(V(:,i),C(:,i),'Color',c(i,:),'LineWidth',2);
                    end
                    hold('off');
                    % Get a colorbar
                    hc = colorbar();
                    cbTicks = linspace(0,1,5);
                    cbTicklLabels = linspace(0,max(stressTime),5);
                    hc.Label.String = 'Time (hr)';
                    % If the tick strings are two long, format with just
                    % one decimal point
                    TL=arrayfun(@(x) sprintf('%.1f',x),cbTicklLabels,'un',0);
                    if max(stressTime) > 10
                        set(hc, 'YTick',cbTicks, 'YTickLabel',cbTicklLabels);
                    else
                        set(hc, 'YTick',cbTicks, 'YTickLabel',TL);
                    end
                    % Add labels
                    title( "Pin "+q);
                    xlabel('Voltage (V)');
                    ylabel('Capacitance (pF)');
                    % Ad information text
                    info_str = sprintf("Bias = %.1f V\nT = %.1f °C",...
                        stressBias,...
                        stressTemp);
                    info_txt = text(0.05,0.95,info_str,...
                        'Units','normalized',...
                        'HorizontalAlignment','left',...
                        'VerticalAlignment','top');
                    info_txt.Color    = 'k';
                    info_txt.FontSize = 8;
                else
                    % Select the subplot
                    set(0,'CurrentFigure',figureCV2);
                    subplot(rows,cols,mod(q,5)+1);
                    % plot each line with the color defined previously
                    hold('on');
                    for i=1:nLines
                        plot(V(:,i),C(:,i),'Color',c(i,:),'LineWidth',2);
                    end
                    hold('off');
                    % Get a colorbar
                    hc = colorbar();
                    cbTicks = linspace(0,1,5);
                    cbTicklLabels = linspace(0,max(stressTime),5);
                    hc.Label.String = 'Time (hr)';
                    TL=arrayfun(@(x) sprintf('%.1f',x),cbTicklLabels,'un',0);
                    if max(stressTime) > 10
                        set(hc, 'YTick',cbTicks, 'YTickLabel',cbTicklLabels);
                    else
                        set(hc, 'YTick',cbTicks, 'YTickLabel',TL);
                    end
                    % Add labels
                    title( "Pin "+q);
                    xlabel('Voltage (V)');
                    ylabel('Capacitance (pF)');
                    info_str = sprintf("Bias = %.1f V\nT = %.1f °C",...
                        stressBias,...
                        stressTemp);
                    info_txt = text(0.05,0.95,info_str,...
                        'Units','normalized',...
                        'HorizontalAlignment','left',...
                        'VerticalAlignment','top');
                    info_txt.Color    = 'k';
                    info_txt.FontSize = 8;
                    box on
                end
            end % pinStates(q) ends 
        end % q = 1:totalPlots ends

        % Get the working directory from the GUI
        wd = app.FileLoc.Value;
        % Get a timestamp to add to the file tags
        tstamp = TimeStamp;
        % Construct file tags
        filetag1 = "Figure_MU"+k+"_CV1" + tstamp;
        filetag2 = "Figure_MU"+k+"_CV2" + tstamp;
        %Save the figures as .fig and .jpeg
        try
            savefig(figureCV1,fullfile(wd,strcat(filetag1,'.fig')));
            savefig(figureCV2,fullfile(wd,strcat(filetag2,'.fig')));
            print(figureCV1,fullfile(wd,strcat(filetag1,'.jpg')),'-djpeg','-r300');
            print(figureCV2,fullfile(wd,strcat(filetag2,'.jpg')),'-djpeg','-r300');
        catch e
            display(e.message);
        end % try catch ends
    end % k=1:3 ends 
end