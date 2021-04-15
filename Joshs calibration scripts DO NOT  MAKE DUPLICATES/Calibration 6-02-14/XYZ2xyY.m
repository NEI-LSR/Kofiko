function [x, y, Y]=XYZ2xyY (X, bigY, Z)
%converts CIE xyY data into XYZ data, Bevil Conway May 29, 2009
%equations from Westland's book pg. 59

Y = bigY;
x = X / ( X + Y + Z );
y = Y / ( X + Y + Z );












