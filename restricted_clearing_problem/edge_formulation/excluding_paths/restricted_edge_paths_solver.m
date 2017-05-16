function [activated_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_paths_solver(digraph_, max_edges_path, timeout_find_paths, timeout_solver)
    [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph_, max_edges_path, timeout_find_paths);
    if timed_out
        activated_digraph = digraph();
        exchange_value = 0;
        core_exec_time = 0;
        return;
    end
    timer = tic;
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(digraph_.Edges.Weight, inequality_matrix, inequality_vector, [], [], timeout_solver);
    core_exec_time = toc(timer);
    if timed_out
        activated_digraph = digraph();
        core_exec_time = 0;
        return;
    end
    activated_digraph = digraph(digraph_.Edges(activated_edge_indices,:), digraph_.Nodes);
end

function [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph, max_edges_path, timeout_find_paths)
    [inequality_matrix_1, inequality_vector_1, timed_out] = get_excluded_paths_constraints(digraph, max_edges_path, timeout_find_paths);
    if timed_out    
        inequality_matrix = [];
        inequality_vector = [];
        return;
    end
    [inequality_matrix_2, inequality_vector_2] = get_unrestricted_edge_constraints(digraph);
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2];
    inequality_vector = [inequality_vector_1; inequality_vector_2];
end

function [inequality_matrix, inequality_vector, timed_out] = get_excluded_paths_constraints(digraph, max_edges_path, timeout)
    [paths, timed_out] = find_paths(digraph, (1:numnodes(digraph))', max_edges_path+1, max_edges_path+1, timeout);
    inequality_matrix = zeros(length(paths), numedges(digraph));
    for index_path = 1:length(paths)
        path = paths{index_path};
        edges_in_path = findedge(digraph, path(1:end-1),path(2:end));
        inequality_matrix(index_path,edges_in_path) = 1;
    end
    inequality_vector = max_edges_path * ones(length(paths),1);
end