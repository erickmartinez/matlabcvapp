function eventsOnTempPlot(MD,mu,ts,txt,pinNumber)
% eventsOnTempPlot
% Adds text labels corresponding to measurement events to the
% temperature plots
%
% Parameters
% ----------
% MD : strcut
%	The data structure with the logged values of temperature and time
% mu : int
%	The number of the measurement unit where the event occurs
% ts : float
%	The time of the event in seconds
% txt : str
%	The description of the event
% pinNumber : int
%	The pinNumber where the event occurs (optional)
    global realTimeTempFig;
    global phLogHP;
  
	if ~exist('pinNumber','var')
		pinNumber = 0;
    end
    
    if ~exist('realTimeTempFig')
        realTimeTempFig = figure;
        for i=1:3
            loggedTemp(i) = MD(i).ExpData.log.T;
            loggedTime(i) = MD(i).ExpData.log.Ttime;
            subplot(3,1,i)
            phLogHP(i) = plot(realTimeTempFig,loggedTemp(i),loggedTime(i),'o');
            title(sprintf("Hotplate %d", i));
            xlabel("Time (hr)");
            ylabel("Temperature (°C)");
        end
    end
    
 	
	
	% Get the time in hr
	timeHr = ts/3600;
	
	cp = flipud(jet(8));
	% If provided pin number use color palette else use black
	if pinNumber ~= 0
		c = cp(pinNumber);
	else
		c = 'k';
	end

	% Get the y limits of the plot
	yRange = ylim(phLogHP(mu));
    ymin = yRange(1);
    ymax = yRange(2);
	% create a line in the plot
	plot(phLogHP(mu),[timeHr; timeHr], [ymin ymax],':','Color',[0.5,0.5,0.5]);
	
	info_str = "\leftarrow " + txt + " ";
	info_txt = text(phLogHP(mu),timeHr,0.95*ymax,info_str,...
		'HorizontalAlignment','right',...
		'VerticalAlignment','top');
	info_txt.Color    = c;
	info_txt.FontSize = 8;
	info_txt.Rotation = 90;
	drawnow
end
