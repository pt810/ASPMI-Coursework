%% --- 2. Adaptive Signal Processing --- %%

%%
close all;
clear all;
clc;

%% Initialization

sampling_frequency = 1;
N = 1000;
total_trials = 100;
sin_freq = 0.005;
time_vector = (0:N-1)/sampling_frequency;
signal = sin(2*pi*sin_freq*time_vector);
var = 1;
delay = 3;
step_size = 0.01;
transient = 0;
model_order = 5;

moving_avg_coeffs = [0,0.5];
arima_model = arima('MA', moving_avg_coeffs, 'Variance', var, 'Constant', 0);
[noise, innovation] = simulate(arima_model, N, 'NumPaths', total_trials);
noise = noise';

secondary_noise = 2*noise +0.08;

noisy_signal = zeros(total_trials,N);
ale_sig = zeros(total_trials,N);
ale_err = zeros(total_trials,N-transient);

anc_noise = zeros(total_trials,N);
anc_sig = zeros(total_trials,N);
anc_err = zeros(total_trials,N-transient);

%% ALE and ANC
for i = 1:total_trials
    noisy_signal(i,:) = signal + noise(i,:);
    [~,ale_sig(i,:),~] = lms(noisy_signal(i,:),noisy_signal(i,:),length(moving_avg_coeffs),step_size,0,delay);
    ale_err(i,:) = (signal(:,transient + 1: end) - ale_sig(i,transient + 1: end)) .^ 2;
    
    [~,anc_noise(i,:),~] = lms(secondary_noise(i,:),noisy_signal(i,:),model_order,step_size,0,0);
    anc_sig(i,:) = noisy_signal(i,:)-anc_noise(i,:);
    anc_err(i,:) = (signal(:,transient + 1: end) - anc_sig(i,transient + 1: end)) .^ 2;
end
mspe_ale = mean(ale_err);
mspe_ale = mean(mspe_ale);

mspe_anc = mean(anc_err);
mspc_anc = mean(mspe_anc);

anc_sig = mean(anc_sig);
ale_sig = mean(ale_sig);


%% Plot Graphs
figure
for i = 1:total_trials
    noisy_plot = plot(noisy_signal(i,:), 'k');
    hold on
end
clean_plot = plot(signal,':r','LineWidth',2);
hold on
ale_plot = plot(ale_sig,'LineWidth',2);
hold on
anc_plot = plot(anc_sig, 'LineWidth',2);
grid minor
xlabel('Sample')
ylabel('Amplitude')
title('Performance Comparison of ANC and ALE Algorithms')
legend([noisy_plot,clean_plot,ale_plot,anc_plot],{'Noisy','Clean','ALE','ANC'})

