function [y] = roundn(x, n)

y = round(x/(10^n))*(10^n);


return;
