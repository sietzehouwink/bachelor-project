function [paths, timed_out] = find_paths(digraph_, start_nodes, min_edges, max_edges, timeout)
    [min_edges, max_edges] = tighten_bounds(digraph_, min_edges, max_edges);  
    if min_edges > max_edges
        paths = {};
        timed_out = false;
        return;
    end
    
    [paths, timed_out] = get_paths(digraph_, start_nodes, min_edges, max_edges, timeout);
end

function [min_edges, max_edges] = tighten_bounds(digraph, min_edges, max_edges)
    min_edges = max(1, min_edges);
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    max_edges = min(length(nodes_trader)+1, max_edges);
end

function [paths, timed_out] = get_paths(digraph_, start_nodes, min_edges, max_edges, timeout)
    timer = tic;
    adjacency_matrix = full(adjacency(digraph_));
    paths = {};
    for start_node = start_nodes'
        paths{end+1} = get_paths_from(start_node, adjacency_matrix, min_edges, max_edges);
        if toc(timer) > timeout
            paths = {};
            timed_out = true;
            return;
        end
    end
    paths = vertcat(paths{:});
    timed_out = false;
end

function [paths] = get_paths_from(start_node, adjacency_matrix, min_edges, max_edges)
    paths = {};
    paths_matrix = (start_node);
    for edges = 1:max_edges
        paths_matrix = branch(paths_matrix, adjacency_matrix);
        if isempty(paths_matrix)
            break;
        end
        if edges >= min_edges
            paths{end+1} = matrix_to_cells(paths_matrix);
        end     
    end
    paths = vertcat(paths{:});
end

function [branched] = branch(paths, adjacency_matrix)
    branched = {};
    for index_path = 1:size(paths,1)
        path = paths(index_path,:);
        successors_path = find(adjacency_matrix(path(end),:));
        branch_nodes = successors_path(~ismember(successors_path, path));
        if isempty(branch_nodes)
            continue;
        end
        branched{end+1} = [repmat(path, length(branch_nodes), 1) branch_nodes'];
    end
    branched = vertcat(branched{:});
end

function [cells] = matrix_to_cells(matrix)
    cells = cell(size(matrix,1), 1);
    for row = 1:size(matrix,1)
        cells{row} = matrix(row,:)';
    end
end
