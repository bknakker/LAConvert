# LAConvert
MATLAB Script to programmatically evoke the BrainVision LiveAmp File Converter

See LAconvert_example.m for how to use with a set of folders.

The BrainVision LiveAmp File converter can be downloaded here: 
https://www.brainproducts.com/downloads.php?kid=40&tab=1

The path to the location where the tool was installed can be set in the LAConvert.m file.

Note that the script evokes and uses the GUI, and requires the computer to be 
untouched during the conversion to run correctly (i.e. no other apps or windows
can be activated or clicked on.), especially if converting multiple folders
in a row.

Also note that some messages fail to arrive at the Converter app; in that 
case a new converter window is opened and the program tries again. This means
that several failed Converter windows might be open at the end of the process.

Copyright (c) 2021 Balázs Knakker, MIT License
