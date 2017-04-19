function [optimal_cycle_indices, max_exchange_weight] = clear_market_ILP_cycle_formulation(nr_vertices, edges)
    cycles = get_cycles(nr_vertices, edges);
    
    f = get_cycle_weights(cycles);
    A = get_vertex_in_cycle_count_calculating_matrix(nr_vertices, cycles);
    b = get_max_vertex_in_cycle_count(nr_vertices);
    
    [optimal_cycle_indices, max_exchange_weight] = maximize_ILP(f, A, b);
    
    %optimal_edge_indices = get_optimal_edge_indices(optimal_cycle_indices, cycles);
    
end

function [cycles] = get_cycles(nr_vertices, edges)
    cycles = cell(4,1);
    cycles{1} = [1,2];
    cycles{2} = [2,3];
    cycles{3} = [3,4];
    cycles{4} = [1,2,3,4,5];
end

function [vertex_in_cycle_count_calculating_matrix] = get_vertex_in_cycle_count_calculating_matrix(nr_vertices, cycles)
    nr_cycles = size(cycles, 1);
    vertex_in_cycle_count_calculating_matrix = zeros(nr_vertices, nr_cycles);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        nr_vertices_in_cycle = size(cycle, 2);
        for vertex_index = 1:nr_vertices_in_cycle
            vertex = cycle(vertex_index);
            vertex_in_cycle_count_calculating_matrix(vertex, cycle_index) = 1;
        end
    end
end

function [max_vertex_in_cycle_count] = get_max_vertex_in_cycle_count(nr_vertices)
    max_vertex_in_cycle_count = ones(nr_vertices, 1);
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
        cycle_lengths(cycle_index) = size(cycle,2);
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

% function [optimal_edge_indices] = get_optimal_edge_indices(optimal_cycle_indices, cycles)
%     optimal_edge_indices = cycles;
% end