function [coeffs, pred_error, pred_sig] = aclms(y, x, order, learning_rate, leak)
    coeffs = zeros(2*(order+1), length(x),'like',1i);  
    pred_error = zeros(size(x),'like',1i);
    pred_sig = zeros(size(x),'like',1i);
    x_pad = [zeros(order,1,'like',1i); x]; % zero-padding
    for n = 1:length(x)
        x_a = [x_pad(n+order:-1:n); conj(x_pad(n+order:-1:n))];
        pred_sig(n) = coeffs(:,n)'*x_a;
        pred_error(n) = y(n) - pred_sig(n);
        if n < length(x)
            coeffs(:, n+1) = (1-learning_rate*leak)*coeffs(:, n) + learning_rate*conj(pred_error(n))*x_a;
        end
    end
end

