%% --- 4. From LMS to Deep Learning --- %%

%%
close all;
clear all;
clc;

%%

load('time-series.mat')

mu = 1e-5;
order = 4;

yAug = [1; y];
Y = yAug(1:21, 1);

A = zeros(order, length(Y));

for i = 1:100
    [yhat, error, A] = lmsPT(Y, mu, order, 52, A);
    a = A(:, end);
    A = [zeros(4, length(Y))];
    A(:, order+1) = a;
end

yAug = [1; y];

[yhat, error, A] = lmsPT(yAug, mu, order, 52, A);

MSE = mean(error.^2);
Rp = pow2db(var(yhat)/var(error));

%%

figure;
subplot(1,2,1);
hold on;
plot(y,'linewidth',2);
plot(yhat(2:end),'linewidth',2);
xlabel('Sample (n)');
ylabel('Amplitude');
legend('Original','LMS with Training Prediction');
grid minor;
title('LMS with Training Prediction');
xlim([0 1000]);
hold off;
subplot(1,2,2);
hold on;
plot(y,'linewidth',2);
plot(yhat(2:end),'linewidth',2);
xlabel('Sample (n)');
ylabel('Amplitude');
legend('Original','LMS with Training Prediction');
grid minor;
title('Segment of LMS with Training Prediction');
xlim([800,1000])
hold off;