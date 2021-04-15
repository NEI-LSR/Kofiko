%MUST runme FIRST; MUST change rgb2XYZ to reflect appropriate moncie
%coordinates
%this script then generates desired JUDDxyY vals for the dkl colors 

calc_white_pt=0;%set to '0' if you are NOT calculating white point
    
if calc_white_pt==0
bay3_cols;    
for i=1:length(color)
XYZ(1:3, i)=rgb2XYZ(color(i,:));
end

for i=1:length(color)
XYZ_b(i,1:3)=XYZ(1:3,i);
end

for i=1:length(color)
[x(i, 1), y(i, 1) ,Y(i, 1)]=XYZ2xyY(XYZ_b(i,1), (XYZ_b(i,2)), (XYZ_b(i,3)));
end

x(1:length(color), 1)=x;
y(1:length(color), 1)=y;
Y(1:length(color), 1)=Y;

JuddxyY=[x, y, Y]
disp('type x, y or Y for separate values');

targJuddxyY=xlswrite('TargetJuddxyY', JuddxyY);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

else
bay3_cols;    
for i=1:length(color)
XYZ(1:3, i)=rgb2XYZ(color(i,:));
end

for i=1:length(color)
XYZ_b(i,1:3)=XYZ(1:3,i);
end

XYZ_c=XYZ_b(1,:);

[x, y ,Y]=XYZ2xyY(XYZ_c(1), (XYZ_c(2)), (XYZ_c(3)));

JuddxyY=[x, y, Y]
disp('type x, y or Y for separate values');

JuddxyYvals(1,4:6)=JuddxyY(1,1:3);

gamma_correctedRGB_white_point_vals=gamma_corrected_RGB(color(1,1), color(1,2), color(1,3));

JuddxyYvals(1,1:3)=gamma_correctedRGB_white_point_vals;
targJuddxyY=xlswrite('TargetJuddxyY_andRGB_WhitePoint', JuddxyYvals);

end










