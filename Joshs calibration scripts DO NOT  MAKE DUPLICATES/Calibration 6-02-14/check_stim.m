DKLpks_target=xlsread('TargetJuddxyY.xls');
DKLgray_target=xlsread('TargetJuddxyY_andRGB_WhitePoint.xls');

DKLpks_actual=xlsread('StimValsRGB_gamma_corrected_and_tweaked.xls');
DKLgray_actual=xlsread('WhitePointRGB_gamma_corrected_and_tweaked.xls');


figure(99)
plot(DKLpks_target(:,1), DKLpks_target(:,2), '-ro');
hold on
plot(DKLgray_target(:,4), DKLgray_target(:,5), 'rs');
plot(DKLpks_actual(:,4), DKLpks_actual(:,5), '-ko');
plot(DKLgray_actual(:,4), DKLgray_actual(:,5), '-ks');

set(99, 'color', [1 1 1]);
xlabel('Judd-Corrected x')
ylabel('Judd-Corrected y')
title('target (red), actual (black)');
axis square



















