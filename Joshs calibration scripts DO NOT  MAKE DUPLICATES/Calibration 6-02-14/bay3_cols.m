%after running Thorsten's "runme" program for generating DKL colors
%which spits out the 12 colors for the
%DKL colors of Bay 3, Feb. 2010; assumes linearity. To get the actual gun
%values run thmakelut...


for i=1:( max(size(rgb)))
    
    col=rgb(:,i,:);
    col=col(:);
    color(i, 1:3)=col;
     
end

color=round(color*65535)





















