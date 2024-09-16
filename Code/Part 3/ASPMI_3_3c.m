%% --- 3. Widely Linear Filtering and Adaptive Spectrum Estimation --- %%

%%
%close all;
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

% Synthesise fourier signal
time = 1:num_samples;
f_ax = 0:fs-1;
x = (1/fs)*exp(1i*2*pi*f_ax'*time./fs);

% Original Signal with no leak
leak = 0;
[w,~] = dftclms(fm_signal.', x, leak);
figure;
hold on;
mesh(time, f_ax(1:floor(fs/2)), abs(w(1:floor(fs/2),:)).^2);
view(2);
xlabel('Time (samples)');
ylabel('Frequency (Hz)');
ylim([0,500]);
title(strcat('CLMS Fourier Estimate ($\gamma=',num2str(leak),'$)'),'Interpreter','Latex');
hold off;

% Original signal with different leak factors
leaks = [1e-2, 5e-2, 15e-2];
figure;
for idx = 1:3
    [w,~] = dftclms(fm_signal.', x, leaks(idx));
    subplot(1,3,idx);
    hold on;
    mesh(time, f_ax(1:floor(fs/2)), abs(w(1:floor(fs/2),:)).^2);
    view(2);
    xlabel('Time (samples)');
    ylabel('Frequency (Hz)');
    ylim([0,500]);
    title(strcat('CLMS Fourier Estimate ($\gamma=',num2str(leaks(idx)),'$)'),'Interpreter','Latex');
    hold off;
end