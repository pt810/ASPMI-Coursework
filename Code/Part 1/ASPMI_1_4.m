%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
%close all;
clear all;
clc;

%% (b) Initialization and Processing

N1 = 1000;
n1 = 1:N1;
sig1 = randn(size(n1));

sig1(1) = sig1(1);
sig1(2) = 2.76*sig1(1) + sig1(2);
sig1(3) = 2.76*sig1(2) - 3.81*sig1(1) + sig1(3);
sig1(4) = 2.76*sig1(3) - 3.81*sig1(2) + 2.65*sig1(1) + sig1(4);

for i = 5:N1
 sig1(i) = 2.76*sig1(i-1) - 3.81*sig1(i-2) + 2.65*sig1(i-3) - 0.92*sig1(i-4) + sig1(i);
end

sig1 = sig1(501:end);

p_values = 2:14;
psd_estimates1 = zeros(length(p_values), N1/2);
a_orig1 = [2.76 -3.81 2.65 -0.92];
psd_orig1 = freqz(1 , [1 -a_orig1], N1/2);
for i=1:length(p_values)
    [a,e] = aryule(sig1,p_values(i));
    [psd_estimates1(i,:),~] = freqz(e^(1/2),a,N1/2);
end

norm_freq1 = linspace(0,1,length(psd_orig1));

figure
subplot(1,2,1)
hold on
plot(norm_freq1,pow2db(abs(psd_estimates1(2,:)').^2), 'linewidth',2)
plot(norm_freq1,pow2db(abs(psd_estimates1(4,:)').^2), 'linewidth',2)
plot(norm_freq1,pow2db(abs(psd_estimates1(8,:)').^2), 'linewidth',2)
plot(norm_freq1,pow2db(abs(psd_estimates1(11,:)').^2), 'linewidth',2)
plot(norm_freq1,pow2db(abs(psd_orig1).^2), 'linewidth',2) 
xlim([0 0.5])
grid minor
xlabel('Normalised Frequency (cycles/sample)')
ylabel('PSD (dB)')
legend('AR(2)','AR(4)','AR(8)','AR(11)','Original')
title('PSD Estimate (500 Samples)')
hold off

%% (c) Initialization and Processing

N2 = 10000;
n2 = 1:N2;
sig2 = randn(size(n2));

sig2(1) = sig2(1);
sig2(2) = 2.76*sig2(1) + sig2(2);
sig2(3) = 2.76*sig2(2) - 3.81*sig2(1) + sig2(3);
sig2(4) = 2.76*sig2(3) - 3.81*sig2(2) + 2.65*sig2(1) + sig2(4);

for i = 5:N2
 sig2(i) = 2.76*sig2(i-1) - 3.81*sig2(i-2) + 2.65*sig2(i-3) - 0.92*sig2(i-4) + sig2(i);
end

sig2 = sig2(501:end);

psd_estimates2 = zeros(length(p_values), N2/2);
a_orig2 = [2.76 -3.81 2.65 -0.92];
psd_orig2 = freqz(1 , [1 -a_orig2], N2/2);
for i=1:length(p_values)
    [a,e] = aryule(sig2,p_values(i));
    [psd_estimates2(i,:),~] = freqz(e^(1/2),a,N2/2);
end

norm_freq2 = linspace(0,1,length(psd_orig2));

subplot(1,2,2)
hold on
plot(norm_freq2,pow2db(abs(psd_estimates2(2,:)').^2), 'linewidth',2)
plot(norm_freq2,pow2db(abs(psd_estimates2(4,:)').^2), 'linewidth',2)
plot(norm_freq2,pow2db(abs(psd_estimates2(8,:)').^2), 'linewidth',2)
plot(norm_freq2,pow2db(abs(psd_estimates2(11,:)').^2), 'linewidth',2)
plot(norm_freq2,pow2db(abs(psd_orig2).^2), 'linewidth',2) 
xlim([0 0.5])
grid minor
xlabel('Normalised Frequency (cycles/sample)')
ylabel('PSD (dB)')
legend('AR(2)','AR(4)','AR(8)','AR(11)','Original')
title('PSD Estimate (9500 Samples)')
hold off