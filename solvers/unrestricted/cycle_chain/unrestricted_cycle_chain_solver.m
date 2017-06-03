function [activated_digraph, exchange_value, timed_out, core_exec_time] = unrestricted_cycle_chain_solver(digraph, timeout_find_cycles_chains, timeout_solver, optimoptions)
    [activated_digraph, exchange_value, timed_out, core_exec_time] = restricted_cycle_chain_solver(digraph, Inf, Inf, timeout_find_cycles_chains, timeout_solver, optimoptions);
end

