%% --- 2. Adaptive Signal Processing --- %%

%%
%close all;
clear all;
clc;

%% Initialization

sampling_frequency = 1;
N = 1000;
model_orders = [5,10,15,20];
total_trials = 100;
num_orders = length(model_orders);
sin_freq = 0.005;
time_vector = (0:N-1)/sampling_frequency;
signal = sin(2*pi*sin_freq*time_vector);
var = 1;
delays = 3:25;
num_delays = length(delays);
step_size = 0.01;
transient_samples = 50;
model_order = 5;

moving_avg_coeffs = [0,0.5];
arima_model = arima('MA', moving_avg_coeffs, 'Variance', var, 'Constant', 0);
[noise, innovation] = simulate(arima_model, N, 'NumPaths', total_trials);
noise = noise';

noisy_signal = zeros(total_trials, N);
error = cell(num_orders, num_delays, total_trials);
mspe_error = zeros(num_orders, num_delays);

%% ALE
for order_idx = 1:num_orders
    for delay_idx = 1:num_delays
        for trial_idx = 1:total_trials
            noisy_signal(trial_idx,:) = signal + noise(trial_idx,:);
            [~, x_ale, ~] = lms(noisy_signal(trial_idx,:), noisy_signal(trial_idx,:), model_orders(order_idx), step_size, 0, delays(delay_idx));
            error{order_idx, delay_idx, trial_idx} = (signal(:,transient_samples + 1:end) - x_ale(:,transient_samples + 1:end)) .^ 2;
        end
        mspe_error(order_idx, delay_idx) = mean(cell2mat(error(order_idx, delay_idx,:)), 'all');
    end
end

%% Plot Graphs
figure
for order_index = 1:num_orders
    plot(delays,mspe_error(order_index,:),'LineWidth',2)
    hold on
end
grid minor
xlim([3,25])
legend(sprintf('Order = %d', model_orders(1)),sprintf('Order = %d', model_orders(2)),sprintf('Order = %d', model_orders(3)),sprintf('Order = %d', model_orders(4)),'Location','northwest')
xlabel('Delay')
ylabel('MSPE')
title('MSPE vs Delay For A Range of Filter Orders ')
