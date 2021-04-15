clear all
close all

spectrum=textread('test_spec.txt', '', 'delimiter', ','); %read in the text file with the spectrum in it
% plot(spectrum(:,1), spectrum(:,2), '-ko');
% set(1, 'color', [ 1 1 1]);

SPECTRUM=spectrum;
SPECTRUM(:,3)=spectrum(:,2); % a clooge because spectra2xyY requires 2 spectra minimum

JUDDxyY_2=spectra2xyY(SPECTRUM, 'judd');%CHANGE moncie!!! (but where?)
JUDDxyY=JUDDxyY_2(1,:)











