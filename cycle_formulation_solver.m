function [activated_graph, max_exchange_value] = cycle_formulation_solver(graph)
    cycles = get_cycles(graph);
    
    weight_vector = get_cycle_lengths(cycles);
    inequality_matrix = to_vertex_containment_count_matrix(graph, cycles);
    inequality_vector = get_max_vertex_containment_count_vector(graph.nr_vertices);
    
    [activated_cycle_indices, max_exchange_value] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, [], []);
    
    activated_cycles = cycles(activated_cycle_indices);
    edges = to_edges(activated_cycles);
    activated_graph = create_graph(graph.nr_vertices, edges);
end

function [cycle_lengths] = get_cycle_lengths(cycles)
    nr_cycles = size(cycles,1);
    cycle_lengths = zeros(nr_cycles,1);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        cycle_lengths(cycle_index) = size(cycle,1);
    end
end

function [vertex_containment_count_matrix] = to_vertex_containment_count_matrix(graph, cycles)
    nr_cycles = size(cycles,1);
    vertex_containment_count_matrix = zeros(graph.nr_vertices, nr_cycles);
    for cycle_index = 1:nr_cycles
        for vertex = cycles{cycle_index}
            vertex_containment_count_matrix(vertex, cycle_index) = 1;
        end
    end
end

function [max_vertex_in_cycle_count] = get_max_vertex_containment_count_vector(nr_vertices)
    max_vertex_in_cycle_count = ones(nr_vertices,1);
end

function [edges] = to_edges(cycles)
    edges = cell(0);
    for cycle_index = 1:size(cycles,1)
        cycle = cycles{cycle_index};
        for vertex = 1:size(cycle,1)-1
            edges{end+1,1} = [cycle(vertex); cycle(vertex+1)];
        end
        edges{end+1,1} = [cycle(end,1); cycle(1,1)];
    end
end