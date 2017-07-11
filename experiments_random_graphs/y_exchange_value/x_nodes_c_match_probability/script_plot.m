clear global;
clear variables;

figure;
hold on;
xlabel('number of agents', 'FontSize', 14);
ylabel('fraction of maximum exchange value', 'FontSize', 14);
ylim([0,Inf]);


% title({'Unrestricted', 'Match Probability = 0.05'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/x_nodes_c_match_probability/measurements/unrestricted_0,05_17-75.mat')
% title({'Unrestricted', 'Match Probability = 0.1647'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/x_nodes_c_match_probability/measurements/unrestricted_0,16465_7-19.mat')
% title({'Unrestricted', 'Match Probability = 0.2793'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/x_nodes_c_match_probability/measurements/unrestricted_0,2793_5-10.mat')


errorbar(samples_nr_nodes, median_exchange_values ./ samples_nr_nodes', mad_exchange_values ./ samples_nr_nodes', 'k');