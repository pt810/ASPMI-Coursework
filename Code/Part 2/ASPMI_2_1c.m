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
step_sizes = linspace(0.01, 1, 100);

% Number of LMS steps
num_steps = length(step_sizes);

% Variance
noise_variance = 0.25;

% ARIMA model setup
arima_model = arima('AR', coefficients, 'Variance', noise_variance, 'Constant', 0);

% Simulate data
data = simulate(arima_model, N, 'NumPaths', total_trials)';

% Error storage
error = zeros(num_steps, total_trials);
emse_individual = zeros(num_steps, total_trials);

% Correlation matrix
correlation_matrix = [25/27, 25/54; 25/54, 25/27];

% Threshold
threshold = 0.463;

%% LMS

for i = 1:num_steps
    for j = 1:total_trials
        [~, ~, e] = lms(data(j, :), data(j, :), length(coefficients), step_sizes(i), 0, 1);
        error(i, j) = mean(e(transient_period + 1:end).^2);
        emse_individual(i, j) = error(i, j) - noise_variance;
    end
    t(i) = time_constant(step_sizes(i), threshold);
end

% Calculate average EMSE
emse = mean(emse_individual, 2);

% Calculate misadjustment
misadjustment = emse / noise_variance;

%% Autocorrelation Matrix

% Approximated misadjustment
m_approximated = step_sizes / 2 * trace(correlation_matrix);
fprintf('Misadjustment: %.4f    %.4f\n', misadjustment);
fprintf('Approximated misadjustment: %.4f   %.4f\n', m_approximated);

%% Plot Graphs

figure
subplot(1, 2, 1)
plot(step_sizes, t, 'LineWidth', 2)
grid minor
xlabel('Step Size')
ylabel('Time Constant')
title('Convergence Speed')
subplot(1, 2, 2)
plot(step_sizes, pow2db(emse), 'LineWidth', 2)
grid minor
xlabel('Step Size')
ylabel('EMSE (dB)')
title('Steady State Error')
