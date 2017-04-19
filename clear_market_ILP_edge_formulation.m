function [optimal_edge_indices, max_exchange_weight] = clear_market_ILP_edge_formulation(graph)
    [A, Aeq] = graph_to_degree_calculating_matrices(graph);
    [b, beq, lb, ub] = initialize_constraints(graph);
    [optimal_edge_indices, max_exchange_weight] = maximize_ILP(A, b, Aeq, beq, lb, ub);
end

function [variables, value] = maximize_ILP(A, b, Aeq, beq, lb, ub)
    nr_vars = size(lb, 1);
    f = -ones(nr_vars, 1);
    intcon = ones(nr_vars, 1);
    options = optimoptions('intlinprog', 'Display', 'none');
    [variables, fval, ~, ~] = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub, options);
    value = -fval;
end

function [max_out_degree, exact_degree, min_edge_chosen, max_edge_chosen] = initialize_constraints(graph)
    max_out_degree = ones(graph.nr_vertices, 1);
    exact_degree = zeros(graph.nr_vertices, 1);
    min_edge_chosen = zeros(graph.nr_edges, 1);
    max_edge_chosen = ones(graph.nr_edges, 1);
end

function [out_degree_matrix, degree_matrix] = graph_to_degree_calculating_matrices(graph)
    out_degree_matrix = zeros(graph.nr_vertices, graph.nr_edges);
    degree_matrix = zeros(graph.nr_vertices, graph.nr_edges);
    edge_index = 0;
    for tail_vertex = 1:graph.nr_vertices
        adjacent_to_tail_vertex = graph.adj_list{tail_vertex};
        for head_vertex = adjacent_to_tail_vertex'
            edge_index = edge_index + 1;
            out_degree_matrix(tail_vertex, edge_index) = 1;
            degree_matrix(tail_vertex, edge_index) = 1;
            degree_matrix(head_vertex, edge_index) = -1;
        end
    end
end
