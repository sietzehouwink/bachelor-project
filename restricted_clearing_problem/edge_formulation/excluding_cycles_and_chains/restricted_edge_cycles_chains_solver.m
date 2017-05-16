function [activated_digraph, exchange_value, timed_out] = restricted_edge_cycles_chains_solver(digraph_, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains, timeout_solver)
    [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph_, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains);
    if timed_out
        activated_digraph = digraph();
        exchange_value = 0;
        return;
    end
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(digraph_.Edges.Weight, inequality_matrix, inequality_vector, [], [], timeout_solver);
    if timed_out
        activated_digraph = digraph();
        return;
    end
    activated_digraph = digraph(digraph_.Edges(activated_edge_indices,:), digraph_.Nodes);
end

function [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains)
    [inequality_matrix_1, inequality_vector_1, timed_out] = get_excluded_cycle_chain_constraints(digraph, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains);
    if timed_out
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    [inequality_matrix_2, inequality_vector_2] = get_unrestricted_edge_constraints(digraph);
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2];
    inequality_vector = [inequality_vector_1; inequality_vector_2];
end

function [inequality_matrix, inequality_vector, timed_out] = get_excluded_cycle_chain_constraints(digraph, max_edges_cycle, max_edges_chain, timeout)
    [cycles_chains, timed_out] = get_cycles_chains(digraph, max_edges_cycle+1, Inf, max_edges_chain+1, Inf, timeout);
    if timed_out
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    inequality_matrix = zeros(length(cycles_chains), numedges(digraph));
    for index_cycle = 1:length(cycles_chains)
        cycle_chain = cycles_chains{index_cycle};
        edges_in_cycle = findedge(digraph, cycle_chain(1:end-1), cycle_chain(2:end));
        inequality_matrix(index_cycle, edges_in_cycle) = 1;
    end
    inequality_vector = cellfun(@length, cycles_chains) - 2;
end