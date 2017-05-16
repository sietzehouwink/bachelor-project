function [paths, timed_out] = find_paths(digraph, from_nodes, min_edges, max_edges, timeout)
    [min_edges, max_edges] = tighten_bounds(digraph, min_edges, max_edges);
    if min_edges > max_edges
        paths = {};
        timed_out = false;
        return;
    end
    timer = tic;
    paths_per_node = cell(length(from_nodes),1);
    for index_from_node = 1:length(from_nodes)
        paths_per_node{index_from_node} = find_paths_DFS(digraph, from_nodes(index_from_node), false(numnodes(digraph),1), min_edges, max_edges);
        if toc(timer) > timeout
            paths = {};
            timed_out = true;
            return;
        end
    end
    paths = vertcat(paths_per_node{:});
    if isempty(paths)
        paths = {};
    end
    timed_out = false;
end

function [min_edges, max_edges] = tighten_bounds(digraph, min_edges, max_edges)
    min_edges = max(1, min_edges);
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    max_edges = min(length(nodes_trader)+1, max_edges);
end

function [paths] = find_paths_DFS(digraph, from_node, visited, min_edges, max_edges)
    paths = {};
    if visited(from_node)
        return;
    end
    if min_edges <= 0
        paths = {from_node};
    end
    if max_edges == 0
        return;
    end
    visited(from_node) = true;
    node_successors = successors(digraph, from_node);
    recursive_paths_per_node = arrayfun(@(node_successor) find_paths_DFS(digraph, node_successor, visited, min_edges-1, max_edges-1), node_successors, 'UniformOutput', false);
    recursive_paths = vertcat(recursive_paths_per_node{:});
    if isempty(recursive_paths)
        return;
    end
    paths = [paths; cellfun(@(recursive_path) [from_node; recursive_path], recursive_paths, 'UniformOutput', false)];
end

