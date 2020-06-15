function Power = mainRay(xmax, ymax, Walls, Antennas, borderBox, reflectBox, STEP, app)
timeS = tic;
nWalls = size(Walls,1);
nAntennas = size(Antennas,1);
Antennas = [Antennas(1)+PrjCst.lambda/4, Antennas(2);Antennas(1)-PrjCst.lambda/4, Antennas(2)]
[borderCells, reflectCells] = boderCheck(borderBox,reflectBox,xmax,ymax,STEP);

[Sources]= sourceCreator(Walls, Antennas);
Power = powerSigna( xmax,  ymax, Walls, Sources,Antennas,STEP, app, reflectCells, borderCells);

%pathLos = pathLoss( 6,  1, 6, 16, Walls, Sources, Antennas,2000);
%semilogx(db(pathLos,'power'));
figure
%makeGraph(Power,xmax, ymax, Walls, nWalls, Antennas, nAntennas,0.01)
log_power=10* log10(Power/0.001);

save('power','log_power');
disp(['Enlapsed : ' num2str(toc(timeS))]);

hold on
imagesc([STEP/2 xmax-STEP/2],[STEP/2 ymax-STEP/2],log_power)
colorbar
colormap jet
axis([0 xmax 0 ymax])

%heatmap(y,x , log(Power),'Colormap',jet,'GridVisible','off');
%line([app.walls(1,1),app.walls(1,3)],[app.walls(1,2),app.walls(1,4)]);
for k=1:nWalls
    plot([Walls(k).X1,Walls(k).X2],[Walls(k).Y1,Walls(k).Y2],'k')
end
for k=1:nAntennas
    scatter(Antennas(k,1),Antennas(k,2), 'k')
end
end