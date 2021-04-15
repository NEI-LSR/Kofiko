function getovernightreadings
try 
	PR655getsyncfreq
catch
	PR655init('COM4')
end
count = 1;
i = 1;
%CP([48735 48725 49170])
readings.time = [];
readings.reading = [];

h1 = figure();
h2 = figure();
h3 = figure();


while i
count = count+1;
time = clock();
		readings.time(end+1,1) = time(4);
		readings.time(end,2) = time(5);
		readings.time(end,3) = time(6);
		[xyY] = JoshReadPR; 
		readings.reading(end+1,1) = xyY(1);
		readings.reading(end,2) = xyY(2);
		readings.reading(end,3) = xyY(3);
		readings.reading(end,3)
		figure(h1)
		plot(readings.reading(:,1))
		drawnow
		figure(h2)
		plot(readings.reading(:,2))
		drawnow
		figure(h3)
		plot(readings.reading(:,3))
		drawnow
if count > 5
	save readings
	count = 1;
end
end