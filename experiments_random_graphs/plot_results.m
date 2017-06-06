function [] = plot_results(title_, xlabel_, xs, ylabel_, mean_ys, std_ys, excluded)
    x = xs(~excluded);
    y = mean_ys(~excluded);
    err = std_ys(~excluded);
    
    figure;
    hold on;
    title(title_);
    xlabel(xlabel_);
    ylabel(ylabel_);
    errorbar(x, y, err);  
    ylim([0 inf]);
end
