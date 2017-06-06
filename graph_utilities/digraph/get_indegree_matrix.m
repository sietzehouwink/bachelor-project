function [indegree_matrix] = get_indegree_matrix(digraph, nodes)
    incidence_matrix = incidence(digraph);
    indegree_matrix = zeros(length(nodes), numedges(digraph));
    indegree_matrix(incidence_matrix(nodes,:) == 1) = 1;
end