function [paths] = find_paths(graph, from_nodes, min_nr_nodes, max_nr_nodes)
    paths_per_node = arrayfun(@(starting_node) find_paths_DFS(graph, starting_node, false(1, numnodes(graph)), min_nr_nodes, max_nr_nodes), from_nodes, 'UniformOutput', false);
    paths = vertcat(paths_per_node{:});
end

function [paths] = find_paths_DFS(graph, from_node, visited, min_nr_nodes, max_nr_nodes)
    paths = {};
    if visited(from_node)
        return;
    end
    if min_nr_nodes <= 1
        paths = {from_node};
    end
    if max_nr_nodes == 1
        return;
    end
    visited(from_node) = true;
    node_successors = successors(graph, from_node);
    recursive_paths_per_node = arrayfun(@(node_successor) find_paths_DFS(graph, node_successor, visited, min_nr_nodes-1, max_nr_nodes-1), node_successors, 'UniformOutput', false);
    recursive_paths = vertcat(recursive_paths_per_node{:});
    paths = [paths; cellfun(@(recursive_path) [from_node; recursive_path], recursive_paths, 'UniformOutput', false)];
end

