function [activated_graph, exchange_value, timed_out] = cycle_formulation_solver(graph, timeout)
    timer = tic;
    
    [cycles, timed_out] = find_cycles(graph, timeout);
    if timed_out
        activated_graph = digraph();
        exchange_value = 0;
        return;
    end
    
    cycle_weight_vector = cellfun(@length, cycles);
    [inequality_matrix, inequality_vector] = get_node_in_cycle_containment_constraints(numnodes(graph), cycles);
    
    [activated_cycle_indices, exchange_value, timed_out] = activate_maximizing_value(cycle_weight_vector, inequality_matrix, inequality_vector, [], [], max(0,timeout-toc(timer)));
    if timed_out
        activated_graph = digraph();
        exchange_value = 0;
        return;
    end
    
    activated_graph = cycles_to_graph(numnodes(graph), cycles(activated_cycle_indices));
end

function [inequality_matrix, inequality_vector] = get_node_in_cycle_containment_constraints(nr_nodes, cycles)
    inequality_matrix = cycles_to_node_containment_count_matrix(nr_nodes, cycles);
    inequality_vector = ones(nr_nodes,1);
end

function [node_containment_count_matrix] = cycles_to_node_containment_count_matrix(nr_nodes, cycles)
    node_containment_count_matrix = zeros(nr_nodes, length(cycles));
    for cycle_index = 1:length(cycles)
        node_containment_count_matrix(cycles{cycle_index}, cycle_index) = 1;
    end
end
