function Power = powerSigna( xmax,  ymax, Walls, Sources, Antennas,STEP, app, reflectCells, borderCells)
    nWalls = size(Walls,1);
    nAntennas = size(Antennas,1);
    nSources = size(Sources,1);
    % Progress bar
    %f = app;
    %d = uiprogressdlg(f,'Title','Please Wait',...
    %    'Message','Computing the results');
    %nbIt = 0;
    %d.Value =0;
    
    % Prepare all the reciver positions
    nx = xmax/STEP;
    ny = ymax/STEP;
    
    % Initialise the power array
    Power=zeros(ny,nx);
    
    % Antenna parameters
    Ra = 73; % resistance antenne p 94 sylla !!!   % May be to remove in power equation to compute EIRP
    he = PrjCst.lambda/pi; % hauteur équivalente
    %GTX = sqrt(PrjCst.MU_0/PrjCst.EPS_0)/(pi*Ra); % Gain antenne
    %PTX = 0.1; % PTX = 20 dBm = 0.1W
    %factor = sqrt(60*GTX*PTX);
    EIRP = 2;
    factor = sqrt(60*EIRP);
    
    epsilonG = 4.6*PrjCst.EPS_0;
    baseHeight = 10;
    
    
    % Loop through all the square
    if isempty(gcp('nocreate'))
        parforArg = 0;
    else
        parforArg = Inf;
    end
    parfor (iy = 1 : ny ,parforArg)
        for ix = 1 : nx
            
            if borderCells(ix,iy) == 0
                 Power(iy,ix) = 0;
            else
                Esum = 0.0;

                % Take the center of the cell
                xr = STEP * ix - STEP/2; 
                yr = STEP * iy - STEP/2;

                % Check if we are on the antenna
                onAnt=0;
                for ant=1:nAntennas
                    if(xr==Antennas(ant,1)&&yr==Antennas(ant,2))
                        onAnt=1;
                    end
                end

                % If we are not on the antenna
                if(onAnt==0) 
                    % Loop through the reflected sources
                    for source = 1:nSources

                        E = 0.0; 
                        TR = 1.0;
                        xs = Sources(source,1); ys = Sources(source,2); % source position

                        x1 = xr; y1 = yr;
                        x2 = xs; y2 = ys;
                        
                        % number of reflections for this specific source point
                        nRef = Sources(source , 3);
                        %source
                        wall = -1;
                        
                        if reflectCells(ix,iy) || nRef == 0
                            

                        % Check for REFLECTIONS between source and receptor
                        while nRef > 0
                            wall = Sources(source, 3 + nRef); % wall of last reflection

                            % Check if the reflexion exist (reciver and
                            % tanciver on the same side)
                            [inter,xi,yi] = Walls(wall).intersect( x1, y1, x2, y2);
                            if (inter==1)
                                TR = TR * Walls(wall).reflection(xr, yr, xs, ys);

                                % Check for TRANSMISSION between two reflections
                                for  m = 1 : nWalls
                                    [inters,~,~]=Walls(m).intersect(x1, y1, xi, yi);
                                    if (m ~= wall) && (inters==1)
                                        TR = TR * Walls(m).transmission(xr, yr, xs, ys);
                                    end

                                end

                                % Next values for x1,y1 and x2,y2
                                x1 = xi;
                                y1 = yi;
                                [x2,y2]=Walls(wall).sym_orth(x2,y2);


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
                                [inter,~,~]=Walls(m).intersect(x1, y1, x2, y2);
                                if ((m ~= wall) && (inter==1))
                                    TR = TR * Walls(m).transmission(xr, yr, xs, ys);
                                end

                            end
                            if TR == 1.0
                                TRG = groundRef(dist(xr,yr,xs,ys),epsilonG,baseHeight);
                                d_ray = 2* sqrt((dist(xr,yr,xs,ys)/2)^2 + baseHeight^2);
                                theta_G = pi - pi/2 + atan(2*baseHeight/d_ray);
                                E = TRG * factor * exp(-1i*PrjCst.beta*d_ray) / d_ray * cos(pi/2*cos(theta_G))/(sin(theta_G))^2;
                                Esum =Esum+ E;
                            end
                            if not(reflectCells(ix,iy)) && Sources(source , 3) == 0 && TR ~= 1.0
                                % Difraction
                                d_ray = dist(xr,yr,xs,ys);
                                [possible, resX, resY] = findDiffractionPoint(xs,ys,xr,yr,Walls);
                                if possible
                                    delta_r = (dist(xr,yr,resX,resY)+dist(resX,resY,xs,ys))-d_ray;
                                    nu = sqrt((2*PrjCst.beta*delta_r)/pi);
                                    norm_F = 0.2/(sqrt(((nu-0.1)^2)+1)+nu-0.1)^2;
                                    arg_F = -pi/4 -(pi/2)*nu^2;
                                    F = sqrt(norm_F)*exp(1j*arg_F);
                                    E = F * factor * exp(-1i*PrjCst.beta*d_ray) / d_ray;
                                else
                                    E = 0
                                end
                            else
                                d_ray = dist(xr,yr,xs,ys);
                                E = TR * factor * exp(-1i*PrjCst.beta*d_ray) / d_ray;  % Each source point has its own ray path and TR associated
                            end
                        end
                        %Esum =Esum+ he*norm(E);
                        %Esum =Esum+ abs(E)^2;
                        Esum =Esum+ E;
                        %(*Power)[iy*(nx+1)+ix] += 1/(8*Ra)*he*he*abs(E)*abs(E);
                        end
                    end
                %Power(iy,ix) = 1/(8*Ra)* norm(Esum)^2;
                %Power(iy,ix) = 1/(8*Ra)* he^2 * Esum;
                Power(iy,ix) = 1/(8*Ra)* he^2 * abs(Esum)^2;
                else
                    Power(iy,ix) = 1e-6;
                end
            end
            %nbIt = nbIt +1;
            %d.Value = nbIt/(nx*ny);
        end
    end
end