function [activated_digraph, exchange_value, timed_out] = unrestricted_bipartite_solver(digraph, timeout)
    bipartite_graph = to_provided_wanted_bipartite_graph(digraph);
    [equality_matrix, equality_vector] = get_trader_wanted_constraints(bipartite_graph);
    [inequality_matrix, inequality_vector] = get_remaining_constraints(bipartite_graph);
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(bipartite_graph.Edges.Weight, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout);
    if timed_out
        activated_digraph = digraph();
        return;
    end
    activated_bipartite_graph = graph(bipartite_graph.Edges(activated_edge_indices,:), bipartite_graph.Nodes);
    activated_digraph = to_digraph(activated_bipartite_graph);
end

function [equality_matrix, equality_vector] = get_trader_wanted_constraints(bipartite_graph)
    nodes_trader_wanted = find(strcmp(bipartite_graph.Nodes.AgentType, 'trader') & strcmp(bipartite_graph.Nodes.ItemType, 'wanted'));
    equality_matrix = get_degree_matrix(bipartite_graph, nodes_trader_wanted);
    equality_vector = ones(length(nodes_trader_wanted),1);
end

function [inequality_matrix, inequality_vector] = get_remaining_constraints(bipartite_graph)
    nodes_remaining = find(~(strcmp(bipartite_graph.Nodes.AgentType, 'trader') & strcmp(bipartite_graph.Nodes.ItemType, 'wanted')));
    inequality_matrix = get_degree_matrix(bipartite_graph, nodes_remaining);
    inequality_vector = ones(length(nodes_remaining),1);
end