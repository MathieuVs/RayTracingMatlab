function theta_i = selectAngle(xw1, yw1, xw2, yw2, theta_iv, theta_ih)
    
    if (isVertical(xw1, yw1, xw2, yw2) == 1)
        theta_i = theta_iv;
    elseif (isVertical(xw1, yw1, xw2, yw2) == 2)
        theta_i = theta_ih;
    end

end
