function t = time_constant(u, l)
    t = -1 / log(abs(1 - 2 * u * l));
end