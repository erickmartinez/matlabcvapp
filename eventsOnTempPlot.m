function eventsOnTempPlot(app,mu,ts,txt,pinNumber)
% eventsOnTempPlot
% Adds text labels corresponding to measurement events to the
% temperature plots
%
% Parameters
% ----------
% app : obj
%	A handle to the app designer GUI instance
% mu : int
%	The number of the measurement unit where the event occurs
% ts : float
%	The time of the event in seconds
% txt : str
%	The description of the event
% pinNumber : int
%	The pinNumber where the event occurs (optional)

	if ~exist('pinNumber','var')
		pinNumber = 0;
	end
	
	% Get the time in hr
	timeHr = ts/3600;

	% The handles to the plot in the app designer
	if mu == 1
		plotHandle = Tpanel=app.TempTime_1;
	elseif mu == 2
		plotHandle = Tpanel=app.TempTime_2;
	elseif mu == 3
		plotHandle = Tpanel=app.TempTime_3;
	end
	
	cp = flipud(jet(8));
	% If provided pin number use color palette else use black
	if pinNumber ~= 0
		c = cp(pinNumber);
	else
		c = 'k';
	end

	% Get the y limits of the plot
	[ymin, ymax] = ylim(plotHandle);
	% create a line in the plot
	plot(plotHandle,[timeHr; timeHr], [ymin ymax],':','Color',[0.5,0.5,0.5]);
	
	info_str = "\leftarrow " + txt + " ";
	info_txt = text(plotHandle,timeHr,0.95*ymax,info_str,...
		'HorizontalAlignment','right',...
		'VerticalAlignment','top');
	info_txt.Color    = c;
	info_txt.FontSize = 8;
	info_txt.Rotation = 90;
    refresh(plotHandle);
	drawnow;
end
