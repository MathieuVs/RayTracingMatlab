function [res,xp,yp] = intersect( xd1, yd1, xd2, yd2, xg1, yg1, xg2, yg2)
    res = 0;
    xp = 0.0;
    yp = 0.0;
    
    %Intersection between 2 lines
    if ((xd1 ~= xd2) && (xg1 ~= xg2))
        ad = (yd2 - yd1)/(xd2 - xd1);
        bd = yd1 - xd1*(yd2 - yd1)/(xd2 - xd1);
        ag = (yg2 - yg1)/(xg2 - xg1);
        bg = yg1 - xg1*(yg2 - yg1)/(xg2 - xg1);
        
        if (ad ~= ag)
            xp = (bd - bg)/(ag - ad);
            yp = ad * (xp) + bd;
            res = 1;
        end
    elseif ((xd1 == xd2) && (xg1 ~= xg2))
        ag = (yg2 - yg1)/(xg2 - xg1);
        bg = yg1 - xg1*(yg2 - yg1)/(xg2 - xg1);
        xp = xd1;
        yp = ag * (xp) + bg;
        res  = 1;
    elseif ((xg1 == xg2) && (xd1 ~= xd2))
        ad = (yd2 - yd1)/(xd2 - xd1);
        bd = yd1 - xd1*(yd2 - yd1)/(xd2 - xd1);
        xp = xg1;
        yp = ad * (xp) + bd;
        res = 1;
    end
    
    %Intersection between 2 segments
    if(res==1)
        if (xd2 < xd1)
            copy = xd1;
            xd1 = xd2;
            xd2 = copy;
        end
        if (yd2 < yd1)
            copy = yd1;
            yd1 = yd2;
            yd2 = copy;
        end
        if((xp < xd1) || (xp > xd2))
            res =  0;
        end
        if((yp < yd1) || (yp > yd2))
            res =  0;
        end
        
        if (xg2 < xg1)
            copy = xg1;
            xg1 = xg2;
            xg2 = copy;
        end
        if (yg2 < yg1)
            copy = yg1;
            yg1 = yg2;
            yg2 = copy;
        end
        if((xp < xg1) || (xp > xg2))
            res =  0;
        end
        if((yp < yg1) || (yp > yg2))
            res =  0;
        end
    end
    


end