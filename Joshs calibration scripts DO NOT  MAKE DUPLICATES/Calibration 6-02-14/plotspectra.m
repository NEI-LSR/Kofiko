function plotspectra(S, titlestr)
%PLOTSPECTRA  Plot spectral data.
%
%(c) 2004  Thorsten Hansen
if nargin == 0 | isstr(S) & strcmp(S, 'test')
    dirname = 'C:\Documents and Settings\hansen\My Documents\data\calibration\';
    subplot(2,1,1)
    plotspectra(spectraldata([dirname 'sonygdm510\capturesony.txt']), 'SONY CRT');
    subplot(2,1,2)
    plotspectra(spectraldata([dirname 'DellLatitudeD800\captureplatin.txt']), 'Dell LCD');
    return
end

lw = 2;
h = plot(S(:,1), S(:,2), 'r');
set(h, 'Linewidth', lw);
hold on
h = plot(S(:,1), S(:,3), 'g');
set(h, 'Linewidth', lw);
h = plot(S(:,1), S(:,4), 'b');
set(h, 'Linewidth', lw);
hold off
a = axis;
axis([S(1,1) S(end,1) a(3) a(4)])

xlabel('wavelength')
ylabel('radiance')
if nargin > 1
  title(titlestr)
end