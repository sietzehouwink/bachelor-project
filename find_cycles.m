function [cycles, timed_out] = find_cycles(graph, from_nodes, min_edges, max_edges, timeout)
    tic;
    cycles_per_node = cell(length(from_nodes),1);
    for index_from_node = 1:length(from_nodes)
        from_node = from_nodes(index_from_node);
        cycles_per_node{from_node} = find_cycles_DFS(graph, from_node, false(numnodes(graph),1), min_edges, max_edges, from_node);
        adjacency_matrix = adjacency(graph);
        adjacency_matrix(from_node,:) = 0;
        adjacency_matrix(:,from_node) = 0;
        graph = digraph(adjacency_matrix);
        if toc > timeout
            timed_out = true;
            cycles = {};
            return;
        end
    end
    cycles = vertcat(cycles_per_node{:});
    timed_out = false;
end

function [cycles] = find_cycles_DFS(graph, from_node, visited, min_edges, max_edges, first_node_cycle)
    if from_node == first_node_cycle && min_edges <= 0
        cycles = {[]};
        return;
    end
    if visited(from_node) || max_edges == 0
        cycles = {};
        return;
    end
    node_successors = successors(graph, from_node);
    if isempty(node_successors)
        cycles = {};
        return;
    end
    visited(from_node) = true;
    recursive_paths_per_node = arrayfun(@(node_successor) find_cycles_DFS(graph, node_successor, visited, min_edges-1, max_edges-1, first_node_cycle), node_successors, 'UniformOutput', false);
    recursive_paths = vertcat(recursive_paths_per_node{:});
    cycles = cellfun(@(recursive_path) [from_node; recursive_path], recursive_paths, 'UniformOutput', false);
end