clear global;
clear variables;

figure;
hold on;
xlabel('number of agents', 'FontSize', 14);
ylabel('match probability', 'FontSize', 14);

% title({'Contour 0.95 of Max Exchange Value', 'Unrestricted Cycle Length'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour_fraction/measurements/unrestricted.mat')

% title({'Contour 0.95 of Max Exchange Value', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour_fraction/measurements/restricted_2.mat')

title({'Contour 0.95 of Max Exchange Value', 'Max Cycle Length = 3'}, 'FontSize', 14)
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/contour_fraction/measurements/restricted_3.mat')

plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');
xlim([0 Inf]);
ylim([0 1.1]);
