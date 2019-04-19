function HP = InitHP_GG(com)
     delete(instrfind({'Port'},{com}));
     try
         HP = serial(com, 'BaudRate', 9600, 'DataBits',8,'StopBits',1);
         set(HP, 'timeout',0.5);
         fopen(HP);
     catch e
         disp(e.message);
         HP = 0;
     end
end
        