function [paths] = find_paths(graph, starting_nodes, min_length, max_length)
    paths = {};
    visited = false(1, numnodes(graph));
    for starting_node = starting_nodes'
        paths = [paths; find_paths_DFS(graph, starting_node, visited, min_length, max_length)];
    end
end

function [paths] = find_paths_DFS(graph, starting_node, visited, min_length, max_length)
    paths = {};
    if visited(starting_node)
        return;
    end
    if min_length == 1
        paths = {starting_node};
    end
    if max_length == 1
        return;
    end

    visited(starting_node) = true;
    for successor = successors(graph, starting_node)'
        recursive_paths = find_paths_DFS(graph, successor, visited, max(min_length-1,1), max_length-1);
        found_paths = cellfun(@(recursive_path) [starting_node; recursive_path], recursive_paths, 'UniformOutput', false);
        paths = [paths; found_paths];
    end
end

