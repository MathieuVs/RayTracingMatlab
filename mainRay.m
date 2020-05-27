function Power = mainRay(xmax, ymax, nWalls, nAntennas, Walls, Antennas, STEP, app)

[nSources, Sources]= sourceCreator(nWalls, nAntennas, Walls, Antennas);
Power = powerSigna( xmax,  ymax,  nWalls,  nSources, Walls, Sources,nAntennas,Antennas,STEP, app);
%makeGraph(Power,xmax, ymax, Walls, nWalls, Antennas, nAntennas,0.01)
log_power=10* log10(Power/0.001);

save('powerP','log_power');

hold on
imagesc([STEP/2 xmax-STEP/2],[STEP/2 ymax-STEP/2],log_power)
colorbar
colormap jet
axis([0 xmax 0 ymax])

%heatmap(y,x , log(Power),'Colormap',jet,'GridVisible','off');
%line([app.walls(1,1),app.walls(1,3)],[app.walls(1,2),app.walls(1,4)]);
for k=1:nWalls
    plot([Walls(k,1),Walls(k,3)],[Walls(k,2),Walls(k,4)],'k')
end
for k=1:nAntennas
    scatter(Antennas(k,1),Antennas(k,2), 'k')
end
end