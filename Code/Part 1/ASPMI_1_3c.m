%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
%close all;
clear all;
clc;

%% Initialise

fs = 1;
num_samples = 100;
time_vector = (0:num_samples-1);
freq_vector = time_vector ./ (2 * num_samples) .*fs;
sig = 1 * sin(2 * pi * 0.25 * time_vector) + 0.65 * sin(2 * pi * 0.9 * time_vector);
num_procs = 100;
autocorrelations = zeros(num_procs,(2*num_samples)-1);
psd = cell(num_procs, 1);

%% PSD Calculation

for i = 1:num_procs
    noisy_sig = sig + randn(size(sig));
    autocorrelations(i,:) = xcorr(noisy_sig, 'biased');

    psd{i} = real(fftshift(fft(ifftshift(autocorrelations(i,:)))));
    psd{i} = psd{i}(num_samples:(2*num_samples)-1);
end
autocorrelation_clean = xcorr(sig,'biased');
psd_clean = real(fftshift(fft(ifftshift(autocorrelation_clean))));
psd_clean = psd_clean(num_samples:(2*num_samples)-1);
psd_mean = mean(cell2mat(psd));
psd_std = std(cell2mat(psd));

%% Plot Graphs

figure;
subplot(2, 1, 1);
hold on;
for i = 1:num_procs
    indiv_psd = plot(freq_vector,pow2db(psd{i}),'b');
end

mean_psd = plot(freq_vector, pow2db(psd_mean), 'r', 'LineWidth', 2);
clean_psd = plot(freq_vector, pow2db(psd_clean),'--g', 'LineWidth',2);
xlim([0.01,0.5]);
grid minor;
legend([indiv_psd, mean_psd, clean_psd], {'Individual', 'Mean', 'Clean'});
title('Individual PSDs, Mean PSD and Clean PSD');
xlabel('Normalised frequency (cycles/sample)');
ylabel('PSD (dB)');
hold off

subplot(2, 1, 2);
plot(freq_vector, pow2db(psd_std),'LineWidth', 2);
grid minor;
legend('Standard Deviation');
title('Standard deviation of PSDs');
xlabel('Normalised Frequency (cycles/sample)');
ylabel('PSD (dB)');
