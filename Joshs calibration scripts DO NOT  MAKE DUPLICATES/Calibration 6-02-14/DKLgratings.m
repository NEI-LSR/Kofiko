

%from an excel file (StimValsRGB_gamma_corrected) that contains the target 
%peak RGB values for the DKL colors; and an excel file (TargetJuddxyY_andRGB_WhitePoint)
%that contains the gray values, this script will generate the DKL
%colors complete with the slopes for a trapezoidal grating. It produces a number of
%excel files, one for each color, each file with 10 rows and 3 columns; 
%rows are the gray:slopes:peak, and columns are the corresponding RGB
%values. All is gamma corrected.

% DKLpks=xlsread('StimValsRGB_gamma_corrected.xls');
DKLpks=xlsread('StimValsRGB_gamma_corrected_and_tweaked.xls');
%DKLgray=xlsread('TargetJuddxyY_andRGB_WhitePoint.xls');
DKLgray=xlsread('WhitePointRGB_gamma_corrected_and_tweaked.xls');%DKLgray=xlsread('TargetJuddxyY_andRGB_WhitePoint_tweaked.xls');
colors=(0:(360/length(DKLpks)):360-(360/length(DKLpks)));

%color 0
for i=1:length(DKLpks)%12
grating_vals=make_slopes(DKLgray(1,1),DKLgray(1,2),DKLgray(1,3),DKLpks(i,1),DKLpks(i,2),DKLpks(i,3), 8);
%colorname=num2str(colors(i), 'color%d');
colorname=num2str((i), 'color%d');
xlswrite(colorname, grating_vals);
end