%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
close all;
clear all;
clc;

%% Initialization

fs = 1;
num_samples = 100;
time_vector = (0:num_samples-1);
freq_vector = time_vector ./ (2*num_samples) .* fs;
white_noise = randn(1, num_samples);
filtered_white_noise = filter([1 1], 1, white_noise);
noisy_sig = sin(2 * pi * 0.1 * time_vector) + sin(2 * pi * 0.27 * time_vector) + randn(1,num_samples);
signals = {white_noise, filtered_white_noise, noisy_sig};
labels = ["WGN", "Filtered WGN", "Noisy Sinusoid"];
num_signals = length(signals);

acf_unbiased = cell(num_signals, 1);
acf_biased = cell(num_signals, 1);
psd_unbiased = cell(num_signals, 1);
psd_biased = cell(num_signals, 1);

%% Biased and Unbiased Autocorrelation

for i = 1: num_signals
    acf_unbiased{i} = xcorr(signals{i}, 'unbiased');
    acf_biased{i} = xcorr(signals{i}, 'biased');
    psd_unbiased{i} = real(fftshift(fft(ifftshift(acf_unbiased{i}))));
    psd_biased{i} = real(fftshift(fft(ifftshift(acf_biased{i}))));
    
    acf_unbiased{i} = acf_unbiased{i}(num_samples:(2*num_samples)-1);
    acf_biased{i} = acf_biased{i}(num_samples:(2*num_samples)-1);
    psd_unbiased{i} = psd_unbiased{i}(num_samples:(2*num_samples)-1);
    psd_biased{i} = psd_biased{i}(num_samples:(2*num_samples)-1);
end

%% Plot Results

figure;
for i = 1:num_signals
    subplot(num_signals, 1, i);
    hold on;
    plot(time_vector, acf_unbiased{i}, 'LineWidth', 2);
    plot(time_vector, acf_biased{i}, 'LineWidth', 2);
    hold off;
    grid minor;
    legend('Unbiased', 'Biased');
    title(sprintf("Autocorrelation of %s", labels(i)));
    xlabel('Lag (Sample)');
    ylabel('ACF');
end

figure;
for i = 1:num_signals
    subplot(num_signals, 1, i);
    hold on;
    plot(freq_vector, psd_unbiased{i}, 'LineWidth', 2);
    plot(freq_vector, psd_biased{i}, 'LineWidth', 2);
    hold off;
    grid minor;
    legend('Unbiased', 'Biased');
    title(sprintf("Spectrum of %s", labels(i)));
    xlabel('Normalised Frequency (Cycles/Sample)');
    ylabel('PSD');
end
