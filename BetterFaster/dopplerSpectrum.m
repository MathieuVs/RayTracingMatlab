function dopplerSpectrum

    speed = 0:0.01:1;
    incidence_angle = 0:pi/100:pi;
    
    omega_max = PrjCst.beta .* speed;
    omega_D = repmat(omega_max',1,length(incidence_angle)) .* cos(incidence_angle);
    
    coherence_time = PrjCst.lambda./(2.*speed);
    
    spectrum = 1./(omega_max'.*sqrt(1-(omega_D./omega_max').^2));
    
    figure;
    plot(speed,coherence_time)
    
    
    figure;
    [X,Y] = meshgrid(incidence_angle,speed);
    surf(X,Y,spectrum)
    
    