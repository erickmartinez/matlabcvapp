function CloseHP_ext(app, HW, MUnb, COM) %Function to Close/Clear Hotplate Serial Object
fclose(HW(MUnb).HP); %Close object
delete(HW(MUnb).HP); %Delete object in workspace
clear(HW(MUnb).HP);
delete(instrfind('Port',COM)) %Delete connection to communication port
end