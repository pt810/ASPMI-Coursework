%% --- 3. Widely Linear Filtering and Adaptive Spectrum Estimation --- %%

%%
%close all;
clear all;
clc;

%% Initialization

N = 1000;
f0 = 50;
fs = 5000;
V = 1;
phi = 0;

%% Balanced Complex Voltages (V = [1, 1, 1], delta = [0, 0, 0])

V = V*ones(1,3);
Delta = zeros(1,3);

v = clarke_transform(V, Delta, f0, fs, phi, N);

%% Unbalanced Complex Voltages (|V| = [2, 1, 1], delta = [0, 0, 0])

V = 1;
V = V*ones(1,3);
V(1) = 2;
Delta = zeros(1,3);

v_ub_mag_a = clarke_transform(V, Delta, f0, fs, phi, N);

%% Unbalanced Complex Voltages (|V| = [1, 1, 1], delta = [0, pi/6, 0])

V = 1;
V = V*ones(1,3);
Delta = zeros(1,3);
Delta(2) = pi/6;

v_ub_delta_b = clarke_transform(V, Delta, f0, fs, phi, N);

%% Plotting circularity plots

figure;
hold on;
scatter(real(v), imag(v), 'Linewidth', 2);
scatter(real(v_ub_mag_a), imag(v_ub_mag_a), 'Linewidth', 2);
scatter(real(v_ub_delta_b), imag(v_ub_delta_b), 'Linewidth', 2);
xlabel('Re(z)');
ylabel('Im(z)');
title('System Voltages');
legend('Balanced', 'Unbalanced Voltage Magnitude', 'Unbalanced Voltage Phase');
grid minor;
xlim([-2.5, 2.5]);
ylim([-2.5, 2.5]);
hold off