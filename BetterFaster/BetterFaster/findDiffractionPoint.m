function [possible, resX, resY] = findDiffractionPoint(xs,ys,xr,yr,walls)
nCross = 0;
crossWall = nan;
maxDist = 0;
for w = 1:size(walls)
    [res, x,y] = walls(w).intersect(xs,ys,xr,yr);
    nCross = nCross + res;
    if res && dist(xs,ys,x,y) > maxDist
        crossWall = w;
        maxDist = dist(xs,ys,x,y);
    end
end
resX = nan;
resY = nan;
possible = 0;
if nCross > 1
    not1 = 0;
    not2 = 0;
    for w = 1:size(walls)
        [res1, x1,y1] = walls(w).intersect(xs,ys,walls(crossWall).X1,walls(crossWall).Y1);
        [res2, x2,y2] = walls(w).intersect(walls(crossWall).X1,walls(crossWall).Y1,xr,yr);
        if res1 && ((abs(x1-walls(w).X1 + y1-walls(w).Y1)>1e-3) && (abs(x1-walls(w).X2 + y1-walls(w).Y2)>1e-3))
            not1 = 1;
        end
        if res2 && ((abs(x2-walls(w).X1 + y2-walls(w).Y1)>1e-3) && (abs(x2-walls(w).X2 + y2-walls(w).Y2)>1e-3))
            not1 = 1;
        end
        [res1, x1,y1] = walls(w).intersect(xs,ys,walls(crossWall).X2,walls(crossWall).Y2);
        [res2, x2,y2] = walls(w).intersect(walls(crossWall).X2,walls(crossWall).Y2,xr,yr);
        if res1 && ((abs(x1-walls(w).X1 + y1-walls(w).Y1)>1e-3) && (abs(x1-walls(w).X2 + y1-walls(w).Y2)>1e-3))
            not2 = 1;
        end
        if res2 && ((abs(x2-walls(w).X1 + y2-walls(w).Y1)>1e-3) && (abs(x2-walls(w).X2 + y2-walls(w).Y2)>1e-3))
            not2 = 1;
        end
    end
    
    if not1 == 0
        resX = walls(crossWall).X1;
        resY = walls(crossWall).Y1;
        possible = 1;
    end
    if not2 == 0
        resX = walls(crossWall).X2;
        resY = walls(crossWall).Y2;
        possible = 1;
    end
    
end