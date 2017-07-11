function [exchange_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_cycles_chains_solver(market_digraph, max_nr_edges_cycle, max_nr_edges_chain, timeout_find_cycles_chains, timeout_solver, cplex_options)
    % Get BILP.
    [weight_vector, inequality_matrix, inequality_vector, timed_out] = get_BILP(market_digraph, max_nr_edges_cycle, max_nr_edges_chain, timeout_find_cycles_chains);
    if timed_out
        exchange_digraph = NaN; exchange_value = NaN; core_exec_time = NaN;
        return;
    end
    
    % Solve BILP and act on timeout.
    [setting_edges, exchange_value, timed_out, core_exec_time] = BILP_solver(weight_vector, inequality_matrix, inequality_vector, [], [], timeout_solver, cplex_options);  
    if timed_out
        exchange_digraph = NaN; exchange_value = NaN; core_exec_time = NaN;
        return;
    end
    
    % Convert to exchange digraph.
    exchange_digraph = get_exchange_digraph(market_digraph, setting_edges);
end

function [weight_vector, inequality_matrix, inequality_vector, timed_out] = get_BILP(market_digraph, max_nr_edges_cycle, max_nr_edges_chain, timeout_find_cycles_chains)
    % Get cycle and chain constraints.
    [inequality_matrix_1, inequality_vector_1, timed_out] = get_disallowed_cycles_chains_constraints(market_digraph, max_nr_edges_cycle, max_nr_edges_chain, timeout_find_cycles_chains); 
    if timed_out
        weight_vector = NaN; inequality_matrix = NaN; inequality_vector = NaN;
        return;
    end
    
    % Get other constraints.
    [inequality_matrix_2, inequality_vector_2] = get_unrestricted_edge_digraph_constraints(market_digraph);
    
    % Construct results.
    weight_vector = market_digraph.Edges.Weight;
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2];
    inequality_vector = [inequality_vector_1; inequality_vector_2];
end

function [inequality_matrix, inequality_vector, timed_out] = get_disallowed_cycles_chains_constraints(market_digraph, max_nr_edges_cycle, max_nr_edges_chain, timeout)
    % Get cycles and chains.
    [cycles_chains, timed_out] = get_cycles_chains(market_digraph, max_nr_edges_cycle+1, Inf, max_nr_edges_chain+1, Inf, timeout);
    if timed_out
        inequality_matrix = NaN; inequality_vector = NaN;
        return;
    end
    
    % Construct results using sparsity.
    nr_edges_cycles_chains = structures_to_nr_edges(cycles_chains);
    indices_cycles_chains = repelem(1:length(cycles_chains), nr_edges_cycles_chains); 
    [start_nodes, end_nodes] = structures_to_edges(cycles_chains);
    indices_edges = findedge(market_digraph, start_nodes, end_nodes);
    inequality_matrix = sparse(indices_cycles_chains, indices_edges, 1, length(cycles_chains), numedges(market_digraph));    
    inequality_vector = nr_edges_cycles_chains - 1;
end

function [exchange_digraph] = get_exchange_digraph(market_digraph, setting_edges)
    exchange_edges = market_digraph.Edges(logical(setting_edges), :);
    exchange_digraph = digraph(exchange_edges, market_digraph.Nodes);
end