function [graph] = generate_graph(nr_vertices, nr_cycles, length_cycle)
    
    adj_matrix = zeros(nr_vertices, nr_vertices);
    for i = 1:nr_cycles
        p = randperm(nr_vertices, length_cycle)';
        for j = 1:size(p,1)-1
            adj_matrix(p(j,1), p(j+1,1)) = 1;
        end
        adj_matrix(p(end,1), p(1,1)) = 1;
    end
    graph = digraph(adj_matrix);
    
end