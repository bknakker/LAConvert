%%
% This scrripts checks all subfolders of a root folder for DAT files and
% puts the converted versions in another folder with mirrored subfolder
% structure. You can check the source and target folders first by running
% only the first chunk of code and inspecting the srcfolders and
% targetfolders variables.
clear
rootfolder='C:\EEG\data_eeg';
 
datfileinfo = dir([rootfolder '/**/*.DAT']);
vmrkfileinfo = dir([rootfolder '/**/LA00*.vmrk']);

srcfolders  = unique({datfileinfo.folder})';
targetfolders=strrep(srcfolders,'data_eeg','data_eeg_proc\LiveAmp_raw');

target_done=dir('C:\EEG\data_eeg_proc\**\*.vmrk');

nfdrs=length(srcfolders);
nfilesconv=nan(nfdrs,1);
%%
for fdrix=1:nfdrs
   nfilesconv(fdrix)=LAconvert_alterloc(srcfolders{fdrix},targetfolders{fdrix}); 
    
    
end


disp ready
