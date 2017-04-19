function [graph] = create_graph(nr_vertices, edges)
    nr_edges = size(edges,1);
    
    adj_list = cell(nr_vertices,1);
    for edge_index = 1:nr_edges
        edge = edges{edge_index};
        adj_list{edge(1,1)}(end+1,1) = edge(2,1);
    end
    
    graph = struct('nr_vertices', {nr_vertices}, 'nr_edges', {nr_edges}, 'adj_list', {adj_list});
end

