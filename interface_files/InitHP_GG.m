function HP = InitHP_GG(com)
     delete(instrfind({'Port'},{com}))
     HP = serial(com, 'BaudRate', 9600, 'DataBits',8,'StopBits',1);
     fopen(HP);
     set(HP, 'timeout',1);
end
        