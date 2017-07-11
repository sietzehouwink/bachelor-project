function [exchange_digraph, exchange_value, timed_out, core_exec_time] = unrestricted_edge_digraph_solver(digraph_, timeout, cplex_options)
    % Use restricted_edge_paths_solver (no execution time penalty).
    [exchange_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_paths_solver(digraph_, Inf, Inf, timeout, cplex_options);
end