clear global;
clear variables;

figure;
hold on;
xlabel('match probability', 'FontSize', 14);
ylabel('core execution time (s)', 'FontSize', 14);
ylim([0,Inf]);

% title({'Unrestricted - Edge - Bipartite Graph', 'Number of Agents = 450'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability_c_nodes/measurements/unrestricted_450_0,2138-1.mat')
% title({'Unrestricted - Edge - Bipartite Graph', 'Number of Agents = 615'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability_c_nodes/measurements/unrestricted_615_0,1155-0,3448.mat')
% title({'Unrestricted - Edge - Bipartite Graph', 'Number of Agents = 779'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability_c_nodes/measurements/unrestricted_779_0,05-0,181.mat')

% title({'Restricted - Cycle & Chain', 'Number of Agents = 370', 'Max Cycle Length = 2'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability_c_nodes/measurements/restricted_2_370_0,3448-1.mat')
% title({'Restricted - Cycle & Chain', 'Number of Agents = 934', 'Max Cycle Length = 2'}, 'FontSize', 14);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability_c_nodes/measurements/restricted_2_934_0,1155-0,3776.mat')
title({'Restricted - Cycle & Chain', 'Number of Agents = 1497', 'Max Cycle Length = 2'}, 'FontSize', 14);
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability_c_nodes/measurements/restricted_2_1497_0,05-0,2138.mat')


errorbar(samples_match_probability, median_core_exec_times, mad_core_exec_times, 'k');