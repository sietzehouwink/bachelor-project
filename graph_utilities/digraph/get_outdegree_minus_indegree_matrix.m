function [outdegree_minus_indegree_matrix] = get_outdegree_minus_indegree_matrix(digraph, nodes)
    incidence_matrix = incidence(digraph);
    outdegree_minus_indegree_matrix = -incidence_matrix(nodes,:);
end