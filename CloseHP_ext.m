function CloseHP_ext(app, HW, MUnb, COM) %Function to Close/Clear Hotplate Serial Object
% CloseHP_ext
% Closes the connection to the hotplate serial object and removes the
% handles to it from the memory
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI instance <-- UNUSED ARGUMENT
% HW : struct
%   A data structure containing the hardware variables
% MUnb : int
%   The number of the hotplate
% COM : str
%   The communication port to the hotplate serial connection
    if isfield(HW(MUnb),'HP')
        try
            fclose(HW(MUnb).HP); %Close object
            delete(HW(MUnb).HP); %Delete object in workspace
            % clear(HW(MUnb).HP); <-- Already deleted
            delete(instrfind('Port',COM)) %Delete connection to communication port
        catch e
            log(app,e.message);
        end
    end
end