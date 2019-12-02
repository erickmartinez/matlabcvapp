% gen_CVnames
% Script to generate CV measurement name for the three measurement units
% based on the name of the last measurement
% Example: if MU3_SiOx_CV2_VS_1C_D45D46D47D48_4Na_D45D46D47D48 is the last
% measurement name, it will generate the next measurement names for
% MU1, MU2 and MU3:
% MU1_SiOx_CV2_VS_1C_D49D50D51D52_4Na_D49D50D51D52
% MU2_SiOx_CV2_VS_1C_D53D54D55D56_4Na_D53D54D55D56
% MU3_SiOx_CV2_VS_1C_D57D58D59D60_4Na_D57D58D59D60


%% Name of the last measurement
% use gui to select the measurement name
%previousname='MU3_SiOx_CV2_VS_1C_D45D46D47D48_4Na_D45D46D47D48';
[file,path]=uigetfile('G:\Shared drives\FenningLab2\Projects\PVRD1\ExpData\CVExpData');
previousname=strtok(file,'.');
%%

% Remove MU3
sample=split(previousname,'MU3');
% Find the pin numbers
parts=split(sample{2},'_');

% Find the number of the last pins measured for both clean and contaminated

k=1; % index of the pin number (k=1 for clean pins, k=2 for Na-contaminated pins)
pinnbs=zeros(1,2); % Contains the number of the last clean pin and last contaminated pin measured
for ii=1:length(parts)
    partii=parts{ii};
    if(length(partii)>1)
        if(partii(1)=='D' && isnumeric(str2num(partii(2)))) % if _Dx is found where x is a number, cut the string
            numbers=split(partii,'D');
            pinnbs(k)=str2num(numbers{end});
            k=k+1;
        end
    end
end

% Write names of new measurement for units MU1, MU2 and MU3
newpinnb=zeros(4,2);
k=1;
newpartii_cleanMU1='';
newpartii_contMU1='';
newpartii_cleanMU2='';
newpartii_contMU2='';
newpartii_cleanMU3='';
newpartii_contMU3='';
while(k<5)
    newpartii_cleanMU1=newpartii_cleanMU1+"D"+num2str(pinnbs(1,1)+k); % Second column of pinnb contains the number of last clean pin
    newpartii_contMU1=newpartii_contMU1+"D"+num2str(pinnbs(1,2)+k); % Second column of pinnb contains the number of last contaminated pin
    newpartii_cleanMU2=newpartii_cleanMU2+"D"+num2str(pinnbs(1,1)+k+4); % Second column of pinnb contains the number of last clean pin
    newpartii_contMU2=newpartii_contMU2+"D"+num2str(pinnbs(1,2)+k+4); % Second column of pinnb contains the number of last contaminated pin
    newpartii_cleanMU3=newpartii_cleanMU3+"D"+num2str(pinnbs(1,1)+k+8); % Second column of pinnb contains the number of last clean pin
    newpartii_contMU3=newpartii_contMU3+"D"+num2str(pinnbs(1,2)+k+8); % Second column of pinnb contains the number of last contaminated pin
    k=k+1;
end

% Assemble the new names
MU1name="MU1";
MU2name="MU2";
MU3name="MU3";

newparts=parts;
p=0; % indicate clean pin or contaminated pin
for ii=1:length(newparts)
    if(length(parts{ii})>1)
        if(parts{ii}(1)=='D' && isnumeric(str2num(parts{ii}(2))))
            if(p==0)
                MU1name=MU1name+"_"+newpartii_cleanMU1;
                MU2name=MU2name+"_"+newpartii_cleanMU2;
                MU3name=MU3name+"_"+newpartii_cleanMU3;
            elseif(p==1)
                MU1name=MU1name+"_"+newpartii_contMU1;
                MU2name=MU2name+"_"+newpartii_contMU2;
                MU3name=MU3name+"_"+newpartii_contMU3;
            end
        else
            MU1name=MU1name+"_"+newparts{ii};
            MU2name=MU2name+"_"+newparts{ii};
            MU3name=MU3name+"_"+newparts{ii};
        end
    end
end

display(MU1name);display(MU2name);display(MU3name);
