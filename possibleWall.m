function res = possibleWall(xs, ys, xl1, yl1, xl2, yl2, xn1, yn1, xn2, yn2)
    res=0;
    
    if (isVertical(xl1,yl1,xl2,yl2) == 2)
        if ((isVertical(xn1,yn1,xn2,yn2) == 2) && ((ys-yl1) * (yn1-yl1) >= 0))
            res= 1;
        end
        if ((isVertical(xn1,yn1,xn2,yn2) == 1) && ((ys-yl1) * (yn1-yl1) >= 0) && ((ys-yl1) * (yn2-yl1) >= 0))
            res= 1;
        end
    end
    
    if (isVertical(xl1,yl1,xl2,yl2) == 1)
        if ((isVertical(xn1,yn1,xn2,yn2)== 1) && ((xs-xl1) * (xn1-xl1) >= 0))
            res= 1;
        end
        if ((isVertical(xn1,yn1,xn2,yn2) == 2) && ((xs-xl1) * (xn1-xl1) >= 0) && ((xs-xl1) * (xn2-xl1) >= 0))
            res= 1;
        end
    end
    
end
