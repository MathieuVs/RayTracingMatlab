function res = possibleWall(xs, ys, xl1, yl1, xl2, yl2, xn1, yn1, xn2, yn2)
    res=0;
    %Horizontal walls
    if ((isVertical(xl1,yl1,xl2,yl2)==2) && (isVertical(xn1,yn1,xn2,yn2)==2))
        if ((ys-yl1) * (yn1-yl1) >= 0)
            res= 1;
        end
    end
    
    %Vertical walls
    if ((isVertical(xl1,yl1,xl2,yl2)== 1) && (isVertical(xn1,yn1,xn2,yn2)== 1))
        if ((xs-xl1) * (xn1-xl1) >= 0)
            res= 1;
        end
    end
    
end
