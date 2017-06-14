function [activated_digraph, exchange_value, timed_out, core_exec_time] = restricted_edge_paths_solver(digraph_, disallowed_path_length, timeout_find_paths, timeout_solver, optimoptions)
    [inequality_matrix, inequality_vector, timed_out] = get_inequality_constraints(digraph_, disallowed_path_length, timeout_find_paths);
    
    if timed_out
        activated_digraph = digraph();
        exchange_value = 0;
        core_exec_time = 0;
        return;
    end
    
    [setting_edges, exchange_value, timed_out, core_exec_time] = BILP_solver(ones(numedges(digraph_),1), inequality_matrix, inequality_vector, [], [], timeout_solver, optimoptions);
    
    if timed_out
        activated_digraph = digraph();
        return;
    end
    
    activated_digraph = digraph(digraph_.Edges(logical(setting_edges),:), digraph_.Nodes);
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
    
    nr_edges_paths = zeros(length(paths),1);
    for index_path = 1:length(paths)
        path = paths{index_path};   
        nr_edges_paths(index_path) = length(path)-1;
    end
    sum_nr_edges_paths = sum(nr_edges_paths);
    
    indices_start = zeros(sum_nr_edges_paths,1);
    indices_end = zeros(sum_nr_edges_paths,1);
    
    index_indices = 1;
    for index_path = 1:length(paths)
        path = paths{index_path};   
        indices_start(index_indices:index_indices+length(path)-2) = path(1:end-1);
        indices_end(index_indices:index_indices+length(path)-2) = path(2:end);
        index_indices = index_indices + length(path)-1;
    end

    indices_paths = repelem(1:length(paths), nr_edges_paths);
    indices_edges = findedge(digraph, indices_start, indices_end);
    
    inequality_matrix = sparse(indices_paths, indices_edges, 1, length(paths), numedges(digraph));    
    inequality_vector = (disallowed_path_length-1) * ones(length(paths),1);
end