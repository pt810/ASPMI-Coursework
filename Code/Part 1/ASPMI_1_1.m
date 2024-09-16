%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%% 
%close all;
clear all;
clc;

%% Initialization and Processing

fs = 1000;
T = 1/fs;
sig_len = 3000;
t = (0:sig_len-1)*T;

% Pulse signal creation
pulse_sig = zeros(size(t));
pulse_sig(1500) = 5;

% Sinusoidal signal creation
sinusoidal_sig = 0.7 * sin(2*pi*0.5*t);

% Autocovariance calculation for both signals
ACF_pulse = xcorr(pulse_sig, 'biased');
ACF_sinusoid = xcorr(sinusoidal_sig, 'biased');

% PSD calculation using both definitions
pulse_def1 = abs(fftshift(fft(ACF_pulse)));
sinusoid_def1 = abs(fftshift(fft(ACF_sinusoid)));
pulse_def2 = (abs(fftshift(fft(pulse_sig))).^2)/sig_len;
sinusoid_def2 = (abs(fftshift(fft(sinusoidal_sig))).^2)/sig_len;

% Frequency vectors for plotting
f1 = -fs/2:fs/length(ACF_pulse):fs/2 - fs/length(ACF_pulse);
f2 = -fs/2:fs/length(pulse_def2):fs/2 - fs/length(pulse_def2);

%% Plotting

subplot(3, 2, 1);
plot(t, pulse_sig,'b');
grid minor;
xlabel('Time (s)');
ylabel('Amplitude');
title('Pulse Signal - Time Domain');

subplot(3, 2, 3);
plot([-sig_len+1:sig_len-1], ACF_pulse, 'b');
grid minor;
xlabel('Time Lag (k)');
ylabel('ACF');
title('Rapidly Decaying ACF');

subplot(3, 2, 5);
hold on;
plot(f1, pulse_def1, 'r');
plot(f2, pulse_def2, '--b');
grid minor;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('PSD - Rapidly Decaying');
legend('Def. 1', 'Def. 2');
ylim([0.007,0.01])
hold off;

subplot(3, 2, 2);
plot(t,sinusoidal_sig,'b');
grid minor;
xlabel('Time (s)');
ylabel('Amplitude');
title('Sinusoidal Signal - Time Domain');

subplot(3, 2, 4);
plot([-sig_len+1:sig_len-1], ACF_sinusoid,'b');
grid minor;
xlabel('Time Lag (k)');
ylabel('ACF');
title('Slowly Decaying ACF');

subplot(3, 2, 6);
hold on;
plot(f1, sinusoid_def1, 'r');
plot(f2, sinusoid_def2, '--b');
grid minor;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('PSD - Slowly Decaying')
legend('Def. 1', 'Def. 2');
hold off;