function [activated_digraph, exchange_value, timed_out] = unrestricted_cycle_chain_solver(digraph, timeout_find_cycles_chains, timeout_solver)
    [activated_digraph, exchange_value, timed_out] = restricted_cycle_chain_solver(digraph, Inf, Inf, timeout_find_cycles_chains, timeout_solver);
end

