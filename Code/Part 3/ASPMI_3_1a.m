%% --- 3. Widely Linear Filtering and Adaptive Spectrum Estimation --- %%

%%
close all;
clear all;
clc;

%% Initialization

coeff1 = 1.5 + 1i;
coeff2 = 2.5 - 0.5i;
realizations = 100;
input_signal = wgn(1000, realizations, 0, 'complex');
data = zeros(1000, realizations, 'like', 1i);
error_storage = zeros(2, 1000, realizations);

%% Processing

for realization_idx = 1:realizations
    for sample_idx = 1:1000
        if sample_idx == 1
            data(sample_idx, realization_idx) = 0i;
        else
            data(sample_idx, realization_idx) = input_signal(sample_idx, realization_idx) + ...
                                               coeff1 * input_signal(sample_idx - 1, realization_idx) + ...
                                               coeff2 * conj(input_signal(sample_idx - 1, realization_idx));
        end
    end
    [~, error_storage(1, :, realization_idx), ~] = aclms(data(:, realization_idx), input_signal(:, realization_idx), 1, 0.1, 0);
    [~, error_storage(2, :, realization_idx), ~] = clms(data(:, realization_idx), input_signal(:, realization_idx), 1, 0.1, 0);
end
mean_error = mean(abs(error_storage).^2, 3);

%% Plotting

figure;
subplot(1, 2, 1);
hold on;
scatter(real(input_signal(:)), imag(input_signal(:)), 5, [0 0.4470 0.7410]);
title('Circular WGN');
xlabel('Re(z)');
ylabel('Im(z)');
xlim([-4,4]);
ylim([-4,4]);
grid minor;
hold off;

subplot(1, 2, 2);
hold on;
scatter(real(data(:)), imag(data(:)), 5, [0.8500 0.3250 0.0980]);
title('WLMA(1)');
xlabel('Re(z)');
ylabel('Im(z)');
xlim([-15,15]);
ylim([-15,15])
grid minor;
hold off;

figure;
hold on;
plot(1:1000, pow2db(mean_error(1, :)));
plot(1:1000, pow2db(mean_error(2, :)));
ylabel('Squared Error (dB)');
xlabel('Time (samples)');
title('Learning Curves');
legend('ACLMS', 'CLMS');
grid minor;
hold off;