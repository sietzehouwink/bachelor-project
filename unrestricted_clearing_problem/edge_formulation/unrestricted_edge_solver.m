function [activated_digraph, exchange_value, timed_out] = unrestricted_edge_solver(digraph_, timeout)
    [activated_digraph, exchange_value, timed_out] = restricted_edge_paths_solver(digraph_, Inf, Inf, timeout);
end