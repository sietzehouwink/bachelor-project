function [activated_digraph, exchange_value, timed_out] = bipartite_formulation_solver(digraph, timeout)
    bipartite_graph = digraph_to_bipartite_graph(digraph);
    [equality_matrix, equality_vector] = get_trader_wanted_constraints(bipartite_graph);
    [inequality_matrix, inequality_vector] = get_remaining_constraints(bipartite_graph);
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(bipartite_graph.Edges.Weight, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout);
    if timed_out
        activated_digraph = digraph();
        return;
    end
    activated_digraph = bipartite_graph_to_digraph(graph(bipartite_graph.Edges(activated_edge_indices,:), bipartite_graph.Nodes));
end

function [bipartite_graph] = digraph_to_bipartite_graph(digraph)  
    edge_table = digraph.Edges;
    edge_table.EndNodes(:,2) = edge_table.EndNodes(:,2) + numnodes(digraph); 
    provided_node_table = digraph.Nodes;
    provided_node_table.ItemType = repmat({'provided'},numnodes(digraph),1);
    wanted_node_table = digraph.Nodes;
    wanted_node_table.ItemType = repmat({'wanted'},numnodes(digraph),1);
    bipartite_graph = graph(edge_table, [provided_node_table; wanted_node_table]);
    
    nodes_trader_provided = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    nodes_trader_wanted = nodes_trader_provided + numnodes(digraph);
    weights = zeros(length(nodes_trader_provided),1);
    bipartite_graph = addedge(bipartite_graph, nodes_trader_provided, nodes_trader_wanted, weights);
end

function [equality_matrix, equality_vector] = get_trader_wanted_constraints(bipartite_graph)
    nodes_trader_wanted = find(strcmp(bipartite_graph.Nodes.AgentType, 'trader') & strcmp(bipartite_graph.Nodes.ItemType, 'wanted'));
    equality_matrix = get_degree_matrix(bipartite_graph, nodes_trader_wanted);
    equality_vector = ones(length(nodes_trader_wanted),1);
end

function [inequality_matrix, inequality_vector] = get_remaining_constraints(bipartite_graph)
    nodes_remaining = find(~strcmp(bipartite_graph.Nodes.AgentType, 'trader') | ~strcmp(bipartite_graph.Nodes.ItemType, 'wanted'));
    inequality_matrix = get_degree_matrix(bipartite_graph, nodes_remaining);
    inequality_vector = ones(length(nodes_remaining),1);
end

function [digraph_] = bipartite_graph_to_digraph(bipartite_graph)
    edge_table = bipartite_graph.Edges;
    edge_table.EndNodes(:,2) = edge_table.EndNodes(:,2) - numnodes(bipartite_graph)/2; 
    node_table = bipartite_graph.Nodes(1:numnodes(bipartite_graph)/2,1);
    digraph_ = digraph(edge_table, node_table, 'OmitSelfLoops');
end