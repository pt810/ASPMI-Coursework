%% --- 3. Widely Linear Filtering and Adaptive Spectrum Estimation --- %%

%%
close all;
clear all;
clc;

%%

num_samples = 1500;
freq_fm_sig = [100*ones(500,1); ...
    100*ones(500,1) + ([501:1000]' - 500)/2; ...
    100*ones(500,1) + (([1001:1500]' -  1000)/25).^2];
phi = cumsum(freq_fm_sig);
fs = 1500;
noise_variance = 0.05;
noise = wgn(num_samples,1,pow2db(noise_variance),'complex');
fm_signal = exp(1i*2*pi*phi/fs) + noise;

% Plotting frequency
figure;
subplot(1,2,1);
hold on;
plot(1:num_samples, freq_fm_sig);
xlabel('Time (samples)');
ylabel('Frequency (Hz)');
title('Frequency of FM Signal');
grid minor;
hold off;

%%

model_orders = [1, 5, 10, 20];
subplot(1,2,2);
hold on;
h = zeros(4,1500);
w = zeros(4,1500);
for i = 1:4
    % Finding AR coefficients
    ar_coeff = aryule(fm_signal,model_orders(i));
    [h(i,:),w(i,:)] = freqz(1,ar_coeff,num_samples,fs);
    P = abs(h(i,:)).^2;
    plot(w(i,:), pow2db(P));
end
plot(mean(freq_fm_sig)*ones(1,1500), linspace(-10,30,1500),'--')
title('AR Spectrum Estimates')
xlabel('Frequency (Hz)'); 
ylabel('Power/Frequency (dB/(rad/sample))');
legend('AR(1)', 'AR(5)', 'AR(10)', 'AR(20)', 'Mean FM Signal Freq');
grid minor;
hold off;