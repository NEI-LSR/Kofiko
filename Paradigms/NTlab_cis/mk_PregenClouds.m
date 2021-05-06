%% pregen Achrom stimuli
cd('Z:\StimulusSet\NTlab_cis\Cloudstims_calib_02_2021')

cloudpix = 60;
for cur_Scale = [1:6]
Dualstim_pregen_achromcloud_n = 6000;
for init=1:10
    DensenoiseAchromcloud = (mk_spatialcloud(cloudpix,cloudpix, Dualstim_pregen_achromcloud_n, cur_Scale)./2 +.5).*255;
    [~,DensenoiseAchromcloud_binned] = histc(DensenoiseAchromcloud,linspace(0,255,256));
    
    save(sprintf('Cloudstims_Achrom_size%d_scale%d_%02d.mat', cloudpix, cur_Scale, init), 'DensenoiseAchromcloud_binned');
    %save(['Cloudstims_Achrom_size' num2str(cloudpix) '_scale' num2str(cur_Scale) '_' num2str( '.mat'])
    clearvars DensenoiseAchromcloud DensenoiseAchromcloud_binned
    
end
end

%% pregen Chromcloud
cd('Z:\StimulusSet\NTlab_cis\Cloudstims_calib_02_2021')

global g_strctParadigm
g_strctParadigm.m_strctConversionMatrices.ldgyb = [    1.0000    1.0000    0.2116
    1.0000   -0.2335   -0.1862
    1.0000   0.0108    1.0000]; %felix added calibration as of jan 2021

cloudpix = 60;
for cur_Scale = [1:6]
Dualstim_pregen_chromcloud_n = 4000;
for init=1:10
    %DensenoiseAchromcloud = (mk_spatialcloud(cloudpix,cloudpix, Dualstim_pregen_achromcloud_n, DensenoiseScale)./2 +.5).*255;
    DensenoiseChromcloud_DKlspace=reshape(mk_spatialcloudRGB(cloudpix, cloudpix, Dualstim_pregen_chromcloud_n, cur_Scale),cloudpix*cloudpix*Dualstim_pregen_chromcloud_n,3);
    DensenoiseChromcloud_sums=sum(abs(DensenoiseChromcloud_DKlspace),2); DensenoiseChromcloud_sums(DensenoiseChromcloud_sums < 1)=1;
    DensenoiseChromcloud_DKlspace=DensenoiseChromcloud_DKlspace./[DensenoiseChromcloud_sums,DensenoiseChromcloud_sums,DensenoiseChromcloud_sums];
    DensenoiseChromcloud=reshape(round(255.*ldrgyv2rgb(DensenoiseChromcloud_DKlspace(:,1)',DensenoiseChromcloud_DKlspace(:,2)',DensenoiseChromcloud_DKlspace(:,3)'))',cloudpix,cloudpix,Dualstim_pregen_chromcloud_n,3);
    DensenoiseChromcloud_DKlspace=reshape(DensenoiseChromcloud_DKlspace,cloudpix,cloudpix,Dualstim_pregen_chromcloud_n,3);
    
    save(sprintf('Cloudstims_Chrom_size%d_scale%d_%02d.mat', cloudpix, cur_Scale, init), 'DensenoiseChromcloud','DensenoiseChromcloud_DKlspace');
    clearvars DensenoiseChromcloud DensenoiseChromcloud_DKlspace DensenoiseChromcloud_sums
end
end

