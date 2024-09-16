%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%%
close all;
clear all;
clc;

%% Initialization

pcr_data = load('PCAPCR.mat');
clean_signal = pcr_data.X;
noisy_signal = pcr_data.Xnoise;

%% Processing

% Perform SVD and Denoising
[U, S, V] = svds(noisy_signal, 3); % Retain only 3 principal components
denoised_signal = U*S*V';

% Calculate Mean Squared Error
mse_noise = mean((clean_signal - noisy_signal).^2, 1);
mse_denoised = mean((clean_signal - denoised_signal).^2, 1);

%% Plotting

figure;
hold on;
stem(mse_noise);
stem(mse_denoised);
xlabel('Columns');
ylabel('MSE')
title('MSE Between Clean and Noisy/Denoised Signals');
legend('$X$, $X_{noise}$', '$X$, $\tilde{X}_{noise}$', 'Interpreter', 'latex');
grid minor;
hold off;

% Compute and Display IMSE
imse_noise = immse(clean_signal, noisy_signal);
imse_denoised = immse(clean_signal, denoised_signal);
disp(['IMSE between clean and noisy signals: ', num2str(imse_noise)]);
disp(['IMSE between clean and denoised signals: ', num2str(imse_denoised)]);
