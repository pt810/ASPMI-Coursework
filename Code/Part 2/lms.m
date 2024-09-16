function [weights, prediction, error] = lms(input_signal, target_signal, order, step_size, leakage_factor, delay)
    N = size(input_signal, 2);
    weights = zeros(order, N + 1);
    error = zeros(1, N);
    delayed_input = zeros(order, N);
    prediction = zeros(1, N);

    for i = 1:order
        delayed_input(i, :) = [zeros(1, i + delay - 1), input_signal(1:N - (i + delay - 1))];
    end

    for i = 1:N
        prediction(:, i) = weights(:, i)' * delayed_input(:, i);
        error(:, i) = target_signal(:, i) - prediction(:, i);
        weights(:, i + 1) = (1 - step_size * leakage_factor) * weights(:, i) + step_size * error(:, i) * delayed_input(:, i);
    end
    
    weights = weights(:, 2:end);
end

