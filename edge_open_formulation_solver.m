% edge_open_formulation_solver(graph, donating_node_indices, timeout)
%
% Returns a subset of the input graph containing disjoint open or closed 
% chains with a maximal number of nodes, where some nodes are restricted to
% be the starting node of a chain, or returns when the execution time 
% exceeds 'timeout'.
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
%   'A' : A nr_restrictions x nr_edges matrix, where the rows represent the
%         restrictions in some defined order (1), and the columns
%         represent the edges of the graph in some defined order (2).
%   'x' : A nr_edges vector, where each element represents the activation
%         of the edges in the graph in the order defined by (2). The
%         values in this vector are determined by the optimization.
%   'b' : A nr_restrictions vector, where each element represents the
%         restriction of the right hand side of the restriction, for
%         each restriction, in the order defined by (1).
%   We construct 'A' in such a way that 'Ax' represents the 
%   value of the left hand side of the restriction, for each node of the
%   graph, in the order defined by (1).
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
    [inequality_matrix, inequality_vector] = get_all_inequality_constraints(graph, donating_node_indices);
    [equality_matrix, equality_vector] = get_donating_indegree_constraints(graph, donating_node_indices);
    
    [activated_edge_indices, exchange_value] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout);
    
    activated_graph = digraph(graph.Edges(activated_edge_indices,:), graph.Nodes);
end

function [inequality_matrix, inequality_vector] = get_all_inequality_constraints(graph, donating_node_indices)
    trading_node_indices = setdiff(1:numnodes(graph), donating_node_indices);

    [inequality_matrix_1, inequality_vector_1] = get_donating_outdegree_constraints(graph, donating_node_indices);
    [inequality_matrix_2, inequality_vector_2] = get_trading_indegree_constraints(graph, trading_node_indices);
    [inequality_matrix_3, inequality_vector_3] = get_trading_outdegree_minus_indegree_constraints(graph, trading_node_indices);
    
    inequality_matrix = [inequality_matrix_1; inequality_matrix_2; inequality_matrix_3];   
    inequality_vector = [inequality_vector_1; inequality_vector_2; inequality_vector_3];
end

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
