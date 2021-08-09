function nconvd= LAconvert(srcfolder,targetfolder)
% Launch LiveAmp File converter and convert all LiveAmp DAT files in
% srcfolder to BrainVision Core format files in targetfolder. 
%
% The target folder is checked for vmrk files that match those to
% be converted, and for matching files conversion is not re-done.
% 
% Returns nconvd: number of files converted.
% 
% Waits for 20 secs per file by default before trying again in a new converter window.
% The timeout and the path to the converter can be modified at the
% beginning of the function code (for the time being).
% Balázs Knakker, 2021, under the MIT license.
%
% MIT License
% 
% Copyright (c) [year] [fullname]
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
CONVERTERPATH='"C:\Program Files (x86)\BrainVision\LiveAmpFileConverter\LiveAmpFileConverter.exe"';
TIMEOUT_PER_FILE=20;
%%
nconvd=0;

h = actxserver('WScript.Shell');


fls0=dir(fullfile(srcfolder,'*.DAT'));
flstodo={fls0.name};
expected_vmrk=sort(cellfun(@(x) [ subsref(split(x,'.'),struct('type','{}','subs',{{1}})) '.vmrk'],flstodo,'UniformOutput',false));

if isempty(flstodo)
   fprintf('%s: no files found, skipping.\n',srcfolder) 
   return;
end


if exist(targetfolder,'dir')~=0
    tfls0=dir(fullfile(targetfolder,'*.vmrk'));
    tflsize=[tfls0.bytes];
    tfls={tfls0.name};
    
    got_vmrk=sort(tfls(tflsize>100));
    done_DAT=sort(cellfun(@(x) [ subsref(split(x,'.'),struct('type','{}','subs',{{1}})) '.DAT'],got_vmrk,'UniformOutput',false));
    flstodo = setdiff(flstodo,done_DAT);
else
    mkdir(targetfolder);
end
%%
if isempty(flstodo)
   fprintf('%s: already done, skipping.\n',srcfolder) 
   return;
end

srcfiles=sprintf('"%s" ',flstodo{:});

   fprintf('%s: starting.\n',srcfolder) 

%%
h.Run(CONVERTERPATH);


pause(2); %Waits for the application to load.
h.AppActivate('LiveAmp File Converter V_2.1.3'); %Brings to focus

h.SendKeys('~'); % Open dialog to select files
pause(.25)

h.SendKeys(sprintf('"%s"~',srcfolder)); % Navigate to source folder
pause(.25)

h.SendKeys(sprintf('"%s"~',srcfiles)); % Select source files

%%
% h.AppActivate('LiveAmp File Converter V_2.1.3'); %Brings to focus
pause(.25)

% Open dialog to select target folder and tab to the folder selection bar
% note that the space is necessary
h.SendKeys('{TAB}~');
pause(.25)

h.SendKeys('^l'); % move to the directory entry field
pause(.25)

h.SendKeys(sprintf('%s~',targetfolder)); % Enter the target folder
%%
% h.SendKeys('{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}~');
pause(.25)

h.SendKeys('%o');
% h.AppActivate('LiveAmp File Converter V_2.1.3'); %Brings to focus
pause(.5)
h.SendKeys('{TAB} '); % Start the conversion
%%
running=true;
tic
timeout=length(flstodo)*TIMEOUT_PER_FILE;

while running
    pause(1);
    tfls0=dir(fullfile(targetfolder,'*.vmrk'));
    tflsize=[tfls0.bytes];
    tfls={tfls0.name};
    
    got_vmrk=sort(tfls(tflsize>100));
    running=~isequal(expected_vmrk,got_vmrk);
    if toc>timeout
        
        warning('Operation timed out, retrying'); 
        
        nconvd=LAconvert_alterloc(srcfolder,targetfolder);
        h.SendKeys('%{F4}'); % close converter

        return
    end
end
pause(3);
h.SendKeys('%{F4}'); % close converter
nconvd=length(expected_vmrk);
toc
   fprintf('%s -> %s: done.\n',srcfolder,targetfolder) ;



