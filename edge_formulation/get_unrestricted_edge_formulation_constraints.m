function [inequality_matrix, inequality_vector] = get_unrestricted_edge_formulation_constraints(digraph)
    [inequality_matrix_1, inequality_vector_1] = get_outdegree_constraints(digraph);
    [inequality_matrix_2, inequality_vector_2] = get_outdegree_minus_indegree_constraints(digraph);
    [inequality_matrix_3, inequality_vector_3] = get_indegree_constraints(digraph);
    
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2; inequality_matrix_3];   
    inequality_vector = [inequality_vector_1; inequality_vector_2; inequality_vector_3];
end

function [inequality_matrix, inequality_vector] = get_outdegree_constraints(digraph)
    nodes_donor_trader = find(strcmp(digraph.Nodes.AgentType, 'donor') | strcmp(digraph.Nodes.AgentType, 'trader'));
    inequality_matrix = get_outdegree_matrix(digraph, nodes_donor_trader);
    inequality_vector = ones(length(nodes_donor_trader),1);
end

function [inequality_matrix, inequality_vector] = get_outdegree_minus_indegree_constraints(digraph)
    nodes_trader = strcmp(digraph.Nodes.AgentType, 'trader');
    inequality_matrix = get_outdegree_minus_indegree_matrix(digraph, nodes_trader);
    inequality_vector = zeros(length(nodes_trader),1);
end

function [inequality_matrix, inequality_vector] = get_indegree_constraints(digraph)
    nodes_receiver = find(strcmp(digraph.Nodes.AgentType, 'receiver'));
    inequality_matrix = get_indegree_matrix(digraph, nodes_receiver);
    inequality_vector = ones(length(nodes_receiver),1);
end