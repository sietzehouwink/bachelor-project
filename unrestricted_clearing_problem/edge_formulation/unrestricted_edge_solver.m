function [activated_digraph, exchange_value, timed_out, core_exec_time] = unrestricted_edge_solver(digraph_, timeout, optimoptions)
    [activated_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_paths_solver(digraph_, Inf, Inf, timeout, optimoptions);
end