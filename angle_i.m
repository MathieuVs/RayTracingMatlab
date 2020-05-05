function result = angle_i(xd1, yd1, xd2, yd2, xg1, yg1, xg2, yg2)
    
    vdx = xd2-xd1; vdy = yd2-yd1;
    vgx = xg2-xg1; vgy = yg2-yg1;
    prod = vdx*vgx + vdy*vgy;
    
    normvd = sqrt(vdx*vdx + vdy*vdy);
    normvg = sqrt(vgx*vgx + vgy*vgy);
    
    res = acos(prod/(normvd*normvg));
    res = pi/2 - res;
    
    result = abs(res);
end
