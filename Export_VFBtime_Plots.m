function Export_VFBtime_Plots(app,MD)
% ExportVFBtime_1Pushed_ext
% Exports all the Vfb vs time plots
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
% MD : struct
%   A data structure containing all measurement data
%
% Generate sample data to test:
% x = linspace(0,3600,20);
% tfb = zeros(20,10);
% vfb = zeros(20,10);
% for i=1:10 tfb(:,i) = x; vfb(:,i) = exp(-(x-0.1*(i-1))/100)+0.1*i; end
% pinStates = ones(8);
% stressTemp = 40;
% stressBias = 3;
% for i=1:3 MD(i).PinState = pinStates(i,:); MD(i).ExpData.Setup.StressBiasValue = stressBias; MD(i).ExpData.Setup.TempH = stressTemp; MD(i).ExpData.Setup.biastime_sec=600; for j=1:10 MD(i).ExpData.Pin(j).VfbAve=vfb(:,j); MD(i).ExpData.Pin(j).tfb = tfb(:,j); end; end
% app.FileLoc.Value = pwd;

    markers = ["o","s","d","^","v",">","<","p","h"];
    legendLabels = "Pin " + (1:8);
    % Iterate over all the measurement units
    for k=1:3
        % Get the pin states for the current unit
        pinStates   = MD(k).PinState;
        % Get the value of the stress bias
        stressBias  = MD(k).ExpData.Setup.StressBiasValue;
        % Get the value of the stress temperature
        stressTemp  = MD(k).ExpData.Setup.TempH;
        
        
        % Get the number of lines to be plotted
        % Get a colormap for the dataset
        c = flipud(jet(8));
        colormap(c);

        % Create the VFB figure
        figureVFBtime        = figure;%('visible','off'); 
        set(gca, 'FontSize',14)
        hold on
        % Iterate over all the pin states
        for q = 1:8 % Gets the number of CV plots
            % If the pin is conneted plot the results
            if pinStates(q)
                % Get the bias voltage and capacitance values for the selected
                % measurement unit
                t   = MD(k).ExpData.Pin(q).tfb./3600;
                Vfb = MD(k).ExpData.Pin(q).VfbAve;
                
                % Plot the results in two different figures to avoid having 8
                % subplots in the same figure.
                % plot each line with the color defined previously
                plot(t,Vfb,'Color',c(q,:),'LineWidth',2,'Marker',markers(q));
            end % if pinStates(q) ends 
        end % q = 1:totalPlots ends
        hold off
        % Add labels
        title( "Flatband Voltage vs. Time");
        xlabel('Time (hr)');
        ylabel('V_{fb} (V)');
        leg = legend(legendLabels,'Location','northeast');
        legend('boxoff');
        box on
        info_str = sprintf("Bias = %.1f V\nT = %.1f �C",...
            stressBias,...
            stressTemp);
        info_txt = text(0.1,0.95,info_str,...
            'Units','normalized',...
            'HorizontalAlignment','left',...
            'VerticalAlignment','top');
        info_txt.Color  = 'k';
        info_txt.FontSize = 12;
        
        % Get the working directory from the GUI
        wd = app.FileLoc.Value;
        % Get the time stamp to add to the filetag
        tstamp = TimeStamp;
        % Construct the file tag
        filetag = "Figure_MU"+k+"_VFBTime" + tstamp;
        
        % Save the plot as .fig and as .jpeg
        try
            savefig(figureVFBtime,fullfile(wd,strcat(filetag,'.fig')));
            print(figureVFBtime,fullfile(wd,strcat(filetag,'.jpg')),'-djpeg','-r300');
        catch e
            display(e.message);
        end % try catch ends
    end % k=1:3 ends 
end