function res = isVertical(x1, y1, x2, y2)
    res = 0;
    if ((x1 == x2) && (y1 ~= y2))
        %Vertical segment
        res = 1;
    elseif ((x1 ~= x2) && (y1==y2))
        %Horizontal segment
        res = 2;
    end

end
