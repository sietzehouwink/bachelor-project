function [digraph_] = to_digraph(bipartite_graph)
    digraph_ = digraph(bipartite_graph.Edges.EndNodes(:,1), bipartite_graph.Edges.EndNodes(:,2) - numnodes(bipartite_graph)/2, 1, numnodes(bipartite_graph)/2, 'OmitSelfLoops');
end