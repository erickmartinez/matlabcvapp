function CloseHP(HP,com)
     fclose(HP);
     delete(HP);
     clear HP;
     delete(instrfind({'Port'},{com}))
end