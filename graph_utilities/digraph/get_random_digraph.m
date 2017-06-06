function [digraph_] = get_random_digraph(nr_nodes, nr_edges)
    rng('shuffle');
    linear_indices_without_diagonal = randperm(nr_nodes * (nr_nodes-1), nr_edges);
    linear_indices_with_diagonal = linear_indices_without_diagonal + floor((linear_indices_without_diagonal-1)/nr_nodes)+1;
    adjacency_matrix = zeros(nr_nodes, nr_nodes);
    adjacency_matrix(linear_indices_with_diagonal) = 1;
    digraph_ = digraph(adjacency_matrix);
    digraph_.Nodes.AgentType = repmat({'trader'},nr_nodes,1);
end