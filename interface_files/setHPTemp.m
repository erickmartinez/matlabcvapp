function Success = setHPTemp(HP,T)
    HT = floor(T/25.6);
    LT = mod(T,25.6)*10;
    CumSum = 178+HT+LT;
    if (CumSum > 255)
        CumSum = CumSum-256;
    end
    arry = [254,178,HT,LT,0, CumSum];
    for j=1:length(arry)
        fwrite(HP,arry(j),'uint8');
        pause(.1)
    end
    pause(2)
    out = fread(HP);
%     for j=1:length(arry)
%         fwrite(HP,arry(j),'uint8');
%         pause(.1)
%     end
%     out = fread(HP);
    if isempty(out)
        display("Temperature Set Not Successful")
        Success = 0;
    else
        Success = 1;
        display("Temperature Set!")
    end
end