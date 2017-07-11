function [paths, timed_out] = get_paths(market_digraph, source_nodes, min_nr_edges, max_nr_edges, timeout)
    [min_nr_edges, max_nr_edges] = tighten_bounds(market_digraph, min_nr_edges, max_nr_edges);  
    if min_nr_edges > max_nr_edges
        paths = {}; timed_out = false;
        return;
    end
    [paths, timed_out] = get_paths_tight_bounds(market_digraph, source_nodes, min_nr_edges, max_nr_edges, timeout);
end

function [min_nr_edges, max_nr_edges] = tighten_bounds(market_digraph, min_nr_edges, max_nr_edges)
    min_nr_edges = max(1, min_nr_edges);
    max_nr_edges = min(max_nr_edges, numnodes(market_digraph)-1);
end

function [paths, timed_out] = get_paths_tight_bounds(market_digraph, source_nodes, min_nr_edges, max_nr_edges, timeout)
    timer = tic;
    adjacency_matrix = full(adjacency(market_digraph));
    paths = cell(length(source_nodes), 1);
    for idx = 1:length(source_nodes)
        source_node = source_nodes(idx);
        paths{idx} = get_paths_source_node(source_node, adjacency_matrix, min_nr_edges, max_nr_edges);
        if toc(timer) > timeout
            paths = NaN; timed_out = true;
            return;
        end
    end
    paths = vertcat(paths{:});
    timed_out = false;
end

function [paths] = get_paths_source_node(source_node, adjacency_matrix, min_nr_edges, max_nr_edges)
    paths = cell(max_nr_edges, 1);
    paths_matrix = (source_node);
    for edges = 1:max_nr_edges
        paths_matrix = add_edge_to_paths(paths_matrix, adjacency_matrix);
        if isempty(paths_matrix)
            break;
        end
        if edges >= min_nr_edges
            paths{edges} = matrix_rows_to_cells(paths_matrix);
        end     
    end
    paths = vertcat(paths{:});
end
