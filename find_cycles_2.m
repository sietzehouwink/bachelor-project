function [cycles] = find_cycles_2(graph, starting_nodes, min_length, max_length)
    cycles = {};
    visited = false(1, numnodes(graph));
    for starting_node = starting_nodes'
        
        % TODO: make graph smaller.
        cycles = [cycles; find_cycles_DFS(graph, starting_node, visited, min_length, max_length, starting_node)];
        adj = adjacency(graph);
        adj(starting_node,:) = 0;
        adj(:,starting_node) = 0;
        graph = digraph(adj);
    end
end

function [cycles] = find_cycles_DFS(graph, starting_node, visited, min_length, max_length, real_start)
    cycles = {};
    if max_length == 0
        return;
    end
    visited(starting_node) = true;
    for successor = successors(graph, starting_node)'
        if ~visited(successor)
            for path = find_cycles_DFS(graph, successor, visited, max(min_length-1,1), max_length-1, real_start)'
                cycles{end+1,1} = [starting_node; path{:}];
            end
        elseif successor == real_start
            if min_length == 1
                cycles{end+1,1} = starting_node;
            end
        end
    end 
end

