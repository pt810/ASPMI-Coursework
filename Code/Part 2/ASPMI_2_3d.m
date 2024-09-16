%% --- 2. Adaptive Signal Processing --- %%

%%
%close all;
clear all;
clc;

%% Initialization

eeg_data = load('EEG_Data/EEG_Data_Assignment2.mat');
poz_data = detrend(eeg_data.POz - mean(eeg_data.POz))';
sampling_frequency = eeg_data.fs;
N = length(poz_data);
step_sizes = [1e-2, 1e-3, 1e-4];
num_steps = length(step_sizes);
orders = [5,10,15,25];
num_orders = length(orders);
nfft = 2 ^ 13;
frame_size = 5;
window_size = 2^12;
overlap_size = round(0.9 * window_size);

f_sin = 50;
time_vector = (0:N-1)/sampling_frequency;
variance = 0.01;
sinusoid_signal = sin(2 * pi * f_sin * time_vector);
noisy_signal = variance * randn(1, N) + sinusoid_signal;

anc_output = cell(num_orders,num_steps);
processed_poz = cell(num_orders,num_steps);
errors = cell(num_orders,num_steps);
mean_squared_prediction_error = cell(num_orders,num_steps);

%% ANC

for order_idx = 1:num_orders
    for step_idx = 1:num_steps
        [~,anc_output{order_idx,step_idx},~] = lms(noisy_signal,poz_data,orders(order_idx),step_sizes(step_idx),0,1);
        processed_poz{order_idx,step_idx} = poz_data - anc_output{order_idx,step_idx};
        errors{order_idx,step_idx} = (poz_data - processed_poz{order_idx,step_idx}).^2;
        mean_squared_prediction_error{order_idx,step_idx} = mean(errors{order_idx,step_idx});
    end
end

%% Spectrograms

figure;
spectrogram(poz_data, window_size, overlap_size, nfft, sampling_frequency, 'yaxis');
ylim([0,60])
title('Original POz Spectrogram')
count = 0;
figure
for order_idx = 1:num_orders
    for step_idx = 1:num_steps
        count = count + 1;
        subplot(num_orders,num_steps,count)
        spectrogram(processed_poz{order_idx,step_idx}, window_size, overlap_size, nfft, sampling_frequency, 'yaxis');
        title(sprintf('Order = %d, Step = %.4f',orders(order_idx),step_sizes(step_idx)))
        ylim([0,60])
    end
end

figure
spectrogram(processed_poz{2,2}, window_size, overlap_size, nfft, sampling_frequency, 'yaxis');
title(sprintf('Order = %d, Step = %.3f',10,0.001))
ylim([0,60])
