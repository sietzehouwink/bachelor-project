function [] = plot_results(display_name, xs, mean_ys, std_ys, excluded)
    x = xs(~excluded);
    y = mean_ys(~excluded);
    err = std_ys(~excluded);
    errorbar(x, y, err, 'DisplayName', display_name);  
end
