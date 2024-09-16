%% --- 2. Adaptive Signal Processing --- %%

%%
%close all;
clear all;
clc;

%% Initialization

% Number of samples
N = 1000;

% Autoregressive coefficients
coefficients = [0.1, 0.8];

% Variance
noise_variance = 0.25;

% Number of trials
total_trials = 100;

% ARIMA model setup
arima_model = arima('AR', coefficients, 'Variance', noise_variance, 'Constant', 0);

% Simulate data
data = simulate(arima_model, N, 'NumPaths', total_trials)';

% LMS steps
step_sizes = [0.05, 0.01];

% Number of LMS steps
num_steps = length(step_sizes);

% Error storage
mse_error = zeros(num_steps, N);
lms_error = cell(num_steps, total_trials);

%% Least Mean Squares (LMS)

for step_idx = 1:num_steps
    for trial_idx = 1:total_trials
        % Extract data for current trial
        data_trial = data(trial_idx, :);
        
        % Apply LMS algorithm
        [weights{step_idx, trial_idx}, predictions, lms_error{step_idx, trial_idx}] = lms(data_trial, data_trial, length(coefficients), step_sizes(step_idx), 0, 1);
    end
    % Calculate mean squared error (MSE)
    mse_error(step_idx, :) = pow2db(mean(cat(3, lms_error{step_idx, :}) .^ 2, 3));
    
    % Calculate average weights
    average_weights{step_idx} = mean(cat(3, weights{step_idx, :}), 3);
end

%% Plot Graphs

figure
for step_idx = 1:num_steps
    plot(mse_error(step_idx,:), 'LineWidth', 2)
    hold on
end
grid minor
xlabel('Sample')
ylabel('MSE (dB)')
legend('Step Size = 0.05', 'Step Size = 0.01')
title('Learning Curve of LMS')
