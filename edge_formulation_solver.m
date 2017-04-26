% edge_formulation_solver(graph, timeout)
%
% Returns a subset of the input graph containing disjoint closed chains
% with a maximal number of nodes, or returns when the execution time 
% exceeds 'timeout'.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rules to the input graph:
% - For each node: indegree = outdegree      (cycle restriction)
% - For each node: outdegree <= 1            (disjointness restriction)
%
% The cycle restriction is translated to the form 'Ax <= b' as follows:
%   'A' : A nr_nodes x nr_edges matrix, where the rows represent the
%         nodes of the graph in some defined order (1), and the columns
%         represent the edges of the graph in some defined order (2).
%   'x' : A nr_edges vector, where each element represents the activation
%         of the edges in the graph in the order defined by (2). The
%         values in this vector are determined by the optimization.
%   'b' : A nr_nodes vector, where each element represents the restriction
%         of outdegree - indegree count, for each node of the graph, in the
%         order defined by (1).
%   We construct 'A' in such a way that 'Ax' represents the 
%   outdegree - indegree, for each node of the graph,
%   in the order defined by (1).
%
% The disjointness restriction is translated to the form 'Ax = b' as
% follows:
%   'A' : A nr_nodes x nr_edges matrix, where the rows represent the
%         nodes of the graph in some defined order (1), and the columns
%         represent the edges of the graph in the order defined by (2).
%   'x' : A nr_edges vector, where each element represents the activation
%         of the edges in the graph in the order defined by (2). The
%         values in this vector are determined by the optimization.
%   'b' : A nr_nodes vector, where each element represents the restriction
%         of outdegree count, for each node of the graph, in the order 
%         defined by (1).
%   We construct 'A' in such a way that 'Ax' represents the 
%   outdegree, for each node of the graph, in the order defined by (1).
%
% The solution with the maximal number of nodes is obtained by running an
% ILP maximization over the sum of x.

function [activated_graph, exchange_value] = edge_formulation_solver(graph, timeout)
    edge_weight_vector = ones(numedges(graph),1);
    [inequality_matrix, inequality_vector] = get_outdegree_constraints(graph);
    [equality_matrix, equality_vector] = get_indegree_equal_to_outdegree_constraints(graph);
    
    [activated_edge_indices, exchange_value] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout);
    
    activated_graph = digraph(graph.Edges(activated_edge_indices,:), graph.Nodes);
end

function [inequality_matrix, inequality_vector] = get_outdegree_constraints(graph)
    incidence_matrix = incidence(graph);
    inequality_matrix = incidence_to_outdegree_matrix(incidence_matrix);
    inequality_vector = ones(numnodes(graph),1);
end

function [equality_matrix, equality_vector] = get_indegree_equal_to_outdegree_constraints(graph)
    incidence_matrix = incidence(graph);
    equality_matrix = incidence_to_outdegree_minus_indegree_matrix(incidence_matrix);
    equality_vector = zeros(numnodes(graph),1);
end
