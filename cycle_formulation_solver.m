function [activated_graph, max_exchange_value] = cycle_formulation_solver(graph)
    cycles = get_cycles(graph);
    
    weight_vector = get_cycle_lengths(cycles);
    inequality_matrix = to_vertex_containment_count_matrix(graph, cycles);
    inequality_vector = get_max_vertex_containment_count_vector(graph.nr_vertices);
    
    [activated_cycle_indices, max_exchange_value] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, [], []);
    
    activated_graph = get_subgraph(graph.nr_vertices, cycles, activated_cycle_indices);
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

function [subgraph] = get_subgraph(nr_vertices, cycles, activated_cycle_indices)
    activated_cycles = cycles(activated_cycle_indices);
    nr_edges = 0;
    adj_list = cell(nr_vertices,1);
    for cycle_index = 1:size(activated_cycles,1)
        cycle = activated_cycles{cycle_index};
        nr_vertices = size(cycle,1);
        nr_edges = nr_edges + nr_vertices;
        for vertex = 1:nr_vertices-1
            adj_list{cycle(vertex,1)}(end+1,1) = cycle(vertex+1,1); 
        end
        adj_list{cycle(end,1)}(end+1,1) = cycle(1,1); 
    end
    subgraph = struct('nr_vertices', {nr_vertices}, 'nr_edges', {nr_edges}, 'adj_list', {adj_list});
end
