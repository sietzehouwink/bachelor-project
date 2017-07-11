clear global;
clear variables;

figure;
hold on;
xlabel('number of agents', 'FontSize', 14);
ylabel('match probability', 'FontSize', 14);


% title({'Unrestricted - Edge - Bipartite Graph', 'Contour Core Execution Time  = 1.0 s'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/unrestricted_edge_bipartite_solver_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Unrestricted - Edge - Bipartite Graph', 'Domains'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/unrestricted_edge_bipartite_solver_0,1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], ':k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/unrestricted_edge_bipartite_solver_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], ':k');
% plot([450 450], [0.2138 1],'-ok');
% plot([615 615], [0.1155 0.3448],'-ok');
% plot([779 779], [0.05 0.181],'-ok');
% plot([224 450], [1 1], '-xk');
% plot([297 557], [0.525 0.525], '-xk');
% plot([779 1893], [0.05 0.05], '-xk');

% title({'Restricted - Cycle & Chain', 'Contour Core Execution Time = 1.0 s', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/restricted_cycles_chains_solver_2_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Restricted - Cycle & Chain', 'Domains', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/restricted_cycles_chains_solver_2_0,1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], ':k');
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/restricted_cycles_chains_solver_2_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], ':k');
% plot([370 370], [0.3448 1],'-ok');
% plot([934 934], [0.1155 0.3776],'-ok');
% plot([1497 1497], [0.05 0.2138],'-ok');
% plot([152 370], [1 1], '-xk');
% plot([255 672], [0.525 0.525], '-xk');
% plot([1497 4448], [0.05 0.05], '-xk');

% title({'Unrestricted - Edge - Digraph', 'Contour Core Execution Time  = 1.0 s'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/unrestricted_edge_digraph_solver_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Restricted - Edge - Paths', 'Contour Core Execution Time = 1.0 s', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/restricted_edge_paths_solver_2_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% title({'Restricted - Edge - Cycles & Chains', 'Contour Core Execution Time = 1.0 s', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/restricted_edge_cycles_chains_solver_2_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');

% POWERPOINT
set(gca, 'Color', 'None')
set(gcf, 'Position', [100, 100, 1024, 512])
ax = gca;
ax.LineWidth = 3;
ax.XColor = [28 173 228] / 255;
ax.YColor = [28 173 228] / 255;
ax.FontSize = 32;
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/unrestricted_edge_bipartite_solver_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k', 'Color', [28 173 228] / 255, 'LineWidth', 3);
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour/measurements/restricted_cycles_chains_solver_2_1s.mat')
% plot([0, visited_nr_nodes], [1,visited_match_probability], 'k', 'Color', [28 173 228] / 255, 'LineWidth', 3);

xlim([0 Inf]);
ylim([0 1.1]);
