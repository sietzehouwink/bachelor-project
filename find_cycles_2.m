function [cycles] = find_cycles_2(graph, from_nodes, min_length, max_length)
    cycles_per_node = cell(numnodes(graph),1);
    for node = from_nodes'
        cycles_per_node{node} = find_cycles_DFS(graph, node, false(numnodes(graph),1), min_length, max_length, node);
        adjacency_matrix = adjacency(graph);
        adjacency_matrix(node,:) = 0;
        adjacency_matrix(:,node) = 0;
        graph = digraph(adjacency_matrix);
    end
    cycles = vertcat(cycles_per_node{:});
end

function [cycles] = find_cycles_DFS(graph, from_node, visited, min_nr_nodes, max_nr_nodes, first_node_cycle)
    if from_node == first_node_cycle && min_nr_nodes <= 0
        cycles = {[]};
        return;
    end
    if visited(from_node) || max_nr_nodes == 0
        cycles = {};
        return;
    end
    
    node_successors = successors(graph, from_node);
    if isempty(node_successors)
        cycles = {};
        return;
    end
    visited(from_node) = true;
    recursive_paths_per_node = arrayfun(@(node_successor) find_cycles_DFS(graph, node_successor, visited, min_nr_nodes-1, max_nr_nodes-1, first_node_cycle), node_successors, 'UniformOutput', false);
    recursive_paths = vertcat(recursive_paths_per_node{:});
    cycles = cellfun(@(recursive_path) [from_node; recursive_path], recursive_paths, 'UniformOutput', false);
end