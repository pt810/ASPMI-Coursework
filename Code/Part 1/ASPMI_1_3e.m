%% --- 1. CLASSICAL AND MODERN SPECTRUM ESTIMATION --- %%

%% 
close all;
clear all;
clc;

%% Initialise

n1 = 0:16;
sig1 = exp(1j*2*pi*0.3*n1)+exp(1j*2*pi*0.32*n1);

n2 = 0:25;
sig2 = exp(1j*2*pi*0.3*n2)+exp(1j*2*pi*0.32*n2);

n3 = 0:97;
sig3 = exp(1j*2*pi*0.3*n3)+exp(1j*2*pi*0.32*n3);

signals = {sig1,sig2,sig3};
num_sigs = length(signals);

% Number of samples
N = [17,26,98];

% Number of trials
trials = 100;

%% Perform MUSIC Algorithm

for i = 1:num_sigs
    for j = 1:trials
        noise = 0.2/sqrt(2)*(randn(size(signals{i}))+1j*randn(size(signals{i})));
        noisy_signal = signals{i} + noise;
        [X,R] = corrmtx(noisy_signal,14,'mod');
        [S{i,j},F{i,j}] = pmusic(R,2,[ ],1,'corr');
    end
    psd_mean{i} = mean(cell2mat(S(i,:)), 2);
    psd_std{i} = std(cell2mat(S(i,:)), [], 2);
end

%% Plot Graphs

figure;
for i = 1:num_sigs
    subplot(num_sigs,1,i)
    hold on
    plot(F{i,1},psd_mean{i},'linewidth',2);
    plot(F{i,1},psd_std{i},'--','linewidth',2);
    xlim([0.25 0.40]);
    legend('Mean','Standard Deviation');
    grid minor;
    title(sprintf('MUSIC Pseudospectrum with %d samples', N(i)));
    xlabel('Frequency (Hz)');
    ylabel('Pseudospectrum');
end

