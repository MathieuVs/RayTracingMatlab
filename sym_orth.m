function [xi,yi,res] = sym_orth(xd1, yd1, xd2, yd2, xs, ys)
    res=1;
     if(xd1==xd2)
        xi = xs + 2*(xd1-xs);
        yi = ys;
        res= 0;
     elseif (yd1==yd2)
        xi = xs;
        yi = ys + 2*(yd1-ys);
        res = 0;
     end

end
