function [optimal_edge_indices, max_exchange_weight] = clear_market_ILP_cycle_formulation(nr_vertices, edges)
    cycles = get_cycles(nr_vertices, edges);
    
    f = get_cycle_weights(cycles);
    A = get_vertex_containment_count_calculating_matrix(nr_vertices, cycles, edges);
    b = get_max_vertex_containment_count(nr_vertices);
    
    [cycle_values, max_exchange_weight] = maximize_ILP(f, A, b);
    
    nr_edges = size(edges,1);
    
    optimal_edge_indices = to_edge_indices(cycle_values, cycles, nr_edges);
end

function [cycles] = get_cycles(nr_vertices, edges)
    cycles = cell(4,1);
    cycles{1} = [1;2];
    cycles{2} = [3;4];
    cycles{3} = [5;6];
    cycles{4} = [1;3;5;7;8];
end

function [vertex_containment_count_calculating_matrix] = get_vertex_containment_count_calculating_matrix(nr_vertices, cycles, edges)
    nr_cycles = size(cycles,1);
    
    vertex_containment_count_calculating_matrix = zeros(nr_vertices, nr_cycles);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        nr_edges = size(cycle, 1);
        
        for edge_index = 1:nr_edges
            edge = cycle(edge_index);
            outgoing_vertex = edges(edge, 1);
            
            vertex_containment_count_calculating_matrix(outgoing_vertex, cycle_index) = 1;
        end
        
    end
end

function [max_vertex_in_cycle_count] = get_max_vertex_containment_count(nr_vertices)
    max_vertex_in_cycle_count = ones(nr_vertices,1);
end

function [cycle_weights] = get_cycle_weights(cycles)
    nr_cycles = size(cycles,1);
    cycle_lengths = get_cycle_lengths(cycles);
    
    cycle_weights = cycle_lengths .* ones(nr_cycles, 1);
end

function [cycle_lengths] = get_cycle_lengths(cycles)
    nr_cycles = size(cycles,1);
    
    cycle_lengths = zeros(nr_cycles,1);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        cycle_lengths(cycle_index) = size(cycle,1);
    end
end

function [variable_values, maximum] = maximize_ILP(f, A, b)
    nr_vars = size(A,2);
    
    intcon = ones(nr_vars,1);
    lb = zeros(nr_vars,1);
    ub = ones(nr_vars,1);
    options = optimoptions('intlinprog', 'Display', 'none');
    
    [variable_values, minimum, ~, ~] = intlinprog(-f, intcon, A, b, [], [], lb, ub, options);
    
    maximum = -minimum;
end

function [activated_edge_indices] = to_edge_indices(bitset_activated_cycles, cycles, nr_edges)   
    activated_cycles = cycles(logical(bitset_activated_cycles));
    nr_activated_cycles = size(activated_cycles,1);
    
    bitset_activated_edges = zeros(nr_edges,1);
    for activated_cycle_index = 1:nr_activated_cycles
        activated_edges = activated_cycles{activated_cycle_index};
        nr_activated_edges = size(activated_edges,1);
        
        for activated_edge_index = 1:nr_activated_edges
            edge_index = activated_edges(activated_edge_index);
            bitset_activated_edges(edge_index) = 1;
        end
    end
    
    activated_edge_indices = find(bitset_activated_edges);
end