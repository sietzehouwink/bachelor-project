function [start_nodes, end_nodes] = structures_to_edges(structures)
    nr_edges_structures = structures_to_nr_edges(structures);
    sum_nr_edges_structures = sum(nr_edges_structures);
    linear_indices = cumsum([1; nr_edges_structures]);
    start_nodes = zeros(sum_nr_edges_structures, 1);
    end_nodes = zeros(sum_nr_edges_structures, 1);
    for idx = 1:length(structures)
        structure = structures{idx};
        start_nodes(linear_indices(idx):linear_indices(idx+1)-1) = structure(1:end-1);
        end_nodes(linear_indices(idx):linear_indices(idx+1)-1) = structure(2:end);
    end
end

