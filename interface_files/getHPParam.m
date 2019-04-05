function [TR,SR,TS,SS,out] =  getHPParam(HP)
    arry = [254,162,0,0,0,162];
    fwrite(HP,[254,162,0,0,0,162],'uint8')
    out = (fread(HP))';
    
    SS = [];
    SR = [];
    TS = [];
    TR = [];
    
    if isempty(out)
        display("Not Successful")
        Success = 0;
    else
        Success = 1;
        display("Temperature Obtained!")
   
        HSS = out(3)*25.6; %High Set Speed
        LSS = out(4)*.1; %Low Set Speed
        SS = HSS+LSS; %Set Speed

        HSR = out(5)*25.6; %High Real Speed
        LSR = out(6)*.1; %Low Real Speed
        SR = HSR+LSR; %Real Speed

        HTS = out(7)*25.6; %High Set Temperature
        LTS = out(8)*.1; %Low Set Temperature
        TS = HTS+LTS; %Set Temperature

        HTR = out(9)*25.6; %High Real Temperature
        LTR = out(10)*.1; %Low Real Temperature
        TR = HTR+LTR; %Real Temperature
    end
end