function [weights,errors,reg_factor] = gngd(input_signal, target_signal, order, initial_step, leakage_factor, rho)
    N = length(input_signal);
    weights = zeros(order,N+1);
    errors = zeros(1,N);
    input_delayed = zeros(order,N);
    reg_factor = ones(1,N+1);
    reg_factor(1) = initial_step;

    for i = 1:order
            input_delayed(i, :) = [zeros(1, i), input_signal(1: N-i)];
    end
    
    for i = 1:N
        predictions =   weights(:,i)'*input_delayed(:,i);
        errors(:,i) = target_signal(:,i) - predictions;
        weights(:,i+1) = weights(:,i)+(leakage_factor/(reg_factor(i)+input_delayed(:,i)'*input_delayed(:,i)))*errors(:,i)*input_delayed(:,i);
        if i > 1
            reg_factor(i+1) = reg_factor(i) - rho*initial_step*errors(i)*errors(i-1)*input_delayed(:,i)'*input_delayed(:,i-1) / (reg_factor(i-1)+input_delayed(:,i-1)'*input_delayed(:,i-1))^2;
        end
    end
    weights = weights(:,2:end);
    reg_factor = reg_factor(:,2:end);
end