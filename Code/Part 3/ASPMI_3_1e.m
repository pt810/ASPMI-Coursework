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

%% Estimation of different signals with CLMS and ACLMS

b_in = delayseq(v',1); % balanced system
[h_clms_balanced, ~, ~] = clms(v',b_in,0,0.01,0);
h_clms_balanced(1:2) = 1;
[q_aclms_balanced, ~, ~] = aclms(v',b_in,0,0.01,0);
q_aclms_balanced(1:2,1:2) = 1;

ub_mag_in = delayseq(v_ub_mag_a', 1); % unbalanced system |V|
[h_clms_unbalanced1, ~, ~] = clms(v_ub_mag_a',ub_mag_in,0,0.01,0);
h_clms_unbalanced1(1:2) = 1;
[q_aclms_unbalanced1, ~, ~] = aclms(v_ub_mag_a',ub_mag_in,0,0.01,0);
q_aclms_unbalanced1(1:2,1:2) = 1;

ub_delta_in = delayseq(v_ub_delta_b', 1); % unbalanced system (phase)
[h_clms_unbalanced2, ~, ~] = clms(v_ub_delta_b',ub_delta_in,0,0.01,0);
h_clms_unbalanced2(1:2) = 1;
[q_aclms_unbalanced2, ~, ~] = aclms(v_ub_delta_b',ub_delta_in,0,0.01,0);
q_aclms_unbalanced2(1:2,1:2) = 1;

%% Frequency estimation
f_clms_balanced = FSL(h_clms_balanced,fs);
f_aclms_balanced = FWL(q_aclms_balanced,fs);
f_clms_unbalanced1 = FSL(h_clms_unbalanced1,fs);
f_aclms_unbalanced1 = FWL(q_aclms_unbalanced1,fs);
f_clms_unbalanced2 = FSL(h_clms_unbalanced2,fs);
f_aclms_unbalanced2 = FWL(q_aclms_unbalanced2,fs);


%% Plotting frequency estimates
figure;
subplot(3,1,1);
hold on;
plot([1:length(f_clms_balanced)], f_clms_balanced(1:end),'LineWidth',2);
plot([1:length(f_aclms_balanced)],f_aclms_balanced(1:end),'LineWidth',2);
xlabel('Time (samples)');
ylabel('Frequency (Hz)');
title('Balanced System (V = [1, 1, 1], Delta = [0, 0, 0])', 'Interpreter','latex');
legend('CLMS','ACLMS');
grid minor;
hold off;

subplot(3,1,2);
hold on;
plot([1:length(f_clms_unbalanced1)], f_clms_unbalanced1(1:end),'LineWidth',2);
plot([1:length(f_aclms_unbalanced1)],f_aclms_unbalanced1(1:end),'LineWidth',2);
xlabel('Time (samples)');
ylabel('Frequency (Hz)');
title('Unbalanced System (V = [2, 1, 1], Delta = [0, 0, 0])', 'Interpreter','latex');
legend('CLMS','ACLMS');
grid minor;
hold off;

subplot(3,1,3);
hold on;
plot([1:length(f_clms_unbalanced2)], f_clms_unbalanced2(1:end),'LineWidth',2);
plot([1:length(f_aclms_unbalanced2)],f_aclms_unbalanced2(1:end),'LineWidth',2);
xlabel('Time (samples)');
ylabel('Frequency (Hz)');
title('Unbalanced System (V = [1, 1, 1], Delta = [0, $\pi/6$, 0])', 'Interpreter','latex'); 
legend('CLMS','ACLMS');
grid minor;
hold off;


% Frequency estimation of stricly linear autoregressive model
function f = FSL(h,fs)
    f = (fs/(2*pi))*atan2(imag(h),real(h));
end


% Frequency estimation of widely linear autoregressive model
function f = FWL(q,fs)
    h = q(1,:); 
    g = q(2,:);
    f = (fs/(2*pi))*...
        atan2(real(sqrt(imag(h).^2 - abs(g).^2)),real(h));
end