function [plotHandle] = plotsats(varargin)
figure()
for i = 1:numel(varargin)
	plotHandle = scatter(varargin{i}.xyY(:,1),varargin{i}.xyY(:,2))
	hold on
end
hold off
end