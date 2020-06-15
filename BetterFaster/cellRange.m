function cellRange(L0,d0,n)

proba = 0.01:0.01:0.99;

fadingVar = 0.65*(log10(PrjCst.freq*1e-6))^2 - 1.3*log10(PrjCst.freq*1e-6) + 5.2;

tempearature = 290;
bandWidth = 200e6;
k_b = 1.38064852 * 1e-23;

EIRP_max = 3; %2W in dB

thermal_noise = 10*log10(k_b * bandWidth * tempearature); % in dB
noise_fig = 10; %in dB
target_SNR = 8; % in dB
receiver_sens = thermal_noise + noise_fig + target_SNR;

fade_margin = fadingVar.*sqrt(2) .* erfcinv(2.*proba);
interference_margin = 4;
indor_penetration = 0;
body_loss = 0;
total_margin = fade_margin + interference_margin + indor_penetration + body_loss;

Max_pathLoss = EIRP_max - receiver_sens - total_margin;
Max_radius = exp((Max_pathLoss - L0)./(10*n)).*d0;%compare to path loss (considered L0 + 10*n*log10(d/d0)

a = fade_margin./(sqrt(2)*fadingVar);
b = 1/(sqrt(2)*fadingVar)*10*n*log10(exp(1));

perc_cell_cov = 1 - 1/2 .* erfc(a) + 1./2.*exp(2.*a./b+1/b^2).*erfc(a+1/b);

% figure
% plot(proba,fade_margin)
% figure
% scatter(fade_margin/fadingVar,log(proba))
figure
plot(1-proba,Max_radius)
title('Cell range')
ylabel('Cell maximum radius[m]')
xlabel('Probability of connection at cell edge')
figure
plot(Max_radius,perc_cell_cov)
title('Probability of coverage')
ylabel('Probability of coverage through the whole cell')
xlabel('Cell radius')