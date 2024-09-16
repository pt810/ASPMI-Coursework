%% --- 3. Widely Linear Filtering and Adaptive Spectrum Estimation --- %%

%%
close all;
clear all;
clc;

%% Initialization

% Add data folder to path
addpath('./wind-dataset');

% Combine two components as complex numbers and plot scatter plots
complex_v = zeros(3, 5000, 'like', 1i);
wind_categories = {'high-wind', 'medium-wind', 'low-wind'};
scatter_colors = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]};
circularity_xlimits = {[-4, 4], [-2, 2], [-0.4, 0.4]};
circularity_ylimits = {[-4, 4], [-2, 2], [-0.4, 0.4]};
circularity_subplots = [1, 3, 5];
mspe_subplots = [2, 4, 6];
figure;
for i = 1:3
    data = load(wind_categories{i});
    complex_v(i, :) = complex(data.v_east, data.v_north);
    str = split(wind_categories{i}, '-');
    tit = strcat(upper(str{1}(1)), str{1}(2:end), ' Wind');

    % Circularity plots
    subplot(3, 2, circularity_subplots(i));
    hold on;
    scatter(real(complex_v(i, :)), imag(complex_v(i, :)), 5, scatter_colors{i});
    xlabel('Re(z)');
    ylabel('Im(z)');
    xlim(circularity_xlimits{i})
    ylim(circularity_ylimits{i})
    title(tit);
    grid minor;
    hold off;
end

% Grid search to find optimal filter length for both algorithms on each
% data set
% Computing values and creating plots
n_orders = 20;
MSPE = zeros(2, 3, n_orders);
learning_rates = [0.001, 0.01, 0.1];
for j = 1:3
    subplot(3, 2, mspe_subplots(j));
    hold on;
    for i = 1:2
        input = delayseq(complex_v(j, :).', 1);
        for l = 1:n_orders
            if i == 1
                [~, err, ~] = clms(complex_v(j, :).', input, l-1, learning_rates(j), 0);
            else
                [~, err, ~] = aclms(complex_v(j, :).', input, l-1, learning_rates(j), 0);
            end
            sq_err = abs(err).^2;
            MSPE(i, j, l) = mean(sq_err);
        end
        plot(1:n_orders, 10*log10(squeeze(MSPE(i, j, :))));
    end
    str = split(wind_categories{j}, '-');
    tit = strcat(upper(str{1}(1)), str{1}(2:end), ' Wind');
    legend('CLMS', 'ACLMS');
    xlabel('Filter Order');
    ylabel('MSPE (dB)');
    title(tit);
    grid minor;
    hold off;
end

