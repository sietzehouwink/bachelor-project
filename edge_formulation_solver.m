function [activated_graph, max_exchange_value] = edge_formulation_solver(graph)
    weight_vector = get_edge_weight_vector(graph.nr_edges);
    inequality_matrix = to_out_degree_matrix(graph);
    inequality_vector = get_max_out_degree_vector(graph.nr_vertices);
    equality_matrix = to_degree_matrix(graph);
    equality_vector = get_exact_degree_vector(graph.nr_vertices);
    
    [activated_edge_indices, max_exchange_value] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector);
    
    activated_graph = get_subgraph(graph, activated_edge_indices);
end

function [edge_weight_vector] = get_edge_weight_vector(nr_edges)
    edge_weight_vector = ones(nr_edges,1);
end

function [out_degree_matrix] = to_out_degree_matrix(graph)
    out_degree_matrix = zeros(graph.nr_vertices, graph.nr_edges);
    edge_index = 1;
    for tail_vertex = 1:graph.nr_vertices
        for head_vertex = graph.adj_list{tail_vertex}'
            out_degree_matrix(tail_vertex, edge_index) = 1;
            edge_index = edge_index + 1;
        end
    end
end

function [max_out_degree_vector] = get_max_out_degree_vector(nr_vertices)
    max_out_degree_vector = ones(nr_vertices,1);
end

function [degree_matrix] = to_degree_matrix(graph)
    degree_matrix = zeros(graph.nr_vertices, graph.nr_edges);
    edge_index = 1;
    for tail_vertex = 1:graph.nr_vertices
        for head_vertex = graph.adj_list{tail_vertex}'
            degree_matrix(tail_vertex, edge_index) = 1;
            degree_matrix(head_vertex, edge_index) = -1;
            edge_index = edge_index + 1;
        end
    end
end

function [exact_degree_vector] = get_exact_degree_vector(nr_vertices)
    exact_degree_vector = zeros(nr_vertices,1);
end


