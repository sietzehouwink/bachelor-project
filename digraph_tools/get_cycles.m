function [cycles, timed_out] = get_cycles(market_digraph, source_nodes, min_nr_edges, max_nr_edges, timeout)
    [min_nr_edges, max_nr_edges] = tighten_bounds(market_digraph, min_nr_edges, max_nr_edges);  
    if min_nr_edges > max_nr_edges
        cycles = {}; timed_out = false;
        return;
    end
    [cycles, timed_out] = get_cycles_tight_bounds(market_digraph, source_nodes, min_nr_edges, max_nr_edges, timeout);
end

% Iteratively: find all cycles that includ source node, then remove source node.
function [cycles, timed_out] = get_cycles_tight_bounds(market_digraph, source_nodes, min_nr_edges, max_nr_edges, timeout)
    timer = tic;  
    adjacency_matrix = full(adjacency(market_digraph));
    cycles = cell(length(source_nodes), 1);
    for idx = 1:length(source_nodes)
        source_node = source_nodes(idx);
        cycles{idx} = get_cycles_source_node(source_node, adjacency_matrix, min_nr_edges, max_nr_edges, timeout-toc(timer));
        adjacency_matrix = remove_node(adjacency_matrix, source_node);
        if toc(timer) > timeout
            cycles = NaN; timed_out = true;
            return;
        end
    end
    cycles = vertcat(cycles{:});
    timed_out = false;
end

function [adjacency_matrix] = remove_node(adjacency_matrix, node)
    adjacency_matrix(node, :) = 0;
    adjacency_matrix(:, node) = 0;
end

function [min_nr_edges, max_nr_edges] = tighten_bounds(market_digraph, min_nr_edges, max_nr_edges)
    min_nr_edges = max(min_nr_edges, 2);
    max_nr_edges = min(max_nr_edges, numnodes(market_digraph));
end

% Iteratively: add one edge to paths, close cycles.
function [cycles] = get_cycles_source_node(source_node, adjacency_matrix, min_nr_edges, max_nr_edges, timeout)
    timer = tic;
    cycles = cell(max_nr_edges-1, 1);
    paths = (source_node);
    for nr_edges = 1:max_nr_edges-1
        paths = add_edge_to_paths(paths, adjacency_matrix);
        if isempty(paths)
            break;
        elseif nr_edges+1 >= min_nr_edges
            cycles{nr_edges} = close_cycles(source_node, paths, adjacency_matrix);
        end     
        if toc(timer) > timeout
            cycles = NaN;
            return;
        end
    end
    cycles = vertcat(cycles{:});
end

% Finds cycles obtained from adding one edge between path(end) and path(1).
function [cycles] = close_cycles(source_node, paths, adjacency_matrix)
    last_paths = paths(:, end);
    predecessors_start = find(adjacency_matrix(:,source_node));
    closing_paths = paths(ismember(last_paths,predecessors_start), :);
    if isempty(closing_paths)
        cycles = {};
        return;
    end
    cycles = [closing_paths repelem(source_node,size(closing_paths,1),1)];
    cycles = matrix_rows_to_cells(cycles);
end
