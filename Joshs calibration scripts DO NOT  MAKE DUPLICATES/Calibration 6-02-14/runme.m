%used on train back from NYC, with the measurements from Bay 3 from a
%couple of weeks ago (May 8, 2010), to determine the target xyY values for
%DKL color stimuli. NEED rgb2xyY.m from THORSTEN!!!

% Demo script for DKL color calibration.
% Thorsten Hansen 2008-06-06 Thorsten.Hansen@psychol.uni-giessen.de

% Part I: initialize conversion matrices
% read spectra and plot
clear all
close all

disp('Read spectra.')
%filename = 'sonyGDM510.txt';%original from TH
%S = readspectra(filename);;%original from TH; we don't use this because we
%convert the PR655 data to a useable format manually. The "S" should be of
%the format, S(:,1)=wavelengths; S(:,2)=red values; S(:,3)=green values;
%S(:,4)=blue values.

filename = 'HMS_June_2_2014.txt';  
S=xlsread('spectra.xls');

wavelength = S(:,1);
RGBspectra = S(:, 2:4);
figure
plot(wavelength, RGBspectra(:,1), 'r'), hold on
plot(wavelength, RGBspectra(:,2), 'g')
plot(wavelength, RGBspectra(:,3), 'b')
xlabel('Wavelength (nm)')
ylabel('Corrected spectra radiance (w/sr/m^2)')
title(['RGB monitor spectra for ' filename '.'])

% convert spectra to xyY; for every spectrum there will be just one xyY triplet.
disp('Convert spectra to xyY.')
xyY = spectra2xyY(S, 'judd');

% save to file

disp('Write spectra to file.')
[pathstr name ext] = fileparts(filename);
filename_xyY = [name '.xyY'];
disp(['Writing xyY to ' filename_xyY])
dlmwrite(filename_xyY, xyY, ' ') 

% initialize conversion matrices
%
disp('Initialize conversion matrices.')
initmat(filename_xyY)

%
% The whole stuff can be done in one line (w/o writing the xyY file)
%
% one-liner to read spectra, convert to xyY and initialize conversion matrices
%initmat(spectra2xyY(readspectra('sonyGDM510.txt'), 'Judd'))

% 
% Part II: show stimuli (convert from DKL to RGB)
%

disp('Show stimuli')
figure

disp('DKL "red" at 0 deg.')
az = rad(0); % azimuth, angle in the isoluminant plane
el = rad(0); % elevation; 0 deg is the isoluminant plane
amp = 1.0;   % must be between 0 and 1; 

rgb = dkl2rgb(az, el, amp);

