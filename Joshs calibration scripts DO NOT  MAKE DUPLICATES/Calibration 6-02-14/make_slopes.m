
function grating_vals = make_slopes(Rgray, Ggray, Bgray, Rpk, Gpk, Bpk, num_slope_vals)
% this function uses thmakelut, and one should check to make sure the gamma
% parameter (the last called by the function) is optimized so that the error 
%of the fit is minimized

%test values
% Rgray=181;
% Ggray=176;
% Bgray=193;
% Rpk=190;
% Gpk=155;
% Bpk=254;
% num_slope_vals=8;

zero_2_255_vals=xlsread('0_255vals.xls');

xdata=zero_2_255_vals(:,1);
R=zero_2_255_vals(:,2);
G=zero_2_255_vals(:,3);
B=zero_2_255_vals(:,4);

thmakelut(xdata, R, 'MGH_May21_2010_Rlum_LUT', 2);
thmakelut(xdata, G, 'MGH_May21_2010_Glum_LUT', 2);
thmakelut(xdata, B, 'MGH_May21_2010_Blum_LUT', 2);

RLUT=textread('MGH_May21_2010_Rlum_LUT');
RLUT_linear=RLUT(:,1);
RLUT_presented=RLUT(:,2);

GLUT=textread('MGH_May21_2010_Glum_LUT');
GLUT_linear=GLUT(:,1);
GLUT_presented=GLUT(:,2);

BLUT=textread('MGH_May21_2010_Blum_LUT');
BLUT_linear=BLUT(:,1);
BLUT_presented=BLUT(:,2);

Rgray_index=find(RLUT_presented>=Rgray, 1);
Ggray_index=find(GLUT_presented>=Ggray, 1);
Bgray_index=find(BLUT_presented>=Bgray, 1);

Rgray_linear=RLUT_linear(Rgray_index);
Ggray_linear=GLUT_linear(Ggray_index);
Bgray_linear=BLUT_linear(Bgray_index);

Rpk_index=find(RLUT_presented>=Rpk, 1);
Gpk_index=find(GLUT_presented>=Gpk, 1);
Bpk_index=find(BLUT_presented>=Bpk, 1);

Rpk_linear=RLUT_linear(Rpk_index);
Gpk_linear=GLUT_linear(Gpk_index);
Bpk_linear=BLUT_linear(Bpk_index);

RslopeVals_linear=round(linspace(Rgray_linear, Rpk_linear, num_slope_vals+2));
for i=1:num_slope_vals+2;
    RslopeVals_index(i)=find(RLUT_linear==RslopeVals_linear(i));
end
RslopeVals_presented=RLUT_presented(RslopeVals_index);

GslopeVals_linear=round(linspace(Ggray_linear, Gpk_linear, num_slope_vals+2));
for i=1:num_slope_vals+2;
    GslopeVals_index(i)=find(GLUT_linear==GslopeVals_linear(i));
end
GslopeVals_presented=GLUT_presented(GslopeVals_index);

if isempty(Bpk_linear)
    Bpk_linear = 255;
end

if isempty(Bgray_linear)
    Bgray_linear = 255;
end


BslopeVals_linear=round(linspace(Bgray_linear, Bpk_linear, num_slope_vals+2));
for i=1:num_slope_vals+2;
    BslopeVals_index(i)=find(BLUT_linear==BslopeVals_linear(i));
end
BslopeVals_presented=BLUT_presented(BslopeVals_index);

% RslopeVals_presented(end+1)=NaN;
% GslopeVals_presented(end+1)=NaN;
% BslopeVals_presented(end+1)=NaN;

RslopeVals_presented(end)=Rpk;%ensure that peak values are desired empirical vals
GslopeVals_presented(end)=Gpk;%ensure that peak values are desired empirical vals
BslopeVals_presented(end)=Bpk;%ensure that peak values are desired empirical vals

grating_vals=[RslopeVals_presented GslopeVals_presented BslopeVals_presented];

% grating_vals=grating_vals(:);

































