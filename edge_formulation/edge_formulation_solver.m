function [activated_graph, exchange_value, timed_out] = edge_formulation_solver(graph, timeout)
    edge_weight_vector = graph.Edges.Weight;
    [inequality_matrix, inequality_vector] = get_inequality_constraints(graph);
    
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, [], [], timeout);
    
    activated_graph = digraph(graph.Edges(activated_edge_indices,:), graph.Nodes);
end

function [inequality_matrix, inequality_vector] = get_inequality_constraints(graph)
    [inequality_matrix_1, inequality_vector_1] = get_outdegree_constraints(graph);
    [inequality_matrix_2, inequality_vector_2] = get_outdegree_minus_indegree_constraints(graph);
    [inequality_matrix_3, inequality_vector_3] = get_indegree_constraints(graph);
    
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2; inequality_matrix_3];   
    inequality_vector = [inequality_vector_1; inequality_vector_2; inequality_vector_3];
end

function [inequality_matrix, inequality_vector] = get_outdegree_constraints(graph)
    nodes_donor_trader = find(strcmp(graph.Nodes.AgentType, 'donor') | strcmp(graph.Nodes.AgentType, 'trader'));
    incidence_matrix = incidence(graph);
    incidence_matrix_donor_trader = incidence_matrix(nodes_donor_trader,:);
    
    inequality_matrix = incidence_to_outdegree_matrix(incidence_matrix_donor_trader);
    inequality_vector = ones(length(nodes_donor_trader),1);
end

function [inequality_matrix, inequality_vector] = get_outdegree_minus_indegree_constraints(graph)
    nodes_trader = find(strcmp(graph.Nodes.AgentType, 'trader'));
    incidence_matrix = incidence(graph);
    incidence_matrix_trader = incidence_matrix(nodes_trader,:);
    
    inequality_matrix = incidence_to_outdegree_minus_indegree_matrix(incidence_matrix_trader);
    inequality_vector = zeros(length(nodes_trader),1);
end

function [inequality_matrix, inequality_vector] = get_indegree_constraints(graph)
    nodes_receiver = find(strcmp(graph.Nodes.AgentType, 'receiver'));
    incidence_matrix = incidence(graph);
    incidence_matrix_receiver = incidence_matrix(nodes_receiver,:);
    
    inequality_matrix = incidence_to_indegree_matrix(incidence_matrix_receiver);
    inequality_vector = ones(length(nodes_receiver),1);
end