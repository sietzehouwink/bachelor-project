function [exchange_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_paths_solver(market_digraph, disallowed_nr_edges_path, timeout_find_paths, timeout_solver, cplex_options)
    % Get BILP.
    [weight_vector, inequality_matrix, inequality_vector, timed_out] = get_BILP(market_digraph, disallowed_nr_edges_path, timeout_find_paths);
    if timed_out
        exchange_digraph = NaN; exchange_value = NaN; core_exec_time = NaN;
        return;
    end
    
    % Solve.
    [setting_edges, exchange_value, timed_out, core_exec_time] = BILP_solver(weight_vector, inequality_matrix, inequality_vector, [], [], timeout_solver, cplex_options);  
    if timed_out
        exchange_digraph = NaN; exchange_value = NaN; core_exec_time = NaN;
        return;
    end
    
    % Convert to exchange digraph.
    exchange_digraph = get_exchange_digraph(market_digraph, setting_edges);
end

function [weight_vector, inequality_matrix, inequality_vector, timed_out] = get_BILP(market_digraph, disallowed_nr_edges_path, timeout)
    % Get path constraints.
    [inequality_matrix_1, inequality_vector_1, timed_out] = get_disallowed_paths_constraints(market_digraph, disallowed_nr_edges_path, timeout);   
    if timed_out    
        weight_vector = NaN; inequality_matrix = NaN; inequality_vector = NaN;
        return;
    end
    
    % Get other constraints.
    [inequality_matrix_2, inequality_vector_2] = get_unrestricted_edge_digraph_constraints(market_digraph);
    
    % Construct results.
    weight_vector = ones(numedges(market_digraph), 1);
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2];
    inequality_vector = [inequality_vector_1; inequality_vector_2];
end

function [inequality_matrix, inequality_vector, timed_out] = get_disallowed_paths_constraints(market_digraph, disallowed_nr_edges_path, timeout)
    % Get paths.
    [paths, timed_out] = get_paths(market_digraph, 1:numnodes(market_digraph), disallowed_nr_edges_path, disallowed_nr_edges_path, timeout);
    if timed_out
        inequality_matrix = NaN; inequality_vector = NaN;
        return;
    elseif isempty(paths)
        inequality_matrix = []; inequality_vector = [];
        return;
    end
    
    % Construct results using sparsity.
    nr_paths = length(paths);
    indices_paths = repelem(1:nr_paths, disallowed_nr_edges_path);
    [start_nodes, end_nodes] = structures_to_edges(paths);
    indices_edges = findedge(market_digraph, start_nodes, end_nodes);
    inequality_matrix = sparse(indices_paths, indices_edges, 1, nr_paths, numedges(market_digraph));    
    inequality_vector = repelem(disallowed_nr_edges_path-1, nr_paths, 1);
end

function [exchange_digraph] = get_exchange_digraph(market_digraph, setting_edges)
    exchange_edges = market_digraph.Edges(logical(setting_edges), :);
    exchange_digraph = digraph(exchange_edges, market_digraph.Nodes);
end