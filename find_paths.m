function [paths] = find_paths(graph, starting_nodes, min_length, max_length)
    paths = {};
    visited = false(1, numnodes(graph));
    for starting_node = starting_nodes'
        paths = [paths; find_paths_DFS(graph, starting_node, visited, min_length, max_length)];
    end
end

function [paths] = find_paths_DFS(graph, starting_node, visited, min_length, max_length)
    paths = {};
    if max_length == 0
        return;
    end
    visited(starting_node) = true;
    for successor = successors(graph, starting_node)'
        if ~visited(successor)
            for path = find_paths_DFS(graph, successor, visited, max(min_length-1,1), max_length-1)'
                paths{end+1,1} = [starting_node; path{:}];
            end
        end
    end
    if min_length == 1
        paths{end+1,1} = starting_node;
    end
end

