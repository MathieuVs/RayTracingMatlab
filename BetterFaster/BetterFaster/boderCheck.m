function [borderCells, reflectCells] = boderCheck(borderBox,reflectBox,maxX,maxY,STEP)
    borderCells = ones(maxX/STEP, maxY/STEP);
    for ii = 1 : maxX/STEP
        for jj = 1 : maxY/STEP
            x = ii*STEP-STEP/2;
            y = jj*STEP-STEP/2;
            for b = 1 : size(borderBox,1)
                if (x - borderBox(b,1))*(x - borderBox(b,3)) <= 0 && (y - borderBox(b,2))*(y - borderBox(b,4)) <= 0
                    borderCells(ii,jj) = 0;
                end
            end
        end
    end
    
    reflectCells = ones(maxX/STEP, maxY/STEP);
    for ii = 1 : maxX/STEP
        for jj = 1 : maxY/STEP
            x = ii*STEP-STEP/2;
            y = jj*STEP-STEP/2;
            for b = 1 : size(reflectBox,1)
                if (x - reflectBox(b,1))*(x - reflectBox(b,3)) <= 0 && (y - reflectBox(b,2))*(y - reflectBox(b,4)) <= 0
                    reflectCells(ii,jj) = 0;
                end
            end
        end
    end