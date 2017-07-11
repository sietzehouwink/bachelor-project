function [exchange_digraph, exchange_value, timed_out, core_exec_time] = unrestricted_edge_bipartite_solver(market_digraph, timeout, cplex_options)
    % Convert to bipartite graph.
    market_bipartite_graph = to_bipartite_graph(market_digraph);
    
    % Get LP.
    [weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lower_bounds, upper_bounds] = get_LP(market_bipartite_graph);
    
    % Solve LP.
    [setting_edges, exchange_value, timed_out, core_exec_time] = LP_solver(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lower_bounds, upper_bounds, timeout, cplex_options);
    setting_edges = round(setting_edges); exchange_value = round(exchange_value); % Floating point inaccuracy.
    if timed_out
        exchange_digraph = NaN; exchange_value = NaN; core_exec_time = NaN;
        return;
    end
    
    % Convert to exchange digraph.
    exchange_digraph = get_exchange_digraph(market_bipartite_graph, setting_edges);
end

function [market_bipartite_graph] = to_bipartite_graph(market_digraph)     
    node_table = to_bipartite_graph_node_table(market_digraph);
    edge_table = to_bipartite_graph_edge_table(market_digraph);
    market_bipartite_graph = graph(edge_table, node_table);
end

function [node_table] = to_bipartite_graph_node_table(market_digraph)
    AgentType = repmat(market_digraph.Nodes.AgentType, 2, 1);
    ItemType = repelem([{'provided'}; {'wanted'}], numnodes(market_digraph), 1);
    node_table = table(AgentType, ItemType);
end

function [edge_table] = to_bipartite_graph_edge_table(market_digraph)
    edges_weight_1 = [market_digraph.Edges.EndNodes(:,1), market_digraph.Edges.EndNodes(:,2) + numnodes(market_digraph)];
    traders = get_nodes_of_agent_type(market_digraph, 'trader');
    edges_weight_0 = [traders, traders + numnodes(market_digraph)];
    EndNodes = [edges_weight_1; edges_weight_0];
    Weight = [ones(numedges(market_digraph),1); zeros(length(traders), 1)];
    edge_table = table(EndNodes, Weight);
end

function [weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lower_bounds, upper_bounds] = get_LP(bipartite_graph)
    weight_vector = bipartite_graph.Edges.Weight;
    [equality_matrix, equality_vector] = get_trader_wanted_constraints(bipartite_graph);
    [inequality_matrix, inequality_vector] = get_remaining_constraints(bipartite_graph);
    lower_bounds = zeros(length(weight_vector), 1);
    upper_bounds = ones(length(weight_vector), 1);
end

function [equality_matrix, equality_vector] = get_trader_wanted_constraints(bipartite_graph)
    nodes_trader_wanted = find(strcmp(bipartite_graph.Nodes.AgentType, 'trader') & strcmp(bipartite_graph.Nodes.ItemType, 'wanted'));
    equality_matrix = get_degree_matrix(bipartite_graph, nodes_trader_wanted);
    equality_vector = ones(length(nodes_trader_wanted), 1);
end

function [inequality_matrix, inequality_vector] = get_remaining_constraints(bipartite_graph)
    nodes_remaining = find(~(strcmp(bipartite_graph.Nodes.AgentType, 'trader') & strcmp(bipartite_graph.Nodes.ItemType, 'wanted')));
    inequality_matrix = get_degree_matrix(bipartite_graph, nodes_remaining);
    inequality_vector = ones(length(nodes_remaining), 1);
end

function [degree_matrix] = get_degree_matrix(bipartite_graph, nodes)
    incidence_matrix = incidence(bipartite_graph);
    degree_matrix = abs(incidence_matrix(nodes, :));
end

function [exchange_digraph] = get_exchange_digraph(market_bipartite_graph, setting_edges)
    exchange_edges = market_bipartite_graph.Edges(logical(setting_edges), :);
    exchange_bipartite_graph = graph(exchange_edges, market_bipartite_graph.Nodes);
    exchange_digraph = to_digraph(exchange_bipartite_graph);
end

function [market_digraph] = to_digraph(market_bipartite_graph)
    start_nodes_edges = market_bipartite_graph.Edges.EndNodes(:,1);
    end_nodes_edges = market_bipartite_graph.Edges.EndNodes(:,2) - numnodes(market_bipartite_graph)/2;
    nr_nodes_digraph = numnodes(market_bipartite_graph)/2;
    market_digraph = digraph(start_nodes_edges, end_nodes_edges, 1, nr_nodes_digraph, 'OmitSelfLoops');
    market_digraph.Nodes = market_bipartite_graph.Nodes(1:end/2,1);
end
