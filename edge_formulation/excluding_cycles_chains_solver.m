function [activated_digraph, exchange_value, timed_out] = excluding_cycles_chains_solver(digraph_, max_edges_cycle, max_edges_chain, timeout_find_cycles_chains, timeout_solver)
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
    tic;
    [inequality_matrix_1, inequality_vector_1, timed_out] = get_excluded_cycles_constraints(digraph, max_edges_cycle, timeout_find_cycles_chains);
    if timed_out    
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    timeout_find_cycles_chains = max(timeout_find_cycles_chains - toc,0);
    [inequality_matrix_2, inequality_vector_2, timed_out] = get_excluded_chains_constraints(digraph, max_edges_chain, timeout_find_cycles_chains);
    if timed_out    
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    [inequality_matrix_3, inequality_vector_3] = get_unrestricted_constraints(digraph);
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2; inequality_matrix_3];
    inequality_vector = [inequality_vector_1; inequality_vector_2; inequality_vector_3];
end

function [inequality_matrix, inequality_vector, timed_out] = get_excluded_cycles_constraints(digraph, max_edges_cycle, timeout)
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    [cycles, timed_out] = find_cycles(digraph, nodes_trader, max_edges_cycle+1, length(nodes_trader), timeout);
    if timed_out
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    inequality_matrix = zeros(length(cycles), numedges(digraph));
    for index_cycle = 1:length(cycles)
        cycle = cycles{index_cycle};
        edges_in_cycle = findedge(digraph, cycle, [cycle(2:end); cycle(1)]);
        inequality_matrix(index_cycle,edges_in_cycle) = 1;
    end
    inequality_vector = cellfun(@length, cycles) - 1;
end

function [inequality_matrix, inequality_vector, timed_out] = get_excluded_chains_constraints(digraph, max_edges_chain, timeout)
    [chains, timed_out] = find_paths(digraph, find(strcmp(digraph.Nodes.AgentType, 'donor')), max_edges_chain+1, numnodes(digraph)-1, timeout);
    if timed_out
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    inequality_matrix = zeros(length(chains), numedges(digraph));
    for index_path = 1:length(chains)
        path = chains{index_path};
        edges_in_path = findedge(digraph, path(1:end-1),path(2:end));
        inequality_matrix(index_path,edges_in_path) = 1;
    end
    inequality_vector = cellfun(@length, chains) - 2;
end