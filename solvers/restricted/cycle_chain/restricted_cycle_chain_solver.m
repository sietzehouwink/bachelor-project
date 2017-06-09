function [activated_digraph, exchange_value, timed_out, core_exec_time] = restricted_cycle_chain_solver(digraph_, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains, timeout_solver, optimoptions)
    [cycles_chains, timed_out] = get_cycles_chains(digraph_, 0, max_edges_cycle, 0, max_edges_chain, timeout_find_cycles_chains);
    
    if timed_out
        activated_digraph = digraph();
        exchange_value = 0;
        core_exec_time = 0;
        return;
    end
    
    [inequality_matrix, inequality_vector] = get_containment_count_constraints(cycles_chains, numnodes(digraph_));
    
    [setting_cycles_chains, exchange_value, timed_out, core_exec_time] = BILP_solver(cellfun(@length, cycles_chains)-1, inequality_matrix, inequality_vector, [], [], timeout_solver, optimoptions);
    
    if timed_out
        activated_digraph = digraph();
        return;
    end
    
    activated_digraph = cycles_chains_to_digraph(cycles_chains(logical(setting_cycles_chains)), numnodes(digraph_));
end

function [inequality_matrix, inequality_vector] = get_containment_count_constraints(cycles_chains, nr_nodes)
    inequality_matrix = get_node_containment_count_matrix(cycles_chains, nr_nodes);
    inequality_vector = ones(nr_nodes,1);
end
