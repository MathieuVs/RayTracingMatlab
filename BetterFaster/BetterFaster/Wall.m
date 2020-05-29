classdef Wall
    %Wall contains all inforamation about a wall
    
    properties
        X1
        X2
        Y1
        Y2
        Epsilon
        Sigma
        Thickness
    end
    
    methods
        function obj = Wall(X1,Y1,X2,Y2,Epsilon,Sigma,Thickness)
            obj.X1 = X1;
            obj.X2 = X2;
            obj.Y1 = Y1;
            obj.Y2 = Y2;
            obj.Epsilon = Epsilon;
            obj.Sigma = Sigma;
            obj.Thickness = Thickness;
            
        end
        
        function result = angle_i(obj,x1, y1, x2, y2)
            vdx = obj.X2-obj.X1; vdy = obj.Y2-obj.Y1;
            vgx = x2-x1; vgy = y2-y1;
            prod = vdx*vgx + vdy*vgy;

            normvd = sqrt(vdx*vdx + vdy*vdy);
            normvg = sqrt(vgx*vgx + vgy*vgy);

            res = acos(prod/(normvd*normvg));
            res = pi/2 - res;

            result = abs(res);
        end
        
        function res = angle_t(obj, theta_i)
            res = asin(sqrt(PrjCst.EPS_0/obj.Epsilon) * sin(theta_i));
        end
        
        function [res,xp,yp] = intersect( obj, x1, y1, x2, y2)
            res = 0;
            xp = 0.0;
            yp = 0.0;

            %Intersection between 2 lines
            if ((obj.X1 ~= obj.X2) && (x1 ~= x2))
                ad = (obj.Y2 - obj.Y1)/(obj.X2 - obj.X1);
                bd = obj.Y1 - obj.X1*(obj.Y2 - obj.Y1)/(obj.X2 - obj.X1);
                ag = (y2 - y1)/(x2 - x1);
                bg = y1 - x1*(y2 - y1)/(x2 - x1);

                if (ad ~= ag)
                    xp = (bd - bg)/(ag - ad);
                    yp = ad * (xp) + bd;
                    res = 1;
                end
            elseif ((obj.X1 == obj.X2) && (x1 ~= x2))
                ag = (y2 - y1)/(x2 - x1);
                bg = y1 - x1*(y2 - y1)/(x2 - x1);
                xp = obj.X1;
                yp = ag * (xp) + bg;
                res  = 1;
            elseif ((x1 == x2) && (obj.X1 ~= obj.X2))
                ad = (obj.Y2 - obj.Y1)/(obj.X2 - obj.X1);
                bd = obj.Y1 - obj.X1*(obj.Y2 - obj.Y1)/(obj.X2 - obj.X1);
                xp = x1;
                yp = ad * (xp) + bd;
                res = 1;
            end

            %Intersection between 2 segments
            if(res==1)
                if (obj.X2 < obj.X1)
                    copy = obj.X1;
                    obj.X1 = obj.X2;
                    obj.X2 = copy;
                end
                if (obj.Y2 < obj.Y1)
                    copy = obj.Y1;
                    obj.Y1 = obj.Y2;
                    obj.Y2 = copy;
                end
                if((xp < obj.X1) || (xp > obj.X2))
                    res =  0;
                end
                if((yp < obj.Y1) || (yp > obj.Y2))
                    res =  0;
                end

                if (x2 < x1)
                    copy = x1;
                    x1 = x2;
                    x2 = copy;
                end
                if (y2 < y1)
                    copy = y1;
                    y1 = y2;
                    y2 = copy;
                end
                if((xp < x1) || (xp > x2))
                    res =  0;
                end
                if((yp < y1) || (yp > y2))
                    res =  0;
                end
            end

        end
        
        function res = isVertical(obj)
            res = 0;
            if ((obj.X1 == obj.X2) && (obj.Y1 ~= obj.Y2))
                %Vertical segment
                res = 1;
            elseif ((obj.X1 ~= obj.X2) && (obj.Y1==obj.Y2))
                %Horizontal segment
                res = 2;
            end
        end
        
        function res = possibleWall(obj, xs, ys, otherWall)
            res=0;

            if (obj.isVertical() == 2)
                if ((otherWall.isVertical() == 2) && ((ys-obj.Y1) * (otherWall.Y1-obj.Y1) >= 0))
                    res= 1;
                end
                if ((otherWall.isVertical() == 1) && ((ys-obj.Y1) * (otherWall.Y1-obj.Y1) >= 0) && ((ys-obj.Y1) * (otherWall.Y2-obj.Y1) >= 0))
                    res= 1;
                end
            end

            if (obj.isVertical() == 1)
                if ((otherWall.isVertical()== 1) && ((xs-obj.X1) * (otherWall.X1-obj.X1) >= 0))
                    res= 1;
                end
                if ((otherWall.isVertical() == 2) && ((xs-obj.X1) * (otherWall.X1-obj.X1) >= 0) && ((xs-obj.X1) * (otherWall.X2-obj.X1) >= 0))
                    res= 1;
                end
            end

        end
        
        function r = reflection(obj,x1, y1, x2, y2)
            theta_i = obj.angle_i(x1, y1, x2, y2);
            theta_t = obj.angle_t(theta_i);

            eps_tilde = obj.Epsilon - 1i*(obj.Sigma/PrjCst.pulsation);

            R_perp = obj.coeffPerp(theta_i, theta_t);
            s = obj.Thickness / cos(theta_t);
            gamma_m = 1i * PrjCst.pulsation * sqrt(PrjCst.MU_0*eps_tilde);
            beta = PrjCst.pulsation/PrjCst.C;

            NUM = R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
            DEN = 1 - R_perp*R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
            r = R_perp + (1 - R_perp * R_perp) * NUM/DEN;
        end
        
        function r_perp = coeffPerp(ojb, theta_i, theta_t)
    
            Z1 = sqrt(PrjCst.MU_0/PrjCst.EPS_0);
            Z2 = sqrt(PrjCst.MU_0/ojb.Epsilon);
            r_perp = (Z2*cos(theta_i) - Z1*cos(theta_t)) / (Z2*cos(theta_i) + Z1*cos(theta_t));
        end
        
        function r = transmission(obj, x1, y1, x2, y2)
            theta_i = obj.angle_i(x1, y1, x2, y2);
            theta_t = obj.angle_t(theta_i);

            eps_tilde = obj.Epsilon - 1i*(obj.Sigma/PrjCst.pulsation);
            
            R_perp = obj.coeffPerp(theta_i, theta_t);
            s = obj.Thickness / cos(theta_t);
            gamma_m = 1i * PrjCst.pulsation * sqrt(PrjCst.MU_0*eps_tilde);
            beta = PrjCst.pulsation/PrjCst.C;
            
            NUM = (1-R_perp*R_perp) * exp(-gamma_m*s);
            DEN = 1 - R_perp*R_perp * exp(-2*gamma_m*s) * exp(1i*2*beta*s*sin(theta_t)*sin(theta_i));
            r=NUM/DEN;
        end
        
        function [xi,yi] = sym_orth(obj, xs, ys)
            res=1;
             if(obj.X1==obj.X2)
                xi = xs + 2*(obj.X1-xs);
                yi = ys;
                res= 0;
             elseif (obj.Y1==obj.Y2)
                xi = xs;
                yi = ys + 2*(obj.Y1-ys);
                res = 0;
             end
             if(res==1)
                error("\n ERROR : no symetry possible from TR_global\n\n");
             end

        end
        
    end
end

