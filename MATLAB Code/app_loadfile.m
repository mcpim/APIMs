function [name, file, SEM_Image] = app_loadfile

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

foldername = strcat(myDocPath,'\APIMsoftware');
if ~exist(foldername, 'dir')
       mkdir(foldername)
end

usersettingsfile = strcat(foldername,'\UserSettings.cfg');
%Imports SEM image to collect data from
if isfile(usersettingsfile)
    %Read old folder
    fileID = fopen(usersettingsfile);
    old_folder = fgetl(fileID);
    [name, folder] = uigetfile('*.tif','Please select the image to analyse',old_folder);
    fclose(fileID);
    if name == 0 & folder == 0
        file = 0;
        SEM_Image = 0;
        return;
    end
    %Write new folder location
    fileID = fopen(usersettingsfile,'w');
    fprintf(fileID,'%s\n', folder);
    fclose(fileID);
else

    [name, folder] = uigetfile('*.tif');
    if name == 0 & folder == 0
        file = 0;
        SEM_Image = 0;
        return;
    end
    fileID = fopen(usersettingsfile,'w');
    fprintf(fileID,'%s\n', folder);
    fclose(fileID);
end

file = strcat(folder,name);
SEM_Image = imread(file);

end