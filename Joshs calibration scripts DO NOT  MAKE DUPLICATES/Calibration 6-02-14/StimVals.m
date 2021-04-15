%run this script after you have run runme.m and have adjusted the
%gamma_corrected_RGB.m file. See "How to make DKL stimuli.doc" for
%instructions


bay3_cols;



for i=1:length(color)
    
StimValsRGB(i,1:3)=gamma_corrected_RGB(color(i,1), color(i,2), color(i,3));
disp(['color done ' num2str(i)])

end


xlswrite('StimValsRGB_gamma_corrected', StimValsRGB)








