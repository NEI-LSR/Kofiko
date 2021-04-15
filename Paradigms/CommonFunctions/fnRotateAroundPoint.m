function [newX, newY] = fnRotateAroundPoint(x ,y , centerX, centerY, angle_of_rotation)

% Helper function. Rotates stuff for dynamic presentations
s = sin(deg2rad(angle_of_rotation));
c = cos(deg2rad(angle_of_rotation));
x = x - centerX;
y = y - centerY;


newX = x .* c - y .* s;
newY = x .* s + y .* c;
newX = round(newX + centerX);
newY = round(newY + centerY);

return;
