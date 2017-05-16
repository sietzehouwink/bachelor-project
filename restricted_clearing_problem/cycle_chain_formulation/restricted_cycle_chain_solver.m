function [activated_digraph, exchange_value, timed_out] = restricted_cycle_chain_solver(digraph, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains, timeout_solver)
    [cycles_chains, timed_out] = get_cycles_chains(digraph, 0, max_edges_cycle, 0, max_edges_chain, timeout_find_cycles_chains);
    if timed_out
        activated_digraph = digraph();
        exchange_value = 0;
        return;
    end
    [inequality_matrix, inequality_vector] = get_containment_count_constraints(cycles_chains, numnodes(digraph));
    [activated_cycle_indices, exchange_value, timed_out] = activate_maximizing_value(cellfun(@length, cycles_chains)-1, inequality_matrix, inequality_vector, [], [], timeout_solver);
    if timed_out
        activated_digraph = digraph();
        return;
    end
    activated_digraph = cycles_chains_to_digraph(cycles_chains(activated_cycle_indices), numnodes(digraph));
end

function [inequality_matrix, inequality_vector] = get_containment_count_constraints(cycles_chains, nr_nodes)
    inequality_matrix = get_node_containment_count_matrix(cycles_chains, nr_nodes);
    inequality_vector = ones(nr_nodes,1);
end

function [node_containment_count_matrix] = get_node_containment_count_matrix(cycles_chains, nr_nodes)
    node_containment_count_matrix = zeros(nr_nodes, length(cycles_chains));
    for cycle_index = 1:length(cycles_chains)
        node_containment_count_matrix(cycles_chains{cycle_index}, cycle_index) = 1;
    end
end
