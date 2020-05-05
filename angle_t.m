function res = angle_t(theta_i, eps_wall, EPS_0)
    res = asin(sqrt(EPS_0/eps_wall) * sin(theta_i));
end
