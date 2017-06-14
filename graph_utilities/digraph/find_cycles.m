function [cycles, timed_out] = find_cycles(digraph_, start_nodes, min_edges, max_edges, timeout)
    [min_edges, max_edges] = tighten_bounds(digraph_, min_edges, max_edges);  
    if min_edges > max_edges
        cycles = {};
        timed_out = false;
        return;
    end
    
    [cycles, timed_out] = get_cycles(digraph_, start_nodes, min_edges, max_edges, timeout);
end

function [min_edges, max_edges] = tighten_bounds(digraph, min_edges, max_edges)
    min_edges = max(2, min_edges);
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    max_edges = min(length(nodes_trader), max_edges);
end

function [cycles, timed_out] = get_cycles(digraph_, start_nodes, min_edges, max_edges, timeout)
    timer = tic;
    adjacency_matrix = full(adjacency(digraph_));
    cycles = {};
    for index_start_node = 1:length(start_nodes)
        start_node = start_nodes(index_start_node);
        cycles{end+1} = get_cycles_from(start_node, adjacency_matrix, min_edges, max_edges, timeout - toc(timer));
        adjacency_matrix(start_node,:) = 0;
        adjacency_matrix(:,start_node) = 0;
        if toc(timer) > timeout
            cycles = {};
            timed_out = true;
            return;
        end
    end
    cycles = vertcat(cycles{:});
    timed_out = false;
end

function [cycles] = get_cycles_from(start_node, adjacency_matrix, min_edges, max_edges, timeout)
    timer = tic;
    cycles = {};
    paths = (start_node);
    for edges = 1:max_edges-1
        paths = branch(paths, adjacency_matrix);
        if isempty(paths)
            break;
        end
        if edges+1 >= min_edges
            cycles{end+1} = close_paths(paths, adjacency_matrix);
        end  
        if toc(timer) > timeout
            cycles = {};
            return;
        end
    end
    cycles = vertcat(cycles{:});
end

function [branched] = branch(paths, adjacency_matrix)
    branched = {};
    for index_path = 1:size(paths,1)
        path = paths(index_path,:);
        successors_path = find(adjacency_matrix(path(end),:));
        sort(path);
        branch_nodes = successors_path(~ismember_sorted(successors_path, sort(path)));
        if isempty(branch_nodes)
            continue;
        end
        branched{end+1} = [repmat(path, length(branch_nodes), 1) branch_nodes'];
    end
    branched = vertcat(branched{:});
end

function [result] = ismember_sorted(a,b)
    result = false(length(a),1);
    i = 1;
    j = 1;
    while i <= length(a) && j <= length(b)
        if a(i) == b(j)
            result(i) = true;
            i = i + 1;
        elseif a(i) > b(j)
            j = j + 1;
        else
            i = i + 1;
        end
    end
end

function [cycles] = close_paths(paths, adjacency_matrix)
    start_node = paths(1,1);
    last_node_paths = paths(:,end);
    predecessors_start_node = find(adjacency_matrix(:,start_node));
    indices_closing_paths = ismember(last_node_paths, predecessors_start_node);
    if isempty(indices_closing_paths)
        cycles = {};
        return;
    end
    closing_paths = paths(indices_closing_paths,:);
    matrix_cycles = [closing_paths repelem(start_node, size(closing_paths,1), 1)];
    cycles = matrix_to_cells(matrix_cycles);
end

function [cells] = matrix_to_cells(matrix)
    cells = cell(size(matrix,1), 1);
    for row = 1:size(matrix,1)
        cells{row} = matrix(row,:)';
    end
end