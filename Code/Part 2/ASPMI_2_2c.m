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
rho = [0.005, 0.005, 0.001, 0.001];
initial_step = [0.5, 0.1, 0.5, 0.1];

%% Processing and Plotting

figure

for j = 1:4

    ben_algo.name = 'Benveniste';
    ben_algo.param = NaN;
    
    model_arima = arima('MA', moving_avg_coeffs, 'Variance', var, 'Constant', 0);
    [data, noise] = simulate(model_arima, N, 'NumPaths', total_trials);
    data = data';
    noise = noise';
    
    ben_weights = zeros(total_trials, N);
    ben_step = zeros(total_trials, N);
    gngd_weights = zeros(total_trials, N);
    gngd_step = zeros(total_trials, N);
    
    for i = 1:total_trials
        [ben_weights(i, :), ~, ben_step(i, :)] = gass(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step(j), 0, rho(j), ben_algo);
    end
    
    average_ben_weights = mean(ben_weights);
    
    for i = 1:total_trials
        [gngd_weights(i, :), ~, gngd_step(i, :)] = gngd(noise(i, :), data(i, :), length(moving_avg_coeffs), initial_step(j), 1, rho(j));
        disp(gngd_weights(i, :))
    end
    
    average_gngd_weights = mean(gngd_weights);
    
    subplot(2,2,j)
    hold on
    plot(moving_avg_coeffs - average_ben_weights, 'LineWidth', 1.5)
    plot(moving_avg_coeffs - average_gngd_weights, 'LineWidth', 1.5)
    hold off
    grid minor
    xlabel('Sample')
    ylabel('Weight Error')
    title(sprintf('Weight Error of Benveniste and GNGD (\\rho = %.3f, \\mu_0 = %.3f)', rho(j), initial_step(j)));
    legend('Benveniste', 'GNGD')
    xlim([0, 100])

end
