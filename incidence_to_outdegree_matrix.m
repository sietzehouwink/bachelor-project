function [outdegree_matrix] = incidence_to_outdegree_matrix(incidence_matrix)
    [nr_nodes, nr_edges] = size(incidence_matrix);
    outdegree_matrix = sparse(nr_nodes, nr_edges);
    outdegree_matrix(incidence_matrix == -1) = 1;
end