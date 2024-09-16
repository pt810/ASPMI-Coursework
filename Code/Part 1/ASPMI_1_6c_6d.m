%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
%close all;
clear all;
clc;

%% Initialization

pcr_data = load('PCAPCR.mat');
x_train = pcr_data.X;
x_noise_train = pcr_data.Xnoise;
x_test = pcr_data.Xtest;
y_train = pcr_data.Y;
y_test = pcr_data.Ytest;

%% Processing

% Compute weights matrix using both methods
B_ols = (x_noise_train' * x_noise_train) \ (x_train' * y_train);
B_pcr = compute_pcr(y_train, x_noise_train, 3);

% Estimation and Test results
Y_ols_train = x_noise_train * B_ols;
Y_pcr_train = x_noise_train * B_pcr;
Y_ols_test = x_test * B_ols;
Y_pcr_test = x_test * B_pcr;

% Plotting squared errors
figure;
subplot(1, 2, 1);
hold on;
stem(sum((y_train - Y_ols_train).^2, 1));
stem(sum((y_train - Y_pcr_train).^2, 1));
xlabel('Columns');
ylabel('Squared Errors');
title('Estimation Error');
legend('OLS', 'PCR');
grid minor;
hold off;

subplot(1, 2, 2);
hold on;
stem(sum((y_test - Y_ols_test).^2, 1));
stem(sum((y_test - Y_pcr_test).^2, 1));
xlabel('Columns');
ylabel('Squared Errors');
title('Test Error');
legend('OLS', 'PCR');
grid minor;
hold off;

% Displaying metrics
fprintf('OLS Metrics (Estimation): \n RMSE: %.3f \n MAE: %.3f \n\n', compute_rmse(y_train, Y_ols_train), compute_mae(y_train, Y_ols_train))
fprintf('PCR Metrics (Estimation): \n RMSE: %.3f \n MAE: %.3f \n\n', compute_rmse(y_train, Y_pcr_train), compute_mae(y_train, Y_pcr_train))
fprintf('OLS Metrics (Test): \n RMSE: %.3f \n MAE: %.3f \n\n', compute_rmse(y_test, Y_ols_test), compute_mae(y_test, Y_ols_test))
fprintf('PCR Metrics (Test): \n RMSE: %.3f \n MAE: %.3f \n\n', compute_rmse(y_test, Y_pcr_test), compute_mae(y_test, Y_pcr_test))

%% Ensemble Averaged Square Error

ols_error = [];
pcr_error = [];
for i = 1:1000
    [Y_ols_hat, Y_ols] = regval(B_ols);
    [Y_pcr_hat, Y_pcr] = regval(B_pcr);
    ols_error = [ols_error; sum((Y_ols - Y_ols_hat).^2, 1)];
    pcr_error = [pcr_error; sum((Y_pcr - Y_pcr_hat).^2, 1)];
end

ols_error = mean(ols_error, 1);
pcr_error = mean(pcr_error, 1);
sum_ols_error = sum(ols_error);
sum_pcr_error = sum(pcr_error);

disp((sum_ols_error-sum_pcr_error)/sum_pcr_error)

figure;
hold on;
stem(ols_error);
stem(pcr_error); 
xlabel('Columns');
ylabel('MSE')
title('Ensemble Averaged Square Error Between Estimate & Original Data');
legend('OLS', 'PCR');
grid minor;
hold off;

function B = compute_pcr(y, x, k)
    [U, S, V] = svds(x, k); % Retain only k largest components
    S_inv = diag(1 ./ diag(S)); % Compute pseudoinverse
    B = (V * S_inv * U') * y;
end

function rmse = compute_rmse(X1, X2)
    rmse = mean((X1 - X2).^2, 'all').^0.5;
end

function mae = compute_mae(X1, X2)
    mae = mean(abs(X1 - X2), 'all');
end

