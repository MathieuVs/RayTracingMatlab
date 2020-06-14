function TR = groundRef(dist,epsilon,baseHeight)
    theta_i = pi/2 - atan((2*baseHeight)/dist);
    epsilon_r = epsilon/PrjCst.EPS_0;
   

    NUM = cos(theta_i) - sqrt(epsilon_r-(sin(theta_i))^2);
    DEN = cos(theta_i) + sqrt(epsilon_r-(sin(theta_i))^2);
    TR = NUM/DEN;