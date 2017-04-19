function [subgraph, max_exchange_value] = clear_market_ILP_cycle_formulation(graph)
    cycles = get_cycles(graph);
    
    f = get_cycle_weights(cycles);
    A = get_vertex_containment_count_calculating_matrix(graph, cycles);
    b = get_max_vertex_containment_count(graph.nr_vertices);
    
    [activated_cycle_indices, max_exchange_value] = activate_maximizing_value(f, A, b, [], []);
    
    adj_list = cell(graph.nr_vertices,1);
    nr_edges = 0;
    for cycle_index = activated_cycle_indices
        cycle = cycles{cycle_index};
        nr_edges = nr_edges + size(cycle,1);
        for tail_vertex_index = 1:size(cycle,1)-1
            tail_vertex = cycle(tail_vertex_index);
            head_vertex = cycle(tail_vertex_index+1);
            adj_list{tail_vertex}(end+1,1) = head_vertex;
        end
        tail_vertex = cycle(end,1);
        head_vertex = cycle(1,1);
        adj_list{tail_vertex}(end+1,1) = head_vertex;
    end
    
    subgraph = struct('nr_vertices', {graph.nr_vertices}, 'nr_edges', {nr_edges}, 'adj_list', {adj_list});
    
end

function [vertex_containment_count_calculating_matrix] = get_vertex_containment_count_calculating_matrix(graph, cycles)
    nr_cycles = size(cycles,1);
    
    vertex_containment_count_calculating_matrix = zeros(graph.nr_vertices, nr_cycles);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        nr_edges = size(cycle, 1);
        for edge_index = 1:nr_edges
            tail_vertex = cycle(edge_index);
            vertex_containment_count_calculating_matrix(tail_vertex, cycle_index) = 1;
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

function [activated_edge_indices] = to_edge_indices(bitset_activated_cycles, cycles, nr_edges)   
    activated_cycles = cycles(bitset_activated_cycles);
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