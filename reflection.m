function r = reflection(theta_i, theta_t, eps, sigma, width,EPS_0, MU_0, pulsation, C)

    eps_tilde = eps - 1i*(sigma/pulsation);
    
    R_perp = reflectionCoeffPerp(theta_i, theta_t, eps, MU_0, EPS_0);
    s = width / cos(theta_t);
    gamma_m = 1i * pulsation * sqrt(MU_0*eps_tilde);
    beta = pulsation/C;
    
    NUM = R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
    DEN = 1 - R_perp*R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
    r = R_perp + (1 - R_perp * R_perp) * NUM/DEN;

