function [activated_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_paths_solver(digraph_, disallowed_path_length, timeout_find_paths, timeout_solver, optimoptions)
    [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph_, disallowed_path_length, timeout_find_paths);
    
    if timed_out
        activated_digraph = digraph();
        exchange_value = 0;
        core_exec_time = 0;
        return;
    end
    
    [activated_edge_indices, exchange_value, timed_out, core_exec_time] = activate_maximizing_value(ones(numedges(digraph_),1), inequality_matrix, inequality_vector, [], [], timeout_solver, optimoptions);
    
    if timed_out
        activated_digraph = digraph();
        return;
    end
    
    activated_digraph = digraph(digraph_.Edges(activated_edge_indices,:), digraph_.Nodes);
end

function [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph, disallowed_path_length, timeout_find_paths)
    [inequality_matrix_1, inequality_vector_1, timed_out] = get_disallowed_paths_constraints(digraph, disallowed_path_length, timeout_find_paths);
    
    if timed_out    
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    
    [inequality_matrix_2, inequality_vector_2] = get_unrestricted_edge_digraph_constraints(digraph);
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2];
    inequality_vector = [inequality_vector_1; inequality_vector_2];
end

function [inequality_matrix, inequality_vector, timed_out] = get_disallowed_paths_constraints(digraph, disallowed_path_length, timeout)
    [paths, timed_out] = find_paths(digraph, (1:numnodes(digraph))', disallowed_path_length, disallowed_path_length, timeout);
    
    inequality_matrix = zeros(length(paths), numedges(digraph));
    for index_path = 1:length(paths)
        path = paths{index_path};
        edges_in_path = findedge(digraph, path(1:end-1),path(2:end));
        inequality_matrix(index_path,edges_in_path) = 1;
    end
    
    inequality_vector = (disallowed_path_length-1) * ones(length(paths),1);
end