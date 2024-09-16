%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
close all;
clear all;
clc;

%% Initialization

fs = 1;

n1 = 25;
time_vector1 = (0: n1 - 1);
freq_vector1 = time_vector1 ./ (2 * n1) .* fs;

n2 = 81;
time_vector2 = (0: n2 - 1);
freq_vector2 = time_vector2 ./ (2 * n2) .* fs;

n3 = 206;
time_vector3 = (0: n3 - 1);
freq_vector3 = time_vector3 ./ (2 * n3) .* fs;

z1 = exp(1j*2*pi*0.3*time_vector1)+exp(1j*2*pi*0.32*time_vector1);
z2 = exp(1j*2*pi*0.3*time_vector2)+exp(1j*2*pi*0.32*time_vector2);
z3 = exp(1j*2*pi*0.3*time_vector3)+exp(1j*2*pi*0.32*time_vector3);

%% Periodogram Generation

psd1 = periodogram(z1,hamming(n1),n1,fs);
psd2 = periodogram(z2,hamming(n2),n2,fs);
psd3 = periodogram(z3,hamming(n3),n3,fs);

%% Plot Graphs

figure;
hold on;
plot(freq_vector1,psd1,'LineWidth',2);
plot(freq_vector2,psd2,'LineWidth',2);
plot(freq_vector3,psd3,'LineWidth',2);
grid minor;
xlabel('Normalised Frequency (cycles/sample)');
ylabel('PSD');
title('Periodogram of Complex Exponentials');
legend('25 samples', '52 samples', '206 samples');
xlim([0.1,0.25]);

figure;
subplot(3,1,1);
plot(time_vector1,real(z1),'LineWidth',2);
grid minor;
xlim([0,24]);
xlabel('Sample');
ylabel('Amplitude');
title('Complex Exponential (n = 25)');
subplot(3,1,2);
plot(time_vector2,real(z2),'LineWidth',2);
grid minor;
xlim([0,51]);
xlabel('Sample');
ylabel('Amplitude');
title('Complex Exponential (n = 52)');
subplot(3,1,3);
plot(time_vector3,real(z3),'LineWidth',2);
grid minor;
xlim([0,205]);
xlabel('Sample');
ylabel('Amplitude');
title('Complex Exponential (n = 206)');

