%% --- 2. Adaptive Signal Processing --- %%

%%
close all;
clear all;
clc;

%% Initialization

N = 1000;
total_trials = 100;
moving_avg_coeffs = 0.9;
var = 0.5;
step_sizes = [0.01, 0.1];
num_steps = length(step_sizes);
rho = 0.005;
initial_step = 0;

ben_algo.name = 'Benveniste';
ben_algo.param = NaN;
ang_algo.name = 'Ang';
ang_algo.param = 0.8;
matt_algo.name = 'Matthews';
matt_algo.param = NaN;

model_arima = arima('MA', moving_avg_coeffs, 'Variance', var, 'Constant', 0);
[data, noise] = simulate(model_arima, N, 'NumPaths', total_trials);
data = data';
noise = noise';

weights_lms = cell(num_steps, total_trials);
average_weights_lms = zeros(num_steps, N);

ben_weights = zeros(total_trials, N);
ang_weights = zeros(total_trials, N);
matt_weights = zeros(total_trials, N);

ben_step = zeros(total_trials, N);
ang_step = zeros(total_trials, N);
matt_step = zeros(total_trials, N);

%% LMS
for i = 1:num_steps
    for j = 1:total_trials
        [weights_lms{i, j}, ~, ~] = lms(noise(j, :), data(j, :), length(moving_avg_coeffs), step_sizes(i), 0, 1);
    end
    average_weights_lms(i, :) = mean(cat(3, weights_lms{i, :}), 3);
end

%% GASS
for i = 1:total_trials
    [ben_weights(i, :), ~, ben_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step, 0, rho, ben_algo);
    [ang_weights(i, :), ~, ang_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step, 0, rho, ang_algo);
    [matt_weights(i, :), ~, matt_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step, 0, rho, matt_algo);
end

average_ben_weights = mean(ben_weights);
average_ang_weights = mean(ang_weights);
average_matt_weights = mean(matt_weights);
average_ben_step = mean(ben_step);
average_ang_step = mean(ang_step);
average_matt_step = mean(matt_step);

%% Plot Graphs
figure
subplot(2, 2, 1)
for i = 1:num_steps
    plot(moving_avg_coeffs - average_weights_lms(i, :), 'LineWidth', 2)
    hold on
end
plot(moving_avg_coeffs - average_ben_weights, 'LineWidth', 1)
hold on
plot(moving_avg_coeffs - average_ang_weights, 'LineWidth', 1)
hold on
plot(moving_avg_coeffs - average_matt_weights, 'LineWidth', 1)
grid minor
xlabel('Sample')
ylabel('Weight Error')
title('Weight Error of Standard LMS and GASS (\rho = 0.005)')
xlim([800, 1000])
ylim([-0.04, 0.05])
legend('\mu = 0.01', '\mu = 0.1', 'Benveniste', 'Ang & Farhang', 'Matthews & Xie')

subplot(2, 2, 2)
plot(average_ben_step, 'Color', '#EDB120', 'LineWidth', 2)
hold on
plot(average_ang_step, 'Color', '#7E2F8E', 'LineWidth', 2)
hold on
plot(average_matt_step, 'Color', '#77AC30', 'LineWidth', 2)
grid minor
xlabel('Sample')
ylabel('Step Size')
title('Step Size Adaption of Different GASS Algorithms (\rho = 0.005)')
xlim([800, 1000])
legend('Benveniste', 'Ang & Farhang', 'Matthews & Xie')


%% Initialization

N = 1000;
total_trials = 100;
moving_avg_coeffs = 0.9;
var = 0.5;
step_sizes = [0.01, 0.1];
num_steps = length(step_sizes);
rho = 0.05;
initial_step = 0;

ben_algo.name = 'Benveniste';
ben_algo.param = NaN;
ang_algo.name = 'Ang';
ang_algo.param = 0.8;
matt_algo.name = 'Matthews';
matt_algo.param = NaN;

model_arima = arima('MA', moving_avg_coeffs, 'Variance', var, 'Constant', 0);
[data, noise] = simulate(model_arima, N, 'NumPaths', total_trials);
data = data';
noise = noise';

weights_lms = cell(num_steps, total_trials);
average_weights_lms = zeros(num_steps, N);

ben_weights = zeros(total_trials, N);
ang_weights = zeros(total_trials, N);
matt_weights = zeros(total_trials, N);

ben_step = zeros(total_trials, N);
ang_step = zeros(total_trials, N);
matt_step = zeros(total_trials, N);

%% LMS
for i = 1:num_steps
    for j = 1:total_trials
        [weights_lms{i, j}, ~, ~] = lms(noise(j, :), data(j, :), length(moving_avg_coeffs), step_sizes(i), 0, 1);
    end
    average_weights_lms(i, :) = mean(cat(3, weights_lms{i, :}), 3);
end

%% GASS
for i = 1:total_trials
    [ben_weights(i, :), ~, ben_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step, 0, rho, ben_algo);
    [ang_weights(i, :), ~, ang_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step, 0, rho, ang_algo);
    [matt_weights(i, :), ~, matt_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step, 0, rho, matt_algo);
end

average_ben_weights = mean(ben_weights);
average_ang_weights = mean(ang_weights);
average_matt_weights = mean(matt_weights);
average_ben_step = mean(ben_step);
average_ang_step = mean(ang_step);
average_matt_step = mean(matt_step);

%% Finish plotting Graphs

subplot(2, 2, 3)
for i = 1:num_steps
    plot(moving_avg_coeffs - average_weights_lms(i, :), 'LineWidth', 2)
    hold on
end
plot(moving_avg_coeffs - average_ben_weights, 'LineWidth', 1)
hold on
plot(moving_avg_coeffs - average_ang_weights, 'LineWidth', 1)
hold on
plot(moving_avg_coeffs - average_matt_weights, 'LineWidth', 1)
grid minor
xlabel('Sample')
ylabel('Weight Error')
title('Weight Error of Standard LMS and GASS (\rho = 0.05)')
xlim([800, 1000])
ylim([-0.06, 0.1])
legend('\mu = 0.01', '\mu = 0.1', 'Benveniste', 'Ang & Farhang', 'Matthews & Xie')

subplot(2, 2, 4)
plot(average_ben_step, 'Color', '#EDB120', 'LineWidth', 2)
hold on
plot(average_ang_step, 'Color', '#7E2F8E', 'LineWidth', 2)
hold on
plot(average_matt_step, 'Color', '#77AC30', 'LineWidth', 2)
grid minor
xlabel('Sample')
ylabel('Step Size')
title('Step Size Adaption of Different GASS Algorithms (\rho = 0.05)')
xlim([800, 1000])
legend('Benveniste', 'Ang & Farhang', 'Matthews & Xie')