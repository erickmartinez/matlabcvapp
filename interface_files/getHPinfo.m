function [success,HPstatus,out] = getHPinfo(HP)
    array = [254,161,0,0,0,161]; % Send get information command
    for j=1:length(array)
        fwrite(HP,array(j),'uint8');
        pause(.1)
    end
    pause(2)
    out = fread(HP,11);
%     for j=1:length(arry)
%         fwrite(HP,arry(j),'uint8');
%         pause(.1)
%     end
%     out = fread(HP);
    if isempty(out)
        display("Temperature Set Not Successful")
        success = 0;
    else
        success = 1;
        HPstatus=out(5);
        disp(HPstatus);
        disp(out);
%         display("Temperature Set!")
    end
end