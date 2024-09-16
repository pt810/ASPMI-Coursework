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

x = delayseq(fm_signal,1);
learning_rates = [5e-3, 5e-2, 5e-1];
figure(1);
for idx = 1:3
    [a,~,~] = clms(fm_signal, x, 0, learning_rates(idx), 0);
    H = zeros(num_samples,num_samples);
    for n = 1:num_samples
        % Run complex-valued LMS algorithm to estimate AR coefficient aˆ1(n)
        [h, w] = freqz(1 , [1; -conj(a(n))], num_samples,fs); % Compute power spectrum
        H(:, n) = abs(h).^2; % Store it in a matrix 
    end
    % Remove outliers in the matrix H
    medianH = 50*median(median(H));
    H(H > medianH) = medianH;
    % Plotting
    subplot(1,3,idx);
    hold on;
    mesh([1:num_samples], w, H);
    view(2);
    xlabel('Time (samples)');
    ylabel('Frequency (Hz)');
    ylim([0,500]);
    title(strcat('CLMS Spectral Estimate ($\mu=',num2str(learning_rates(idx)),'$)'), 'Interpreter', 'Latex');
end

