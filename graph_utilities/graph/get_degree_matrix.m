function [degree_matrix] = get_degree_matrix(bipartite_graph, nodes)
    incidence_matrix = incidence(bipartite_graph);
    degree_matrix = abs(incidence_matrix(nodes,:));
end

