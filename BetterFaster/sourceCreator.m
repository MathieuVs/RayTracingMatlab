function [SourceOut]= sourceCreator(Walls, Antennas)
    nWalls = size(Walls,1);
    nAntennas = size(Antennas,1);

    MAX_REFLECTIONS = 3;
    
    
    nRef = 0;
    nSources = 1;
    
    nSourcesInit = nAntennas * (1 + nWalls + nWalls*nWalls + nWalls*nWalls*nWalls);
    Sources = zeros(nSourcesInit,6);
    
    % Création de point source pour chaque antennes
    for  j = 1 : nAntennas
        Sources(j,1) = Antennas(j,1);
        Sources(j,2) = Antennas(j,2);
        nSources = nSources+ 1;
        
        % Création des premières réflexions
        if(nRef < MAX_REFLECTIONS)
            xs = Sources(j,1);
            ys = Sources(j,2);
            for i = 1 : nWalls
                [xi,yi]=Walls(i).sym_orth(xs, ys);
                Sources(i + j + nAntennas-1,1) = xi;
                Sources(i + j + nAntennas-1,2) = yi;
                Sources(i + j + nAntennas-1,3) = nRef + 1;
                Sources(i + j + nAntennas-1,4) = i;
                nSources = nSources + 1;
            end
        end
    end
    
    %second and third reflections
    if(size(Sources,1)>nAntennas)
    index = nAntennas+1;
    nRef = 1;
    while(nRef < MAX_REFLECTIONS)
        xs = Sources(index,1);
        ys = Sources(index,2);
        nRef = Sources(index,3);
        lastWall = Sources(index,3+nRef);
        wall1 = Sources(index,4);
        wall2 = Sources(index,5);
        if (lastWall==0)
            nRef=MAX_REFLECTIONS;
        else
        for i = 1 : nWalls
            %cond=0;
            %if(lastWall ~= 0)
               cond=  Walls(lastWall).possibleWall(xs, ys, Walls(i));
            %end
            if ((lastWall ~= i) && cond==0)
                [xi,yi]=Walls(i).sym_orth( xs, ys);
                Sources(nSources,1) = xi;
                Sources(nSources,2) = yi;
                Sources(nSources,3) = nRef + 1;
                Sources(nSources,4) = wall1;
                Sources(nSources,5) = wall2;
                Sources(nSources,3+nRef+1) = i;
                nSources = nSources + 1;
            end
        end
        index = index + 1;
        nRef = Sources(index,3);
        end
    end 
    end
    
    SourceOut =  Sources(1:nSources-1,:);

end
