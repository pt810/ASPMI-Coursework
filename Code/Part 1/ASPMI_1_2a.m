%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
close all;
clear all;
clc;

%% Initialize
load sunspot.dat

sunspot_data = sunspot(:,2);
data_len = length(sunspot_data);
fs = 1;
t = (0:data_len-1);

%% Preprocess Data

mean_trend_removed = detrend(sunspot_data - mean(sunspot_data));
log_data = log(sunspot_data+eps);
log_data = log_data - mean(log_data);

%% Autocorrelation for periodicities

r = xcorr(log_data, 'biased');
r = r(288:575,1);

%% Create Periodograms

[psd_raw, ~] = periodogram(sunspot_data, hamming(data_len), data_len, fs);
[psd_MeanDetrend, ~] = periodogram(mean_trend_removed, hamming(data_len), data_len, fs);
[psd_LogMean, f] = periodogram(log_data, hamming(data_len), data_len, fs);

%% Plot results
figure;

subplot(1,2,1);
hold on;
plot(sunspot_data,'LineWidth',2);
plot(mean_trend_removed,'--' ,'LineWidth',2);
plot(log_data,'LineWidth',2);
grid minor;
legend('Raw', 'Detrend-Mean', 'Log-Mean');
title('Raw and Processed Sunspot Series');
xlabel('Sample');
ylabel('Amplitude');
hold off

subplot(1,2,2);
hold on;
plot(f,pow2db(psd_raw),'LineWidth',2);
plot(f,pow2db(psd_MeanDetrend),'--','LineWidth',2);
plot(f,pow2db(psd_LogMean),'LineWidth',2);
grid minor;
legend('Raw', 'Detrend-Mean', 'Log-Mean');
title('Periodograms of Raw and Processed Sunspot Series');
xlabel('Normalised Frequency (cycles/sample)');
ylabel('PSD (dB)');
hold off;

figure;

subplot(1,2,1);
plot(t,r,'LineWidth',2);
grid minor;
title('Autocorrelation of Log-Mean Sunspot Series');
xlabel('Sample');
ylabel('Correlation');

subplot(1,2,2);
plot(f,psd_LogMean,'LineWidth',2);
grid minor;
title('Periodogram of Log-Mean Sunspot Series');
xlabel('Normalised Frequency (cycles/sample)');
ylabel('PSD')