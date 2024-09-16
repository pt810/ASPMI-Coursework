%% --- 2. Adaptive Signal Processing --- %%

%%
%close all;
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
num_delays = 4;
step_size = 0.01;
transient_samples = 50;
model_order = 5;

moving_avg_coeffs = [0,0.5];
arima_model = arima('MA', moving_avg_coeffs, 'Variance', var, 'Constant', 0);
[noise, innovation] = simulate(arima_model, N, 'NumPaths', total_trials);
noise = noise';

noisy_signal = zeros(total_trials, N);
ale_output = zeros(total_trials, N);
error_signal = zeros(total_trials, N-transient_samples);
mse_error = zeros(num_delays, N-transient_samples);

%% ALE
for delay_index = 1:num_delays
    for trial_index = 1:total_trials
        noisy_signal(trial_index,:) = signal + noise(trial_index,:);
        [~, ale_output(trial_index,:), ~] = lms(noisy_signal(trial_index,:), noisy_signal(trial_index,:), length(moving_avg_coeffs), step_size, 0, delay_index);
        error_signal(trial_index,:) = (signal(:,transient_samples + 1:end) - ale_output(trial_index,transient_samples + 1:end)) .^ 2;
    end
    mse_error(delay_index,:) = mean(error_signal)';
end
mse_error = mean(mse_error,2);

%% Plot Graphs
figure
for delay_idx = 1: num_delays
    %subplot(num_delays, 1, delay_idx);
    for trial_idx = 1: total_trials
        noisy_plot = plot(time_vector, noisy_signal(trial_idx,:), 'k','LineWidth', 1);
        hold on;
        ale_plot = plot(time_vector, ale_output(trial_idx,:), 'r', 'LineWidth', 2);
        hold on;
    end
    clean_plot = plot(time_vector, signal, 'LineWidth', 2);
    hold off;
    grid minor
    legend([noisy_plot, ale_plot, clean_plot], {'Noisy', 'ALE', 'Clean'}, 'location', 'bestoutside');
    title(sprintf('Delay = %d', delay_idx))
    xlabel('Sample');
    ylabel('Amplitude');
end

figure;
plot(mse_error,'LineWidth', 2);
grid minor
legend('MSPE');
xlabel('Sample');
ylabel('MSPE');
title('MSPE of ALE for Different Delays')
