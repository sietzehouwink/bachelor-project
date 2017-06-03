function [node_containment_count_matrix] = get_node_containment_count_matrix(cycles_chains, nr_nodes)
    node_containment_count_matrix = zeros(nr_nodes, length(cycles_chains));
    for cycle_index = 1:length(cycles_chains)
        node_containment_count_matrix(cycles_chains{cycle_index}, cycle_index) = 1;
    end
end