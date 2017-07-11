function [exchange_digraph, exchange_value, timed_out, core_exec_time] = restricted_cycle_chain_solver(market_digraph, max_nr_edges_cycle, max_nr_edges_chain, timeout_find_cycles_chains, timeout_solver, cplex_options)
    % Get structures.
    [structures, timed_out] = get_cycles_chains(market_digraph, 0, max_nr_edges_cycle, 0, max_nr_edges_chain, timeout_find_cycles_chains); 
    if timed_out
        [exchange_digraph, exchange_value, core_exec_time] = set_timed_out();
        return;
    end
    
    % Get BILP.
    [weight_vector, inequality_matrix, inequality_vector] = get_BILP(market_digraph, structures);
    
    % Solve BILP.
    [setting_structures, exchange_value, timed_out, core_exec_time] = BILP_solver(weight_vector, inequality_matrix, inequality_vector, [], [], timeout_solver, cplex_options);
    if timed_out
        [exchange_digraph, exchange_value, core_exec_time] = set_timed_out();
        return;
    end
    
    % Get exchange digraph.
    exchange_digraph = get_exchange_digraph(market_digraph, structures, setting_structures);
end

function [weight_vector, inequality_matrix, inequality_vector] = get_BILP(market_digraph, structures)
    weight_vector = structures_to_nr_edges(structures);
    [inequality_matrix, inequality_vector] = get_node_containment_constraints(market_digraph, structures);
end

function [inequality_matrix, inequality_vector] = get_node_containment_constraints(market_digraph, cycles_chains)    
    indices_nodes = vertcat(cycles_chains{:});
    nr_nodes_cycles_chains = structures_to_nr_nodes(cycles_chains);    
    indices_cycles_chains = repelem(1:length(cycles_chains), nr_nodes_cycles_chains);
    inequality_matrix = sparse(indices_nodes, indices_cycles_chains, 1, numnodes(market_digraph), length(cycles_chains));
    inequality_matrix(inequality_matrix > 1) = 1; % Duplicates in sparse generation automatically sum.
    inequality_vector = ones(numnodes(market_digraph), 1);
end

function [nr_nodes_structures] = structures_to_nr_nodes(structures)
    nr_nodes_structures = zeros(length(structures), 1);
    for idx = 1:length(structures)
        structure = structures{idx};   
        nr_nodes_structures(idx) = length(structure);
    end
end

function [exchange_digraph] = get_exchange_digraph(market_digraph, cycles_chains, setting_cycles_chains)
    exchange_cycles_chains = cycles_chains(logical(setting_cycles_chains));
    [start_nodes, end_nodes] = structures_to_edges(exchange_cycles_chains);
    adjacency_matrix = sparse(start_nodes, end_nodes, 1, numnodes(market_digraph), numnodes(market_digraph));
    adjacency_matrix(adjacency_matrix > 1) = 1;  % Duplicates in sparse generation automatically sum.
    exchange_digraph = digraph(adjacency_matrix);
    exchange_digraph.Nodes = market_digraph.Nodes;
end
