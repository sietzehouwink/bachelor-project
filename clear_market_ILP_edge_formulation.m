function [optimal_edge_indices, max_exchange_weight] = clear_market_ILP_edge_formulation(nr_vertices, edges)
    [A, Aeq] = graph_to_degree_calculating_matrices(nr_vertices, edges);
    [b, beq, lb, ub] = initialize_constraints(nr_vertices, size(edges, 1));
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

function [max_out_degree, exact_degree, min_edge_chosen, max_edge_chosen] = initialize_constraints(nr_vertices, nr_edges)
    max_out_degree = ones(nr_vertices, 1);
    exact_degree = zeros(nr_vertices, 1);
    min_edge_chosen = zeros(nr_edges, 1);
    max_edge_chosen = ones(nr_edges, 1);
end

function [out_degree_matrix, degree_matrix] = graph_to_degree_calculating_matrices(nr_vertices, edges)
    nr_edges = size(edges,1);
    out_degree_matrix = zeros(nr_vertices, nr_edges);
    degree_matrix = zeros(nr_vertices, nr_edges);
    for edge_index = 1:nr_edges
        edge = edges(edge_index, 1:end);
        outgoing_vertex = edge(1);
        incoming_vertex = edge(2);
        out_degree_matrix(outgoing_vertex, edge_index) = 1;
        degree_matrix(outgoing_vertex, edge_index) = 1;
        degree_matrix(incoming_vertex, edge_index) = -1;
    end
end
