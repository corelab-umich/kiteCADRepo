loadComponent('Manta2RotXFlr_CFD_AR__ExpScale');  %Load Vehicle Model
path = uigetdir; %Define output path for solidworks CAD driving files
files = dir(path); %query file path

% The following link the parameters between the MATLAB model and the 
% SW CAD driving dimensions
wingParaSW = ["rootChord","NACACamberedAirfoil","incidenceAngle",...
    "aspectRatio","taperRatio","sweepAngle","dihedral"];
wingParaMAT = {vhcl.wingRootChord.Value,...
    strrep(vhcl.wingAirfoil.Value,"NACA",""),...
    vhcl.wingIncidence.Value,vhcl.wingAR.Value,vhcl.wingTR.Value,...
    vhcl.wingSweep.Value,vhcl.wingDihedral.Value};
hStabParaSW = ["rootChord","NACAairfoil","incidentAngle",...
    "aspectRatio","taperRatio","sweepAngle"];
hStabParaMAT = {vhcl.hStab.rootChord.Value,...
    strrep(vhcl.hStab.Airfoil.Value,"NACA",""),...
    vhcl.hStab.incidence.Value,vhcl.hStab.AR.Value,vhcl.hStab.TR.Value,...
    vhcl.hStab.sweep.Value};
vStabParaSW = ["rootChord","NACAairfoil","incidentAngle",...
    "aspectRatio","taperRatio","sweepAngle"];
vStabParaMAT = {vhcl.vStab.rootChord.Value,...
    strrep(vhcl.vStab.Airfoil.Value,"NACA",""),...
    vhcl.vStab.incidence.Value,vhcl.vStab.AR.Value,vhcl.vStab.TR.Value,...
    vhcl.vStab.sweep.Value};
fuseParaSW = ["length","diameter"];
fuseParaMAT = {vhcl.fuse.length.Value,vhcl.fuse.diameter.Value};
assyParaSW = ["hStabDistanceFromWing","vStabDistanceFromWing",...
    "LEDistanceFromWing"];
assyParaMAT = {vhcl.hStab.rSurfLE_WingLEBdy.Value(1),...
    vhcl.vStab.rSurfLE_WingLEBdy.Value(1),-vhcl.fuse.rNose_LE.Value(1)};
%Put the queried file names into an easier to access data structure
j=1;
for k = 1 : length(files)
    if endsWith(files(k).name,".txt")
        cntrFiles(j).name = files(k).name;
        j=j+1;
    end
end

%Update the SW driving files
for j = 1 : length(cntrFiles)
    %Read file in question
    fullName = strcat(path,"\",cntrFiles(j).name);
    fid = fopen(fullName,'r');
%     i = 1;
%     tline = fgetl(fid);
%     A{i} = tline;
%     while ischar(tline)
%         i = i+1;
%         tline = fgetl(fid);
%         A{i} = tline;
%     end

    fclose(fid);
%Update model parameters. Specific loop per geometry type. Probably a
%better way to write this section in the future.
    if contains(cntrFiles(j).name,"wing") == 1
    for k = 1:numel(wingParaMAT)
            A{k} = char(strcat(wingParaSW(k),"= ",num2str(wingParaMAT{k})));
            %k=k+1;
    end
    end
    
    if contains(cntrFiles(j).name,"fuse") == 1
    for k = 1:numel(fuseParaMAT)
            A{k} = char(strcat(fuseParaSW(k),"= ",num2str(fuseParaMAT{k})));
            %k=k+1;
    end
    end
    
    if contains(cntrFiles(j).name,"assy") == 1
    for k = 1:numel(assyParaMAT)
            Atemp = assyParaSW(k);
            A{k} = char(strcat(Atemp,"= ",num2str(assyParaMAT{k})));
            %k=k+1;
    end
    end
    
    if contains(cntrFiles(j).name,"hStab") == 1
    for k = 1:numel(hStabParaMAT)
        A{k} = char(strcat(hStabParaSW(k),"= ",num2str(hStabParaMAT{k})));
    end
    end
    
    if contains(cntrFiles(j).name,"vStab") == 1
    for k = 1:numel(vStabParaMAT)
        A{k} = char(strcat(vStabParaSW(k),"= ",num2str(vStabParaMAT{k})));
    end
    end
    
    A{k+1} = -1;
    %Write updated model parameters to the file.
    fid = fopen(fullName, 'w');
    for i = 1:numel(A)
        if A{i+1} == -1
            fprintf(fid,'%s', A{i});
            break
        else
            fprintf(fid,'%s\n', A{i});
            A{i};
        end
    end
    fclose(fid)
    clear A
end