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

% SVD and rank calculation
svd_clean = svd(clean_signal);
svd_noisy = svd(noisy_signal);
rank_clean = rank(clean_signal);

% Squared error calculation
squared_error = (svd_clean-svd_noisy).^2;

%% Plotting

figure;

subplot(1, 2, 1);
stem(svd_noisy, '-o');
hold on;
stem(svd_clean, '-o');
grid minor
legend('Noisy Signal', 'Clean Signal');
title('Singular Values of Noisy and Clean Signals');
xlabel('Singular Value Index');
ylabel('Singular Value');

subplot(1, 2, 2);
stem(squared_error);
grid minor
title('Squared Error between Singular Values of Noisy and Clean Signals');
xlabel('Singular Value Index');
ylabel('Squared Error');
