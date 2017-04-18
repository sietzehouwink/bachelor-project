function [optimal_cycle_indices, max_exchange_weight] = clear_market_ILP_cycle_formulation(nr_vertices, edges)
    cycles = graph_to_cycles(nr_vertices, edges);
    A = cycles_to_vertex_in_cycle_count(nr_vertices, cycles);
    
    nr_cycles = size(cycles, 1);
    b = ones(nr_vertices, 1);
    
    cycle_lengths = zeros(nr_cycles, 1);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        cycle_lengths(cycle_index) = size(cycle, 2);
    end
    
    f = cycle_lengths .* ones(nr_cycles, 1);
    intcon = ones(nr_cycles, 1);
    
    lb = zeros(nr_cycles, 1);
    ub = ones(nr_cycles, 1);
    
    options = optimoptions('intlinprog', 'Display', 'none');
    [optimal_cycle_indices,fval,~,~] = intlinprog(-f,intcon,A,b,[],[],lb,ub,options);
    max_exchange_weight = -fval;
    
end

function [cycles] = graph_to_cycles(nr_vertices, edges)
    cycles = cell(4,1);
    cycles{1} = [1,2];
    cycles{2} = [2,3];
    cycles{3} = [3,4];
    cycles{4} = [1,2,3,4,5];
end

function [A] = cycles_to_vertex_in_cycle_count(nr_vertices, cycles)
    nr_cycles = size(cycles, 1);
    A = zeros(nr_vertices, nr_cycles);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        nr_vertices_in_cycle = size(cycle, 2);
        for vertex_index = 1:nr_vertices_in_cycle
            vertex = cycle(vertex_index);
            A(vertex, cycle_index) = 1;
        end
    end
end