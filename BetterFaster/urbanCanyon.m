function pathLoss = urbanCanyon(height,width,dmin,dmax,nStep,epsilon_Wall,epsilon_Ground)
Ra = 73;
Z0 = 376.730;
dist = logspace(log10(dmin),log10(dmax),nStep);
E_dir = -1j .* Z0 ./ (2*pi) .* exp(-1j.*PrjCst.beta.*dist) ./ dist;

theta_1 = pi/2 - atan(2*width./dist);
dist_1 = sqrt(4*width^2 + dist.^2);
coef_1 = coefPerpCalc(theta_1,epsilon_Wall);
E_1   = -1j .* coef_1 .* Z0 ./ (2*pi) .* exp(-1j.*PrjCst.beta.*dist_1) ./ dist_1;

theta_2 = pi/2 - atan(4*width./dist);
dist_2 = sqrt(16*width^2 + dist.^2);
coef_2 = coefPerpCalc(theta_2,epsilon_Wall).^2;
E_2   = -1j .* coef_2 .* Z0 ./ (2*pi) .* exp(-1j.*PrjCst.beta.*dist_2) ./ dist_2;

theta_g = pi/2 - atan(2*height./dist);
dist_g = sqrt(4*height^2 + dist.^2);
coef_g = coefParCalc(theta_g,epsilon_Ground);
E_g   = -1j .* coef_g .* Z0 ./ (2*pi) .* exp(-1j.*PrjCst.beta.*dist_g) ./ dist_g;

V_oc_dir = 2./(PrjCst.beta) .* E_dir;
V_oc_1 = 2./(PrjCst.beta) .* E_1;
V_oc_2 = 2./(PrjCst.beta) .* E_2;
V_oc_g = 2./(PrjCst.beta) .* E_g .* (cos((pi/2)*cos(pi-theta_g)))/sin(pi-theta_g);

V_oc = V_oc_dir + V_oc_g + 2.*V_oc_1 + 2.*V_oc_2;
% V_oc = E_dir + E_g + 2.*E_1 + 2.*E_2;

pathLoss = 4 .* Ra^2 .* 1./(abs(V_oc).^2);
figure;
hold on
plot(log10(dist),10.*log10(pathLoss));
N = 3;
L_0 = 10*log10(sum(medfilt1(pathLoss(1:N)))/N);
L_end = 10*log10(sum(medfilt1(pathLoss(end-N+1:end)))/N);
n = (L_0-L_end)/(10*log10(dist(2)/dist(end-1)));
plot(log10(dist),L_0 + 10.*n.*log10(dist/dist(1)));
title('Path loss (urban canyon model)');
xlabel('log(d)');
ylabel('path loss [dB]');
legend(['Urban canyon model','path loss exponent = ' num2str(n)]);

figure;
hold on
plot(log10(dist),10.*log10(1000./pathLoss));
title('Power (Ptx = 1W)');
xlabel('log(d)');
ylabel('Prx [dBm]');

cellRange(L_0,dist(2),n)
end

function coef = coefPerpCalc(theta_i, epsilon)
    epsilon_r = epsilon/PrjCst.EPS_0;
    NUM = cos(theta_i) - sqrt(epsilon_r) * sqrt(1-(1/epsilon_r)*(sin(theta_i)).^2);
    DEN = cos(theta_i) + sqrt(epsilon_r) * sqrt(1-(1/epsilon_r)*(sin(theta_i)).^2);
    coef = NUM./DEN;
end

function coef = coefParCalc(theta_i, epsilon)
    epsilon_r = epsilon/PrjCst.EPS_0;
    NUM = cos(theta_i) - (1/sqrt(epsilon_r)) * sqrt(1-(1/epsilon_r)*(sin(theta_i)).^2);
    DEN = cos(theta_i) + (1/sqrt(epsilon_r)) * sqrt(1-(1/epsilon_r)*(sin(theta_i)).^2);
    coef = NUM./DEN;
end