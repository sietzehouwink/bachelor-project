function [node_containment_count_matrix] = get_node_containment_count_matrix(cycles_chains, nr_nodes)    
    nr_nodes_cycles_chains = zeros(length(cycles_chains),1);
    for index_cycle_chain = 1:length(cycles_chains)
        cycle_chain = cycles_chains{index_cycle_chain};   
        nr_nodes_cycles_chains(index_cycle_chain) = length(cycle_chain);
    end
    indices_nodes = vertcat(cycles_chains{:});
    indices_cycles_chains = repelem(1:length(cycles_chains), nr_nodes_cycles_chains);
    node_containment_count_matrix = double(logical(sparse(indices_nodes, indices_cycles_chains, 1, nr_nodes, length(cycles_chains))));
end