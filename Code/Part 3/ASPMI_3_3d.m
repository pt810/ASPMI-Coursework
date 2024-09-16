%% --- 3. Widely Linear Filtering and Adaptive Spectrum Estimation --- %%

%%
close all;
clear all;
clc;

%%

% Add data folder to path
addpath('EEG_Data\');
load('EEG_Data_Assignment2.mat');

%%

a = 35000;
time_range = a:a+1199;
POz = detrend(POz(time_range));
f_ax = 0:fs-1;
x = (1/fs)*exp(1i*2*pi*f_ax'*time_range./fs);
[w,~] = dftclms(POz, x, 0);

%%

figure;
hold on;
mesh(time_range, f_ax(1:floor(fs/2)), abs(w(1:floor(fs/2),:)).^2);
view(2);
ylim([0,60]);
xlabel('Time (samples)');
ylabel('Frequency (Hz)');
title('CLMS Fourier Estimate (POz)');
