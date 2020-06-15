function [amp, delay] = phisicalImpulse( xpos,  ypos, Walls, Sources, Antennas)
    nWalls = size(Walls,1);
    nAntennas = size(Antennas,1);
    nSources = size(Sources,1);
    % Progress bar
    %f = app;
    %d = uiprogressdlg(f,'Title','Please Wait',...
    %    'Message','Computing the results');
    %nbIt = 0;
    %d.Value =0;
    
    % Initialise the power array
    amp = [];
    delay = [];
    
    % Antenna parameters
    Ra = 73; % resistance antenne p 94 sylla !!!   % May be to remove in power equation to compute EIRP
    he = 0.019; % hauteur équivalente
    %GTX = sqrt(PrjCst.MU_0/PrjCst.EPS_0)/(pi*Ra); % Gain antenne
    %PTX = 0.1; % PTX = 20 dBm = 0.1W
    %factor = sqrt(60*GTX*PTX);
    EIRP = 2;
    factor = sqrt(60*EIRP);
    
    epsilonG = 4.6*PrjCst.EPS_0;
    baseHeight = 10;

    Esum = 0.0;

    % Take the center of the cell
    xr = xpos;
    yr = ypos;

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
                    E = TRG * factor * exp(-1i*PrjCst.beta*d_ray) / d_ray;
                    amp(end+1) = norm(E); %_________________________________________
                    delay(end+1) = d_ray/PrjCst.C;
                end
                d_ray = dist(xr,yr,xs,ys);
                E = TR * factor * exp(-1i*PrjCst.beta*d_ray) / d_ray;  % Each source point has its own ray path and TR associated
            %Esum =Esum+ he*norm(E);
            amp(end+1) = norm(E); % _____________________________________________ norm squraed or not
            delay(end+1) = d_ray/PrjCst.C;
            %(*Power)[iy*(nx+1)+ix] += 1/(8*Ra)*he*he*abs(E)*abs(E);
            end
        end
        figure;
        hold on
        scatter(delay-min(delay),amp);
        plot([delay-min(delay); delay-min(delay)],[amp; zeros(size(amp))],'k');
        plot([0; max(delay-min(delay))*1.2],[0; 0],'k');
    else
    end
end

