function [object_data, folder_to_save_to] = app_outputdata(objects, name, file, tilt_angle)

%Creating matrix to easily display found data later
object_data(:,1) = objects.PhysicalWidth;
object_data(:,2) = objects.PhysicalLength;
object_data(:,3) = objects.PhysicalVolume;
object_data(:,4) = mod(objects.Orientation, 180);
object_data(:,5) = objects.Std_PhysicalWidth;
object_data(:,6) = objects.Std_PhysicalLength;
object_data(:,7) = objects.Std_PhysicalVolume;

Exist_Column = strcmp('TopViewOrientation',objects.Properties.VariableNames);
q_topview_present = Exist_Column(Exist_Column==1);
if q_topview_present
    object_data(:,8) = objects.TopViewOrientation;
end

Exist_Column = strcmp('Phi',objects.Properties.VariableNames);
q_CubeFitPresent = Exist_Column(Exist_Column==1);
if q_CubeFitPresent
    object_data(:,8) = objects.Phi;
    object_data(:,9) = objects.Phi_Uncertainty;
    object_data(:,10) = objects.Slant;
    object_data(:,11) = objects.Slant_Uncertainty;
end

%Saving all data to a folder
new_name = erase(name, '.tif');

%GET THE DOCUMENTS DIRECTORY
% query the registry
[~,res]=dos('reg query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" /v Personal');
% parse result
res = strsplit(res, ' ');
% get path
myDocPath = strtrim(res{numel(res)});
% if it returns %AAAAA%/xxxx, meaning the Documents folder is
% in some environment path.
[startidx, endidx] = regexp(myDocPath,'%[A-Z]+%');
if ~isempty(startidx)
    myDocPath = fullfile(getenv(myDocPath(startidx(1)+1:endidx(1)-1)), myDocPath(endidx(1)+1:end));
end
APIMsfolder = strcat(myDocPath,'\APIMsoftware');

mkdir(strcat(APIMsfolder,'\Measurements\',new_name))
folder_to_save_to = strcat(APIMsfolder,'\Measurements\',new_name);

%Save objects data
save(strcat(folder_to_save_to, '\objects'), 'objects')

%Copy .tif file
%Check if the file will not be copied over itself
originalfilelocation = strrep(file,strcat('\',name),'');
if strcmp(originalfilelocation, folder_to_save_to)
else
    copyfile(file, folder_to_save_to)
end

%Saves the .fig file
savefig(strcat(folder_to_save_to,'\figure.fig'))

%Saves the calculated data to a .dat file
fileID = fopen(strcat(folder_to_save_to,'\object_data_',new_name,'.dat'), 'w');
%writematrix(object_data, fileID);
fprintf(fileID,'%s \r\n','Data gathered using APIMsoftware');
fprintf(fileID, '%s \r\n\r\n',strcat("Retrieved at: ", datestr(datetime('now'))));

fprintf(fileID, '%s \r\n', strcat("Filename: ",name));
fprintf(fileID, '%s \r\n', strcat("Tilt angle: ",num2str(tilt_angle),'°'));
fprintf(fileID, '%s \r\n', strcat("Number of objects calculated: ",num2str(length(objects.Area))));
fprintf(fileID, '%s \r\n', strcat("Mean width: ",num2str(mean(object_data(:,1)))," ± ", num2str(std(object_data(:,1)))," nm."));
fprintf(fileID, '%s \r\n', strcat("Mean length: ",num2str(mean(object_data(:,2)))," ± ", num2str(std(object_data(:,2)))," nm."));
fprintf(fileID, '%s \r\n', strcat("Mean volume: ",num2str(mean(object_data(:,3)))," ± ", num2str(std(object_data(:,3)))," nm³."));

if q_topview_present
    fprintf(fileID, '%s \r\n \r\n', strcat("Mean top view orientation: ",num2str(mean(object_data(:,8)))," ± ", num2str(std(object_data(:,8)))," °."));
    fprintf(fileID,'%s, %s, %s, %s, %s, %s, %s, %s \r\n','Width (nm)','Std. Width (nm)','Length (nm)','Std. Length (nm)','Volume (nm³)','Std. Volume (nm³)','Orientation (°)', 'Top view orienation (°)');
    for i = 1:length(object_data(:,1))
        fprintf(fileID,'%f, %f, %f, %f, %f, %f, %f, %f \r\n',[object_data(i,1), object_data(i,5),object_data(i,2),object_data(i,6),object_data(i,3),object_data(i,7),object_data(i,4),object_data(i,8)]);
    end
elseif q_CubeFitPresent
    fprintf(fileID, '%s \r\n', strcat("Mean rotation phi: ",num2str(mean(object_data(:,8)))," ± ", num2str(std(object_data(:,8)))," °."));
    fprintf(fileID, '%s \r\n \r\n', strcat("Mean slant angle: ",num2str(mean(object_data(:,10)))," ± ", num2str(std(object_data(:,10)))," °."));
    fprintf(fileID,'%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s \r\n','Width (nm)','Std. Width (nm)','Length (nm)','Std. Length (nm)','Volume (nm³)','Std. Volume (nm³)','Orientation (°)', 'Phi (°)','Phi std. (°)', 'Slant (°)', 'Slant std. (°)');
    for i = 1:length(object_data(:,1))
        fprintf(fileID,'%f, %f, %f, %f, %f, %f, %f, %f, %f, %f, %f \r\n',[object_data(i,1), object_data(i,5),object_data(i,2),object_data(i,6),object_data(i,3),object_data(i,7),object_data(i,4),object_data(i,8),object_data(i,9),object_data(i,10),object_data(i,11)]);
    end
else
    fprintf(fileID, '%s \r\n \r\n', strcat("Mean orientation: ",num2str(mean(object_data(:,4)))," ± ", num2str(std(object_data(:,4)))," °."));
    fprintf(fileID,'%s, %s, %s, %s, %s, %s, %s \r\n','Width (nm)','Std. Width (nm)','Length (nm)','Std. Length (nm)','Volume (nm³)','Std. Volume (nm³)','Orientation (°)');
    for i = 1:length(object_data(:,1))
        fprintf(fileID,'%f, %f, %f, %f, %f, %f, %f \r\n',[object_data(i,1), object_data(i,5),object_data(i,2),object_data(i,6),object_data(i,3),object_data(i,7),object_data(i,4)]);
    end
end

fclose(fileID);
end