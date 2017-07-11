function [lengths] = structures_to_nr_edges(structures)
    nr_structures = length(structures);
    lengths = zeros(nr_structures, 1);
    for idx = 1:nr_structures
        structure = structures{idx};   
        lengths(idx) = length(structure) - 1;
    end
end

