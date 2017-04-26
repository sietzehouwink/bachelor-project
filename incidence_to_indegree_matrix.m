function [indegree_matrix] = incidence_to_indegree_matrix(incidence_matrix)
    [nr_nodes, nr_edges] = size(incidence_matrix);
    indegree_matrix = sparse(nr_nodes, nr_edges);
    indegree_matrix(incidence_matrix == 1) = 1;
end