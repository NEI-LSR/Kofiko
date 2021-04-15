
function gamma_corrected_RGBvals = gamma_corrected_RGB(R_not_corr, G_not_corr, B_not_corr)
% this function uses thmakelut, and one should check to make sure the gamma
% parameter (the last called by the function) is optimized so that the error 
%of the fit is minimized
% R_not_corr=249;
% G_not_corr=95;
% B_not_corr=129;

zero_255vals=xlsread('0_255vals.xls'); 
xdata=zero_255vals(:,1);
Rlum=zero_255vals(:,2);
Glum=zero_255vals(:,3);
Blum=zero_255vals(:,4);


thmakelut(xdata, Rlum, 'HMS_June_2_2014_Rlum_LUT', 2.5);
thmakelut(xdata, Glum, 'HMS_June_2_2014_Glum_LUT', 2.4);
thmakelut(xdata, Blum, 'HMS_June_2_2014_Blum_LUT', 2.55);

RLUT=textread('HMS_June_2_2014_Rlum_LUT');
RLUT_linear=RLUT(:,1);
RLUT_presented=RLUT(:,2);

GLUT=textread('HMS_June_2_2014_Glum_LUT');
GLUT_linear=GLUT(:,1);
GLUT_presented=GLUT(:,2);

BLUT=textread('HMS_June_2_2014_Blum_LUT');
BLUT_linear=BLUT(:,1);
BLUT_presented=BLUT(:,2);

R_corr_index=find(RLUT_linear>=R_not_corr, 1);
R_corr=RLUT_presented(R_corr_index);

G_corr_index=find(GLUT_linear>=G_not_corr, 1);
G_corr=RLUT_presented(G_corr_index);

B_corr_index=find(BLUT_linear>=B_not_corr, 1);
B_corr=BLUT_presented(B_corr_index);

gamma_corrected_RGBvals=[R_corr, G_corr, B_corr];








