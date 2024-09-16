%% --- 2. Adaptive Signal Processing --- %%

%%
%close all;
clear all;
clc;

%% Initialization

% Total number of samples
N = 1000;

% Number of trials
total_trials = 100;

% Autoregressive coefficients
coefficients = [0.1, 0.8];

% Steps for LMS
step_sizes = [0.05, 0.01];

% Step size labels
step_labels = ["0.05", "0.01"];

% Number of steps
num_steps = length(step_sizes);

% Variance
noise_var = 0.25;

% ARIMA model setup
model = arima('AR', coefficients, 'Variance', noise_var, 'Constant', 0);

% Simulate data
data_samples = simulate(model, N, 'NumPaths', total_trials)';

% Leakage values
leakage_values = [0.1, 0.5, 0.9];

% Leakage labels
leakage_labels = ["0.1", "0.5", "0.9"];

% Number of leakage values
num_leakages = length(leakage_values);

% Storage for weights
weights = cell(num_leakages, num_steps, total_trials);
average_weights = cell(num_leakages, num_steps);

%% LMS

for leak_idx = 1:num_leakages
    for step_idx = 1:num_steps
        for run_idx = 1:total_trials
            [weights{leak_idx, step_idx, run_idx}, ~] = lms(data_samples(run_idx, :), data_samples(run_idx, :), length(coefficients), step_sizes(step_idx), leakage_values(leak_idx), 1);
        end
        average_weights{leak_idx, step_idx} = mean(cat(3, weights{leak_idx, step_idx, :}), 3);
    end
end

%% Plot Graphs

figure
for leak_idx = 1:num_leakages
    for step_idx = 1:num_steps
        subplot(1, num_leakages, leak_idx)
        plot(average_weights{leak_idx, step_idx}(1, :), 'LineWidth', 2)
        hold on
        plot(average_weights{leak_idx, step_idx}(2, :), 'LineWidth', 2)
    end
    grid minor
    xlabel('Sample')
    ylabel('Average Weight')
    title(sprintf('Weights for AR Coefficients (\\gamma = %s)', leakage_labels(leak_idx)))
    legend('a1, Step Size = 0.05', 'a2, Step Size = 0.05', 'a1, Step Size = 0.01', 'a2, Step Size = 0.01')
    xlim([0, N])
    ylim([0, 1])
end
