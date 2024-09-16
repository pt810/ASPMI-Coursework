function [weights, error, step_size] = gass(input_signal, target_signal, order, initial_step, leakage_factor, rho, algorithm)
    N = size(input_signal, 2);
    weights = zeros(order, N + 1);
    error = zeros(1, N);
    input_delayed = zeros(order, N);
    cost = zeros(order, N+1);
    step_size = zeros(1, N + 1);
    step_size(1) = initial_step;
    
    [~, max_step] = corrmtx(target_signal, 0);
    
    for i = 1:order
        input_delayed(i, :) = [zeros(1, i), input_signal(1:N - i)];
    end
    
    for i = 1:N
        prediction = weights(:, i)' * input_delayed(:, i);
        error(:, i) = target_signal(:, i) - prediction;
        step_size(i + 1) = step_size(i) + rho * error(:, i) * input_delayed(:, i)' * cost(:,i);
    
        if step_size(i + 1) < 0
            step_size(i + 1) = 0;
        elseif step_size(i + 1) > max_step
            step_size(i + 1) = max_step;
        end
        
        weights(:, i + 1) = (1 - step_size(i) * leakage_factor) * weights(:, i) + step_size(i) * error(:, i) * input_delayed(:, i);
    
        switch algorithm.name
            case 'Benveniste'
                cost(:, i+1) = (eye(order) - step_size(i) * input_delayed(:, i) * input_delayed(:, i)') * cost(:, i) + error(:, i) * input_delayed(:,i);
            case 'Ang'
                cost(:, i+1) = algorithm.param * cost(:,i) + error(:,i) * input_delayed(:,i);
            case 'Matthews'
                cost(:, i+1) = error(:,i) * input_delayed(:,i);
        end
    end
        
    % Remove initial zero column from weights and last element from step_size
    weights = weights(:, 2:end);
    step_size = step_size(:, 1:end - 1);
end