% ensure that not just a single pixel is plotted...
if exist('iptsetpref'), iptsetpref('ImshowInitialMagnification', 'fit'), end
showrgb(rgb'); title('DKL 0 deg "reddish"'); %was in TH's version, but wrong:('DKL 90 deg "yellow-greenish"')
disp('Please press return to proceed.'); disp(' '); pause



% show the isoluminant color along the cardinal directions
disp('The isoluminant color along the cardinal directions')
az = rad([0:90:270]);
cardinal_titles = {'DKL 0 deg "reddish"' ...
                   'DKL 90 deg "yellow-greenish"' ...
                   'DKL 180 deg "bluish-green"' ...
                   'DKL 270 deg "violet"'};
                   
for i=1:length(az)
  subplot(2, 2, i)
  showrgb(dkl2rgb(az(i), el, amp)')
  title(cardinal_titles{i})
end
disp('Note that the S-(L+M) axis is pointing down; violet is 270 deg.')
disp(' ');disp('Please press return to proceed.');  pause; 

figure
% show the isoluminant color along intermediate
disp('The isoluminant color along the intermediate directions')
az = rad([0:90:270]+45);
noncardinal_titles = {'DKL 45 deg "orangeish"' ...
                   'DKL 135 deg "greenish"' ...
                   'DKL 225 deg "bluish"' ...
                   'DKL 315 deg "magenta"'};
                   
for i=1:length(az)
  subplot(2, 2, i)
  showrgb(dkl2rgb(az(i), el, amp)')
  title(noncardinal_titles{i})
end
disp('Note that these colors are not standardized.')
disp('This is because DKL color space is not standardized;')
disp('more precisely the units of the axis are not standardized.')
disp('We scale the cardinal axes such that 1.0 is the maximum allowed')
disp('by the gamut of our monitor.')
disp(' ')
disp('Therefore, DKL is a ===device-dependent color space===.')
disp(' ')
disp('Please press return only if you have understood what this means ;-).');
disp(' '); pause
% convert many values in one call of dkl2rgb
% 
% % Example 1: isoluminant colors in steps of 10 deg
% disp('Example 1: isoluminant colors in steps of 10 deg, amplitude 1.0.')
% figure
% az =  rad([0:10:350]);
% el = zeros(1, length(az));
% amp =  ones(1, length(az));
% rgb = dkl2rgb(az, el, amp);
% subplot(4,1,1),imshow(rgb)
% title('36 isoluminant colors in steps of 10 deg, of amplitude 1.0')
% 
% % Example 1b: isoluminant colors in steps of 10 deg, amplitude 0.5
% disp('Example 1b: isoluminant colors in steps of 10 deg, amplitude 0.5.')
% az =  rad([0:10:350]);
% el = zeros(1, length(az));
% amp =  0.5*ones(1, length(az));
% rgb = dkl2rgb(az, el, amp);
% subplot(4,1,2),imshow(rgb)
% title('36 isoluminant colors in steps of 10 deg, of amplitude 0.5')
% 
% % Example 2: isoluminant colors in steps of 5 deg, amplitude 0.5
% disp('Example 2: isoluminant colors in steps of 5 deg, amplitude 1.0.')
% az = rad([0:5:350]);
% el = zeros(1, length(az));
% amp =  ones(1, length(az));
% rgb = dkl2rgb(az, el, amp, 1, 1);
% subplot(4,1,3), imshow(rgb)
% title('72 isoluminant colors in steps of 5 deg, of amplitude 1.0')
% 
% % Example 2b: isoluminant colors in steps of 5 deg, amplitude 0.5
% disp('Example 2b: isoluminant colors in steps of 5 deg, amplitude 0.5.')
% az = rad([0:5:350]);
% el = zeros(1, length(az));
% amp =  0.5*ones(1, length(az));
% rgb = dkl2rgb(az, el, amp, 1, 1);
% subplot(4,1,4), imshow(rgb)
% title('72 isoluminant colors in steps of 5 deg of amplitude 0.5')

% Example 15deg; amplitude 0.95; change “az” to change number of %colors;
% change “amp” to change saturation, 1=max.
figure(10)
disp('isoluminant colors in steps of 22.5 deg, amplitude 0.1')
az = rad([0:22.5:359]);%set the number of steps you would like; change above couple of lines too!
el = zeros(1, length(az));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Include these lines for modifying the luminance. If the equiluminant colors are 0 deg, for 
%% a 20% increase in the luminance, we should increase the elevation in: 90*20/100 = 18 degs.

% if el(1,:)== 0
%     el (:,:) = -18; 
% end 
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
amp =  0.015*ones(1, length(az));
rgb = dkl2rgb(az, el, amp, 1, 1);
imshow(rgb)
title('isoluminant colors in steps of 22.5 deg, amplitude 0.1')
% 
% % Example Bay3, 30deg; amplitude 0.5
% figure(11)
% disp('Bay3: isoluminant colors in steps of 30 deg, amplitude 0.5')
% az = rad([0:30:350]);
% el = zeros(1, length(az));
% amp =  0.5*ones(1, length(az));
% rgb = dkl2rgb(az, el, amp, 1, 1);
% imshow(rgb)
% title('Bay3: isoluminant colors in steps of 30 deg, amplitude 0.5')

% %%Make Gray/White Point
% figure(12) %determines the neutral gray RGB coordinates
% disp('make gray/white')
% az = rad([0:30:350]);
% el = zeros(1, length(az));
% %el=el+pi; %to generate black and white
% amp =  0*ones(1, length(az));
% rgb = dkl2rgb(az, el, amp, 1, 1);
% imshow(rgb)
% title('make gray/white')

disp('Please press return to proceed.'); disp(' '); pause


% some values may fell slightly outside the range [0, 1].
disp('')
disp('Note that some values may fall slightly outside the range [0, 1].)')
disp('e.g., for 91 deg: dkl2rgb(rad(91), 0, 1) we get')
dkl2rgb(rad(91), 0, 1)

% These can be remapped to [0, 1] by setting the fivth parameter of
% dkl2rgb to 1; the fourth should always be 1. 
disp('These can be remapped to [0, 1] by setting the fifth parameter of')
disp('dkl2rgb to 1; the fourth should always be 1.')
disp('dkl2rgb(rad(91), 0, 1, 1, 1):')
dkl2rgb(rad(91), 0, 1, 1, 1)

disp(' ')
disp('##########################################################################')
disp(' ')
disp('To ensure that colors are displayed correctly on your monitor')
disp('you have to do two things:')
disp(' 1. measure spectra of the RGB primaries of your monitor ')
disp('    at maximum intensity, i.e. for ')
disp('    R = [255 0 0], G = [0 255 0] and B = [0 0 255]')
disp('    and call initmat with these values.')
disp(' 2. Gamma-correct your monitor. Ensure that there is a linear')
disp('    mapping from pixel values to luminance; e.g., ')
disp('    if you measure 60 cd/m^2 for [255 0 0], then after gamma-correction')
disp('    you should measure a luminance of 30 cd/m^2 for [127 0 0].')
disp(' ')
disp('Thorsten.Hansen@psychol.uni-giessen.de 2008-06-06')
disp(' ')
disp('##########################################################################')


