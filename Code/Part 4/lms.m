function [pred_sig, pred_error, A] = lms(x, step_size, order)
    N = length(x);
    A = zeros(order, N);
    pred_sig = zeros(size(x));
    pred_error = zeros(1, N);
    for i = order+1:N
        past_x = x(i-1:-1:i-order);
        pred_sig(i) = A(:, i)'*past_x;
        pred_error(i) = x(i) - pred_sig(i);
        A(:, i+1) = A(:, i) + step_size*pred_error(i)*past_x;
    end
    A = A(:, 2:end);
end