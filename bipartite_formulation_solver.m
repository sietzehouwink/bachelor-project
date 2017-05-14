function [activated_digraph, exchange_value] = bipartite_formulation_solver(digraph, timeout)
    bipartite_graph = digraph_to_bipartite_graph(digraph);
    weights = bipartite_graph.Edges.Weight;
    [equality_matrix, equality_vector] = get_outdegree_equality_constraints(bipartite_graph);
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(weights, [], [], equality_matrix, equality_vector, timeout);
    activated_bipartite_graph = graph(bipartite_graph.Edges(activated_edge_indices,:), bipartite_graph.Nodes);
    activated_digraph = bipartite_graph_to_digraph(activated_bipartite_graph);
end

function [bipartite_graph] = digraph_to_bipartite_graph(digraph)

    % Edges of weight 0.
    s = 1:numnodes(digraph);
    t = numnodes(digraph) + s;
    w = zeros(1,numnodes(digraph));
    bipartite_graph = graph(s,t,w);
    
    % Other edges.
    s = digraph.Edges.EndNodes(:,1);
    t = numnodes(digraph) + digraph.Edges.EndNodes(:,2);
    w = ones(numedges(digraph),1);  
    bipartite_graph = addedge(bipartite_graph,s,t,w);
    
end

function [equality_matrix, equality_vector] = get_outdegree_equality_constraints(bipartite_graph)
    equality_matrix = abs(incidence(bipartite_graph));
    equality_vector = ones(numnodes(bipartite_graph),1);
end

function [digraph_] = bipartite_graph_to_digraph(bipartite_graph)
    adj = adjacency(bipartite_graph);
    n = numnodes(bipartite_graph)/2;
    digraph_ = digraph(adj(1:n,n+1:end), 'OmitSelfLoops');

end