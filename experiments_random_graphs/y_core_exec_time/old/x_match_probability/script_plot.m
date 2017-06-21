clear global;
clear variables;

font_size = 16;
samples_match_probability = linspace(0, 1, 8);

figure;
hold on;
xlabel('match probability', 'FontSize', font_size);
ylabel('core execution time (s)', 'FontSize', font_size);

% title('Unrestricted Solvers', 'FontSize', font_size);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/unrestricted_edge_bipartite_448.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, 'k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/unrestricted_edge_digraph_213.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, '--k');
% legend({'bipartite graph - 448 nodes', 'digraph - 213 nodes'}, 'FontSize', font_size, 'Location', 'best');

% title('Restricted Solvers - Max Cycle Length 2', 'FontSize', font_size);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/restricted_edge_paths_2_42.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, 'k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/restricted_edge_cycles_chains_2_8.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, '--k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/restricted_cycle_chain_2_372.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, ':k');
% legend({'edge paths - 42 nodes', 'edge cycles chains - 8 nodes', 'cycle chain - 372 nodes'}, 'FontSize', font_size, 'Location', 'best');

% title('Restricted Solvers - Max Cycle Length 3', 'FontSize', font_size);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/restricted_edge_paths_3_15.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, 'k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/restricted_edge_cycles_chains_3_8.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, '--k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/x_match_probability/measurements/restricted_cycle_chain_3_44.mat');
% errorbar(samples_match_probability, mean_core_exec_times, std_core_exec_times, ':k');
% legend({'edge paths - 15 nodes', 'edge cycles chains - 8 nodes', 'cycle chain - 44 nodes'}, 'FontSize', font_size, 'Location', 'best');
