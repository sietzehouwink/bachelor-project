% edge_open_formulation_solver(graph, donating_node_indices, timeout)
%
% Returns a subset of the input graph containing disjoint (open) chains
% with a maximal number of nodes, or returns when exceeding the timeout.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rules to the input graph:
% - For each donating node:
%   - in-degree = 0                 (1) Donate not receiving return.
%   - out-degree <= 1               (2) Donate to at most one node.
% - For each non-donating node:
%   - in-degree <= 1                (3) Receive at most from one node.
%   - out-degree - in-degree <= 0   (4) Only donate (possibly) when receiving.
%
% A restriction is translated to the form 'Ax (<)= b' as follows:
%   'A' : a nr_restrictions x nr_edges matrix.
%   'x' : a nr_edges vector.
%   'b' : a nr_restrictions vector.
%
%   Let each element of 'x' have the value 1 if the edge is activated, and 
%   0 otherwise. For some restriction, the product 'Ax' should then be a
%   vector expressing the value of the left hand side of this restriction
%   for each edge. The incidence matrix of the graph allows us to construct
%   'A' for each restriction. 'b' should then be a vector expressing the
%   value of the (constant) right hand side of this restriction.
%
%   In the case of multiple restrictions of a certain type (equality or 
%   inequality), we vertically concatenate the matrices and vectors of 
%   each restriction respectively. This way we will obtain a single
%   equality 'Ax = b' and a single inequality 'Ax <= b' relation.
%
% The solution with the maximal number of nodes is obtained by running an
% ILP maximization over the sum of x.

function [activated_graph, exchange_value] = edge_open_formulation_solver(graph, donating_node_indices, timeout)
    edge_weight_vector = ones(numedges(graph),1);
    [inequality_matrix, inequality_vector] = get_inequality_constraints(graph, donating_node_indices);
    [equality_matrix, equality_vector] = get_equality_constraints(graph, donating_node_indices);
    
    [activated_edge_indices, exchange_value] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout);
    
    activated_graph = digraph(graph.Edges(activated_edge_indices,:), graph.Nodes);
end

% First level constraint generation.

function [inequality_matrix, inequality_vector] = get_inequality_constraints(graph, donating_node_indices)
    trading_node_indices = setdiff(1:numnodes(graph), donating_node_indices);

    [inequality_matrix_1, inequality_vector_1] = get_donating_outdegree_constraints(graph, donating_node_indices);
    [inequality_matrix_2, inequality_vector_2] = get_trading_indegree_constraints(graph, trading_node_indices);
    [inequality_matrix_3, inequality_vector_3] = get_trading_outdegree_minus_indegree_constraints(graph, trading_node_indices);
    
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2; inequality_matrix_3];   
    inequality_vector = [inequality_vector_1; inequality_vector_2; inequality_vector_3];
end

function [equality_matrix, equality_vector] = get_equality_constraints(graph, donating_node_indices)
    [equality_matrix, equality_vector] = get_donating_indegree_constraints(graph, donating_node_indices);
end

% Second level constraint generation.

function [inequality_matrix, inequality_vector] = get_donating_outdegree_constraints(graph, donating_node_indices)
    incidence_graph_matrix = incidence(graph);
    incidence_donating_matrix = incidence_graph_matrix(donating_node_indices,:);
    inequality_matrix = incidence_to_outdegree_matrix(incidence_donating_matrix);
    inequality_vector = ones(length(donating_node_indices),1);
end

function [inequality_matrix, inequality_vector] = get_trading_indegree_constraints(graph, trading_node_indices)
    incidence_graph_matrix = incidence(graph);
    incidence_trading_matrix = incidence_graph_matrix(trading_node_indices,:);
    inequality_matrix = incidence_to_indegree_matrix(incidence_trading_matrix);
    inequality_vector = ones(length(trading_node_indices),1);
end

function [inequality_matrix, inequality_vector] = get_trading_outdegree_minus_indegree_constraints(graph, trading_node_indices)
    incidence_graph_matrix = incidence(graph);
    incidence_trading_matrix = incidence_graph_matrix(trading_node_indices,:);
    inequality_matrix = incidence_to_outdegree_minus_indegree_matrix(incidence_trading_matrix);
    inequality_vector = zeros(length(trading_node_indices),1);
end

function [equality_matrix, equality_vector] = get_donating_indegree_constraints(graph, donating_node_indices)
    incidence_graph_matrix = incidence(graph);
    incidence_donating_matrix = incidence_graph_matrix(donating_node_indices,:);
    equality_matrix = incidence_to_indegree_matrix(incidence_donating_matrix);
    equality_vector = zeros(length(donating_node_indices),1);
end

% Incidence matrix to degree calculating matrices.

function [outdegree_matrix] = incidence_to_outdegree_matrix(incidence_matrix)
    [nr_nodes, nr_edges] = size(incidence_matrix);
    outdegree_matrix = sparse(nr_nodes, nr_edges);
    outdegree_matrix(incidence_matrix == -1) = 1;
end

function [indegree_matrix] = incidence_to_indegree_matrix(incidence_matrix)
    [nr_nodes, nr_edges] = size(incidence_matrix);
    indegree_matrix = sparse(nr_nodes, nr_edges);
    indegree_matrix(incidence_matrix == 1) = 1;
end

function [outdegree_minus_indegree_matrix] = incidence_to_outdegree_minus_indegree_matrix(incidence_matrix)
    outdegree_minus_indegree_matrix = -incidence_matrix;
end






