function [subgraph] = get_subgraph(graph, subset_edge_indices)
    adj_list_subgraph = cell(graph.nr_vertices,1);
    
    sum_vertices_previous_tails = 0;
    tail_vertex = 1;
    for index = subset_edge_indices'
        while sum_vertices_previous_tails + size(graph.adj_list{tail_vertex},1) < index
            sum_vertices_previous_tails = sum_vertices_previous_tails + size(graph.adj_list{tail_vertex},1);
            tail_vertex = tail_vertex + 1;
        end
        offset = index - sum_vertices_previous_tails;
        head_vertex = graph.adj_list{tail_vertex}(offset,1);
        adj_list_subgraph{tail_vertex}(end+1,1) = head_vertex;
    end
    
    subgraph = struct('nr_vertices', {graph.nr_vertices}, 'nr_edges', {size(subset_edge_indices,1)}, 'adj_list', {adj_list_subgraph});
end
