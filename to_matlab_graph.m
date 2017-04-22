function [matlab_graph] = to_matlab_graph(own_graph)
    adj_matrix = zeros(own_graph.nr_vertices, own_graph.nr_vertices);
    for i = 1:own_graph.nr_vertices
        list = own_graph.adj_list{i};
        adj_matrix(i,list) = 1;
    end
    matlab_graph = digraph(adj_matrix);
end

