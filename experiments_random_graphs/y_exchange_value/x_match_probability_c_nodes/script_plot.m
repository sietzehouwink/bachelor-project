clear global;
clear variables;

figure;
hold on;
xlabel('match probability', 'FontSize', 14);
ylabel('fraction of maximum exchange value', 'FontSize', 14);
ylim([0,Inf]);

% title({'Unrestricted', 'Number of Agents = 7'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/x_match_probability_c_nodes/measurements/unrestricted_7_0,1155-0,4103.mat')
% title({'Unrestricted', 'Number of Agents = 12'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/x_match_probability_c_nodes/measurements/unrestricted_12_0,08276-0,2138.mat')
% title({'Unrestricted', 'Number of Agents = 17'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_exchange_value/x_match_probability_c_nodes/measurements/unrestricted_17_0,05-0,181.mat')


errorbar(samples_match_probability, median_exchange_values / nr_nodes, mad_exchange_values / nr_nodes, 'k');