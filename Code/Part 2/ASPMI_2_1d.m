%% --- 2. Adaptive Signal Processing --- %%

%%
%close all;
clear all;
clc;

%% Initialization

% Total number of samples
N = 1000;

% Transient period
transient_period = 500;

% Number of trials
total_trials = 100;

% Autoregressive coefficients
coefficients = [0.1, 0.8];

% Steps for LMS
step_sizes = [0.05, 0.01];

% Number of LMS steps
num_steps = length(step_sizes);

% Variance
noise_variance = 0.25;

% ARIMA model setup
arima_model = arima('AR', coefficients, 'Variance', noise_variance, 'Constant', 0);

% Simulate data
data = simulate(arima_model, N, 'NumPaths', total_trials)';

% Storage for weights
weights = cell(num_steps, total_trials);
average_weights = cell(num_steps, 1);

%% LMS

for i = 1:num_steps
    for j = 1:total_trials
        [weights{i, j}, ~] = lms(data(j, :), data(j, :), length(coefficients), step_sizes(i), 0, 1);
    end
    average_weights{i} = mean(cat(3, weights{i, :}), 3);
end

%% Plot Graphs

figure
for i = 1:num_steps
    plot(average_weights{i}(1, :), 'LineWidth', 2)
    hold on
    plot(average_weights{i}(2, :), 'LineWidth', 2)
    hold on
end
grid minor
xlabel('Sample')
ylabel('Average Weight')
title('Evolution of AR Coefficients Over Samples')
legend('a1 (Step Size = 0.05)', 'a2 (Step Size = 0.05)', 'a1 (Step Size = 0.01)', 'a2 (Step Size = 0.01)')
xlim([0, N])
