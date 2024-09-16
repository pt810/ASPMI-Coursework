function [eta, rho] = circularity(data)
    p = mean(data.*data);
    c = mean(abs(data).^2);
    rho = p/c;
    eta = abs(rho);
end

