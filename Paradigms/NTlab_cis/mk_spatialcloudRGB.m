function [ stim ] = mk_spatialcloudRGB( stimw, stimh, num_frames, seedn )
%mk_spatialcloudRGB creates spatial cloud stimulus with three color
%channels
if nargin==4; rng(seedn); end

stim = zeros(num_frames,stimw,stimh,3);
spatial_scale = 5;

% Start with gaussian white noise (on larger square)
L = max([stimw stimh]);
noise_stim = randn(num_frames,L,L,3);

for cc=1:3
% 2-D Gaussian mask
xs=(0:(L-1));
r2s = xs'.^2*ones(1,L) + ones(L,1)*xs.^2;
rad1 = 2*L/pi/spatial_scale;
mask1 = exp(-r2s/(2*rad1^2));
mask1 = mask1/max(mask1(:));

for k=	1:num_frames
	im1 = squeeze(squeeze(noise_stim(k,:,:,cc)));
	manip1 = fftshift(fft2(im1)); 
	manip2 = mask1.*manip1;
	im2 = abs(ifft2(ifftshift(manip2)));
	stim(k,:,:,cc) = im2(1:stimw,1:stimh);
end

end

stim = stim/std(stim(:));
end

