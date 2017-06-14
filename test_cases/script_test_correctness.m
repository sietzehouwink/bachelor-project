clear global;
clear variables;
load('digraphs.mat', 'digraphs')

disallowed_path_length = 3;
max_cycle_length = 3;
max_chain_length = 2;
timeout = 10;

solvers = {
%     @(digraph) unrestricted_edge_bipartite_solver(digraph, timeout, cplexoptimset);
%     @(digraph) unrestricted_edge_digraph_solver(digraph, timeout, cplexoptimset);
%     @(digraph) unrestricted_cycle_chain_solver(digraph, timeout, timeout, cplexoptimset);
    @(digraph) restricted_edge_paths_solver(digraph, disallowed_path_length, timeout, timeout, cplexoptimset);
    @(digraph) restricted_edge_cycles_chains_solver(digraph, max_cycle_length, max_chain_length, timeout, timeout, cplexoptimset);
    @(digraph) restricted_cycle_chain_solver(digraph, max_cycle_length, max_chain_length, timeout, timeout, cplexoptimset)
};

for index_solver = 1:length(solvers)
    solver = solvers{index_solver};
    [activated_digraphs, exchange_values, timed_outs, core_exec_times] = evaluate(digraphs, solver);
    disp(exchange_values');
end
