%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
close all;
clear all;
clc;

%% Initialization

eeg_data = load('EEG_Data/EEG_Data_Assignment1.mat');
fs = eeg_data.fs;
data_len = length(eeg_data.POz);
windows = [10,5,1];
freq_res = 1/5;
fft_len = (fs)/freq_res;
overlaps = 0;
poz = detrend(eeg_data.POz - mean(eeg_data.POz));

%% Standard Periodogram

[psd, f] = periodogram(poz, hamming(data_len), fft_len, fs);

%% Welch Average Periodograms

for i = 1:length(windows)   
    frame_len = windows(i) * fs;
    psd_welch{i} = pwelch(poz,hamming(frame_len),overlaps,fft_len,fs);
end

%% Plot Graphs

figure;

subplot(1,2,1);
plot(f,pow2db(psd),'LineWidth',2);
xlim([0 60]);
grid minor;
title('Standard Periodogram');
xlabel('Frequency (Hz)');
ylabel('PSD (dB)');

subplot(1,2,2);
hold on
plot(f,pow2db(psd_welch{1}),'LineWidth',2);
plot(f,pow2db(psd_welch{2}),'LineWidth',2);
plot(f,pow2db(psd_welch{3}),'LineWidth',2);
hold off
grid minor;
legend('Window=10s', 'Window=5s', 'Window=1s', 'Location', 'southwest');
title('Welch Averaged Periodograms');
xlabel('Frequency (Hz)');
ylabel('PSD (dB)');
xlim([0 60]);