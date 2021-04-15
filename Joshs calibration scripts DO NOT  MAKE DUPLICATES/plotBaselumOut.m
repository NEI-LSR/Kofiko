function out = extractDataFromBaselum(structIn)

figure();
structSize = size(structIn.red,1);
for iSize = 1:structSize
	out(1,iSize) = structIn.red(iSize).xyYcie(3);
	out(2,iSize) = structIn.green(iSize).xyYcie(3);
	out(3,iSize) = structIn.blue(iSize).xyYcie(3);
    if structSize == 4
	out(4,iSize) = structIn.white(iSize).xyYcie(3);
    end

end
xAxis = linspace(0,65000,size(structIn.red,1)-1);
xAxis(end+1) = 65535;
hold on
plot(xAxis,out(1,:),'-r')

plot(xAxis,out(2,:),'-g')
plot(xAxis,out(3,:),'-b')
%plot(xAxis,out(4,:),'-k')


