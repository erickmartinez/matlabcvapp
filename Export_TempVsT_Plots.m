function Export_TempVsT_Plots(app,varargin)
% ExportAllIvTPlots_ext
% Exports all the Temp vs time plots
% The max total number of inputs is 2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called in CV_timeLoop.m (2 arguments: app and MD) and in the app when the export
% button is pressed (1 argument: app)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
% MD : struct
%   A data structure containing all measurement data

% Find whether MD should be pulled from the saved .mat file (case when the function is
% called from the export button) or from the MD structure (case when the
% function is called in CV_timeloop)
if(nargin==1) % MD is not an input, so it is fetched from the saved .mat file
    folder=app.FileLoc;
    path1=app.DataFileName_MU1.Value;
    path2=app.DataFileName_MU2.Value;
    path3=app.DataFileName_MU3.Value;
    fullpath1=folder+"\"+path1+".mat";
    fullpath2=folder+"\"+path2+".mat";
    fullpath3=folder+"\"+path3+".mat";
    load(fullpath1,'-mat','MD_1');
    load(fullpath2,'-mat','MD_2');
    load(fullpath3,'-mat','MD_3');
    MD(1)=MD_1;
    MD(2)=MD_2;
    MD(3)=MD_3;
else
    if(nargin==2) % MD is an input
        MD=varargin{1}; 
    else
        error('Too many arguments.');
    end
end

    % Determine the maximum time to assign units accordingly
    timeEnd = max([MD(1).ExpData.log.Ttime,MD(2).ExpData.log.Ttime,...
        MD(3).ExpData.log.Ttime]); 
    [timeUnit,timeFactor] = adjustTimeUnits(timeEnd);
    
    markers = ["o","s","d","^","v",">","<","p","h"];
    legendLabels = cell(3);
    figureTempvTBtime        = figure;%('visible','off'); 
    set(gca, 'FontSize',14)
    c = flipud(jet(3));
    colormap(c);
    hold on
    % Iterate over all the measurement units
    for k=1:3
        % Determine if we the measurement unit is connected
        isConnected = any(MD(k).PinState);
        if isConnected == 1
            % Get the value of the stress bias
            stressBias      = MD(k).ExpData.Setup.stressBiasValue;            
            % Construct the labels for the line
            legendLabels{k} = sprintf("MU%d, stress Bias = %.1f V",...
                    k,stressBias);
            tTime = MD(k).ExpData.log.Ttime/timeFactor;
            plot(tTime, MD(k).ExpData.log.T,'Marker',markers(k),...
                'LineWidth',2,'Color',c(k,:));
        end
    end % ends for k=1:3
    hold off
    title("Temperature vs Time");
    xlabelStr = sprintf("Time (%s)",timeUnit);
    xlabel(xlabelStr);
    ylabel("Temp (°C)");
    leg = legend(legendLabels,'Location','northeast');
    legend('boxoff');
    box on
    
    % Get the working directory from the GUI
    wd = app.FileLoc.Value;
    % Get the time stamp to add to the filetag
    tstamp = TimeStamp;
    % Construct the file tag
    filetag = "Figure_MU_TempVsTime" + tstamp;

    % Save the plot as .fig and as .jpeg
    try
        savefig(figureTempvTBtime,fullfile(wd,strcat(filetag,'.fig')));
        print(figureTempvTBtime,fullfile(wd,strcat(filetag,'.jpg')),'-djpeg','-r300');
    catch e
        display(e.message);
    end % try catch ends
end