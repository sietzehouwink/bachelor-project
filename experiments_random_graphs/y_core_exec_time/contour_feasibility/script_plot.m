clear global;
clear variables;

figure;
hold on;
xlabel('number of agents', 'FontSize', 14);
ylabel('match probability', 'FontSize', 14);

% title({'Contour Timeout 1 Second', 'Unrestricted - Edge - Bipartite graph'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour_feasibility/measurements/unrestricted_edge_bipartite_solver.mat')

% title({'Contour Timeout 1 Second', 'Unrestricted - Edge - Digraph'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour_feasibility/measurements/unrestricted_edge_digraph_solver.mat')

% title({'Contour Timeout 1 Second', 'Restricted - Edge - Paths', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour_feasibility/measurements/restricted_edge_paths_solver_2.mat')

% title({'Contour Timeout 1 Second', 'Restricted - Edge - Cycles & Chains', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour_feasibility/measurements/restricted_edge_cycles_chains_solver_2.mat')

% title({'Contour Timeout 1 Second', 'Restricted - Cycle & Chain', 'Max Cycle Length = 2'}, 'FontSize', 14)
% load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/y_core_exec_time/contour_feasibility/measurements/restricted_cycle_chain_solver_2.mat')

plot([0, visited_nr_nodes], [1,visited_match_probability], 'k');
xlim([0 Inf]);
ylim([0 1.1]);
