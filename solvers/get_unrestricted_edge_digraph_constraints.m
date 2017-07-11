function [inequality_matrix, inequality_vector] = get_unrestricted_edge_digraph_constraints(market_digraph)
    [inequality_matrix_1, inequality_vector_1] = get_outdegree_minus_indegree_constraints(market_digraph);
    [inequality_matrix_2, inequality_vector_2] = get_indegree_constraints(market_digraph);
    [inequality_matrix_3, inequality_vector_3] = get_outdegree_constraints(market_digraph);

    inequality_matrix = [inequality_matrix_1; inequality_matrix_2; inequality_matrix_3];   
    inequality_vector = [inequality_vector_1; inequality_vector_2; inequality_vector_3];
end

function [inequality_matrix, inequality_vector] = get_outdegree_minus_indegree_constraints(market_digraph)
    nodes_trader = find(strcmp(market_digraph.Nodes.AgentType, 'trader'));
    inequality_matrix = get_outdegree_minus_indegree_matrix(market_digraph, nodes_trader);
    inequality_vector = zeros(length(nodes_trader), 1);
end

function [outdegree_minus_indegree_matrix] = get_outdegree_minus_indegree_matrix(market_digraph, nodes)
    incidence_matrix = incidence(market_digraph);
    outdegree_minus_indegree_matrix = -incidence_matrix(nodes,:);
end

function [inequality_matrix, inequality_vector] = get_indegree_constraints(market_digraph)
    nodes_trader_receiver = find(strcmp(market_digraph.Nodes.AgentType, 'trader') | strcmp(market_digraph.Nodes.AgentType, 'receiver'));
    inequality_matrix = get_indegree_matrix(market_digraph, nodes_trader_receiver);
    inequality_vector = ones(length(nodes_trader_receiver),1);
end

function [indegree_matrix] = get_indegree_matrix(market_digraph, nodes)
    incidence_matrix = incidence(market_digraph);
    indegree_matrix = zeros(length(nodes), numedges(market_digraph));
    indegree_matrix(incidence_matrix(nodes,:) == 1) = 1;
end

function [inequality_matrix, inequality_vector] = get_outdegree_constraints(market_digraph)
    nodes_donor = find(strcmp(market_digraph.Nodes.AgentType, 'donor'));
    inequality_matrix = get_outdegree_matrix(market_digraph, nodes_donor);
    inequality_vector = ones(length(nodes_donor),1);
end

function [outdegree_matrix] = get_outdegree_matrix(market_digraph, nodes)
    incidence_matrix = incidence(market_digraph);
    outdegree_matrix = zeros(length(nodes), numedges(market_digraph));
    outdegree_matrix(incidence_matrix(nodes,:) == -1) = 1;
end