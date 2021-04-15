function bars=GenerateTernaryStim_test(p, tilt)

if p>.5
    error('p is too large')
end

rgb_gray=[.7,0.7,0.7]; %degree of greyness
res=30; %resolution of bars
randseed=rand(1,res); %random seed for bars
barmat=ones(1,res);

for i=1:res
  h = bar(i, barmat(i), 'histc');
  if i == 1, hold on, end
  if randseed(i) <= p
    col = 'k';
  elseif randseed(i) >= 1-p
    col = 'w';
  else
      col = rgb_gray;
  end
  set(h, 'FaceColor', col)
  set(h, 'LineStyle', 'none')
end
axis off
