%% --- 4. From LMS to Deep Learning --- %%

%%
close all;
clear all;
clc;

%%

load('time-series.mat')

y_orig = y;
y = detrend(y); % remove mean from y

mu = 1e-5;
order = 4;

[yhat, error, A] = lms(y, mu, order);

MSE = mean(error.^2);
Rp = pow2db(var(yhat)/var(error));

%%

figure;
subplot(1,2,1);
hold on;
plot(y,'linewidth',2);
plot(yhat,'linewidth',2);
xlabel('Sample (n)');
ylabel('Amplitude');
legend('Zero-Mean Original','LMS Prediction');
grid minor;
title('LMS Prediction');
hold off;
subplot(1,2,2);
hold on;
plot(y,'linewidth',2);
plot(yhat,'linewidth',2);
xlabel('Sample (n)');
ylabel('Amplitude');
legend('Zero-Mean Original','LMS Prediction');
grid minor;
title('Segment of LMS Prediction');
xlim([800,1000])
hold off;