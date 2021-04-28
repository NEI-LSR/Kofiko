%test stimulus side textures

choiceThetas = [0:(2*pi)/24:(2*pi) - .01];
choiceRho = 300;

[x,y] = pol2cart(choiceThetas, choiceRho);
x = x + 384;
y = y + 512;
for i = 1:24
targetRect(i,:) = round([x(i) - 30/2; ...
y(i) - 30/2; ...
(x(i) + 30/2)-1; ...
(y(i) + 30/2)-1]);
end


Screen('DrawTextures', g_strctPTB.m_hWindow, g_strctDraw.m_ahDiscTextures(:, 1)', [] ,targetRect');
 ClutEncoded = BitsPlusEncodeClutRow( repmat(ones(256,1) .* [0:256:65535]',[1,3]) );
    ClutTextureIndex = Screen( 'MakeTexture', g_strctPTB.m_hWindow, ClutEncoded );
    
	Screen('DrawTexture', g_strctPTB.m_hWindow, ClutTextureIndex, [], [0, 0, 524, 1] );
Screen('Flip', g_strctPTB.m_hWindow)

