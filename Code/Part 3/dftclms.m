function [coeffs, pred_error] = dftclms(y, x, leak)
    [nft, num_samples] = size(x);
    coeffs = zeros(nft, num_samples,'like',1i); 
    pred_error = zeros(num_samples,1,'like',1i);
    learning_rate = 1;
    for n = 1:num_samples
        pred_error(n) = y(n) - coeffs(:,n)' * x(:,n);
        if n < length(x)
            coeffs(:, n+1) = (1-learning_rate*leak)*coeffs(:, n) + learning_rate*conj(pred_error(n))*x(:,n);
        end
    end
end

