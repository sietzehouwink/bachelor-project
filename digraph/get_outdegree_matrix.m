function [outdegree_matrix] = get_outdegree_matrix(digraph, nodes)
    incidence_matrix = incidence(digraph);
    outdegree_matrix = sparse(length(nodes), numedges(digraph));
    outdegree_matrix(incidence_matrix(nodes,:) == -1) = 1;
end