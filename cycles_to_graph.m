function [graph] = cycles_to_graph(nr_nodes, cycles)
    adjacency_matrix = sparse(nr_nodes, nr_nodes);
    for cycle = cycles'
        node_vector = cycle{:};
        adjacency_matrix(sub2ind(size(adjacency_matrix), node_vector(1:end), [node_vector(2:end); node_vector(1)])) = 1;
    end
    graph = digraph(adjacency_matrix);
end