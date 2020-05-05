function r_perp = reflectionCoeffPerp(theta_i, theta_t, eps, MU_0, EPS_0)
    
    Z1 = sqrt(MU_0/EPS_0);
    Z2 = sqrt(MU_0/eps);
    r_perp = (Z2*cos(theta_i) - Z1*cos(theta_t)) / (Z2*cos(theta_i) + Z1*cos(theta_t));
end





