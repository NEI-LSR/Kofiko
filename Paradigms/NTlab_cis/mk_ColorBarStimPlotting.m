%%
[outmat, ~]=mk_ColorBarStim([.2, .2, .2, .1, .1, .1, .1], 1, 6, 30);
%%
outmattemp(outmat==1)=0;    %k
outmattemp(outmat==2)=0.5;  %gray
outmattemp(outmat==3)=1;    %w
outmattemp(outmat==4)=1;    %L+
outmattemp(outmat==5)=0;    %l-
outmattemp(outmat==6)=.5;    %s+
outmattemp(outmat==7)=.5;    %s-

outmattemp2(outmat==1)=0;    %k
outmattemp2(outmat==2)=0.5;  %gray
outmattemp2(outmat==3)=1;    %w
outmattemp2(outmat==4)=0;    %L+
outmattemp2(outmat==5)=1;    %l-
outmattemp2(outmat==6)=.5;    %s+
outmattemp2(outmat==7)=.5;    %s-

outmattemp3(outmat==1)=0;    %k
outmattemp3(outmat==2)=0.5;  %gray
outmattemp3(outmat==3)=1;    %w
outmattemp3(outmat==4)=1;    %L+
outmattemp3(outmat==5)=0;    %l-
outmattemp3(outmat==6)=1;    %s+
outmattemp3(outmat==7)=0;    %s-

outmat2(:,:,:,1)=reshape(outmattemp,[6,30,30,1]);
outmat2(:,:,:,2)=reshape(outmattemp2,[6,30,30,1]);
outmat2(:,:,:,3)=reshape(outmattemp3,[6,30,30,1]);

%%
figure; imagesc(squeeze(outmat2(1,:,:,:)))

%%