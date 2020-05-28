function Power = powerSigna( xmax,  ymax,  nWalls,  nSources, Walls, Sources, nAntennas, Antennas,STEP, app)
    
    % CST
    MU_0 = 1.25663706e-6;
    pulsation = 2*3.141593*5e9;
    C = 299792458.0;
    EPS_0 = 8.85418782e-12;
    
    gaby = 1;
    
    f = app;
    d = uiprogressdlg(f,'Title','Please Wait',...
        'Message','Computing the results');
    nbIt = 0;
    d.Value =0;
    
    nx = xmax/STEP;
    ny = ymax/STEP;
    
    Power=zeros(ny,nx);
    beta = pulsation/C;
    lambda = 2 * pi/beta;
    
    % Antenna parameters
    Ra = 73; % resistance antenne p 94 sylla !!!
    he = 0.019; % hauteur équivalente
    GTX = sqrt(MU_0/EPS_0)/(pi*Ra); % Gain antenne
    PTX = 0.1; % PTX = 20 dBm = 0.1W
    factor = sqrt(60*GTX*PTX);
    
    
    % Loop through all the square
    for iy = 1 : ny  
        for ix = 1 : nx
            
            Esum = 0.0;
            
            % Take the center of the cell
            xr = STEP * ix - STEP/2; 
            yr = STEP * iy - STEP/2; % receptor position
            
            % Check if we are on the antenna
            onAnt=0;
            for ant=1:nAntennas
                if(xr==Antennas(ant,1)&&yr==Antennas(ant,2))
                    onAnt=1;
                end
            end
            
            if(onAnt==0) 
                % Loop through the reflected sources
                for source = 1:nSources-1
                    E = 0.0; 
                    TR = 1.0;
                    xs = Sources(source,1); ys = Sources(source,2); % source position

                    x1 = xr; y1 = yr;
                    x2 = xs; y2 = ys;

                    % angle with a vertical wall (0,0) ---> (0,1)
                    theta_iv = angle_i(xr, yr, xs, ys, 0.0, 0.0, 0.0, 1.0);
                    theta_ih = pi/2 - theta_iv;

                    % number of reflections for this specific source point
                    nRef = Sources(source , 3);
                    %source
                    wall = -1;

                    % Check for REFLECTIONS between source and receptor
                    while nRef > 0
                        wall = Sources(source, 3 + nRef); % wall of last reflection
                        
                        % Check if the reflexion exist (reciver and
                        % tanciver on the same side)
                        [inter,xi,yi] = intersect( x1, y1, x2, y2, Walls(wall,1), Walls(wall,2), Walls(wall,3), Walls(wall,4));
                        if (inter==1)

                            theta_i = selectAngle(Walls(wall,1), Walls(wall,2), Walls(wall,3), Walls(wall,4),theta_iv,theta_ih);
                            %theta_i = angle_i(xr, yr, xs, ys, Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4));
                            if gaby == 1
                                theta_t = angle_t(theta_i,Walls(wall,5), EPS_0);
                            else
                                theta_t = theta_i;
                            end

                            TR = TR * reflection(theta_i,theta_t,Walls(wall,5), Walls(wall,6), Walls(wall,7),  EPS_0, MU_0, pulsation, C);

                            % Check for TRANSMISSION between two reflections
                            for  m = 1 : nWalls
                                [inters,~,~]=intersect(x1, y1, xi, yi, Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4));
                                if (m ~= wall) && (inters==1)

                                    theta_i = selectAngle(Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4),theta_iv,theta_ih);
                                    %theta_i = angle_i(xr, yr, xs, ys, Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4));
                                    if gaby == 1
                                        theta_t = angle_t(theta_i,Walls(m,5), EPS_0);
                                    else
                                        theta_t = theta_i;
                                    end

                                    TR = TR * transmission(theta_i,theta_t,Walls(m,5), Walls(m,6), Walls(m,7),EPS_0, MU_0, pulsation, C);
                                end

                            end

                            % Next values for x1,y1 and x2,y2
                            x1 = xi;
                            y1 = yi;
                            [x2,y2,sym]=sym_orth(Walls(wall,1), Walls(wall,2), Walls(wall,3), Walls(wall,4),x2,y2);
                            if(sym==1)
                                error("\n ERROR : no symetry possible from TR_global (power.c)\n\n");

                            end

                        else
                            %source point doesn't contribute (missing intersection)
                            TR = 0.0;
                            break;
                        end
                        nRef=nRef-1;
                    end

                    % Transmission between emitter and the first reflection or direct transmission
                    if (nRef == 0)
                        % Check for transmission between first reflection and antenna
                        for m = 1 : nWalls
                            [inter,~,~]=intersect(x1, y1, x2, y2, Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4));
                            if ((m ~= wall) && (inter==1))

                                theta_i = selectAngle(Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4), theta_iv, theta_ih);
                                %theta_i = angle_i(xr, yr, xs, ys, Walls(m,1), Walls(m,2), Walls(m,3), Walls(m,4));
                                if gaby == 1
                                    theta_t = angle_t(theta_i,Walls(m,5), EPS_0);
                                else
                                    theta_t = theta_i;
                                end


                                TR = TR * transmission(theta_i,theta_t,Walls(m,5),Walls(m,6),Walls(m,7),EPS_0, MU_0, pulsation, C);

                            end
                        end
                        d_ray = dist(xr,yr,xs,ys);
                        E = TR * factor * exp(-1i*beta*d_ray) / d_ray;  % Each source point has its own ray path and TR associated
                    end

                    %Esum =Esum+ he*norm(E);
                    Esum =Esum+ norm(E)^2;
                    %(*Power)[iy*(nx+1)+ix] += 1/(8*Ra)*he*he*abs(E)*abs(E);
                end
            %Power(iy,ix) = 1/(8*Ra)* norm(Esum)^2;
            Power(iy,ix) = 1/(8*Ra)* he^2 * Esum;
            else
                Power(iy,ix) = 1e-6;
            end
            nbIt = nbIt +1;
            d.Value = nbIt/(nx*ny);
        end
    end
end