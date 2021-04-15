function [plotHandle] = plotsats(varargin)

for i = 1:numel(varargin)
	plotHandle = scatter3(varargin{i}(:,1),varargin{i}(:,2),varargin{i}(:,3));
	hold on
end
hold off
end