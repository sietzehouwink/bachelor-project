clear global;
clear variables;

figure;
hold on;
xlabel('number of agents', 'FontSize', 14);
ylabel('core execution time (s)', 'FontSize', 14);
ylim([0,Inf]);


% title({'Unrestricted - Edge - Bipartite Graph', 'Match Probability = 0.05'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_nodes_c_match_probability/measurements/unrestricted_0,05_779-1893.mat')
% title({'Unrestricted - Edge - Bipartite Graph', 'Match Probability = 0.525'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_nodes_c_match_probability/measurements/unrestricted_0,525_297-557.mat')
title({'Unrestricted - Edge - Bipartite Graph', 'Match Probability = 1.0'}, 'FontSize', 14);
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_nodes_c_match_probability/measurements/unrestricted_1_224-450.mat')

% title({'Restricted - Cycle & Chain', 'Match Probability = 0.05', 'Max Cycle Length = 2'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_nodes_c_match_probability/measurements/restricted_2_0,05_1497-4448.mat')
% title({'Restricted - Cycle & Chain', 'Match Probability = 0.525', 'Max Cycle Length = 2'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_nodes_c_match_probability/measurements/restricted_2_0,525_255-672.mat')
% title({'Restricted - Cycle & Chain', 'Match Probability = 1.0', 'Max Cycle Length = 2'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_nodes_c_match_probability/measurements/restricted_2_1_152-370.mat')

errorbar(samples_nr_nodes, median_core_exec_times, mad_core_exec_times, 'k');