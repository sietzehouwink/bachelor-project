function [graph] = generate_graph(nr_vertices, nr_cycles, length_cycle) % todo: edges can be duplicate..
    
    adj_list = cell(nr_vertices,1);
    nr_edges = 0;

    for i = 1:nr_cycles
        p = randperm(nr_vertices, length_cycle)';
        for j = 1:size(p,1)-1
            adj_list{p(j,1)}(end+1,1) = p(j+1,1);
        end
        adj_list{p(end,1)}(end+1,1) = p(1,1);
        nr_edges = nr_edges + size(p,1);
    end
    
    graph = struct('nr_vertices', {nr_vertices}, 'nr_edges', {nr_edges}, 'adj_list', {adj_list});
    
end