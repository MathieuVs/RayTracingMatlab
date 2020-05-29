function TR = groundRef(dist,groundProp,baseHeight)
    epsilon = groundProp(1);
    sigma = groundProp(2);
    theta_i = atan(dist/(2*baseHeight));
    theta_t = asin(sqrt(PrjCst.EPS_0/epsilon) * sin(theta_i));

    eps_tilde = epsilon - 1i*(sigma/PrjCst.pulsation);

    Z1 = sqrt(PrjCst.MU_0/PrjCst.EPS_0);
    Z2 = sqrt(PrjCst.MU_0/epsilon);
    R_perp = (Z2*cos(theta_i) - Z1*cos(theta_t)) / (Z2*cos(theta_i) + Z1*cos(theta_t));
    %s = obj.Thickness / cos(theta_t); ????
    gamma_m = 1i * PrjCst.pulsation * sqrt(PrjCst.MU_0*eps_tilde);
    beta = PrjCst.pulsation/PrjCst.C;

    NUM = R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
    DEN = 1 - R_perp*R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
    TR = R_perp + (1 - R_perp * R_perp) * NUM/DEN;