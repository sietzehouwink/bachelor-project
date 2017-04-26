% edge_formulation_solver(graph)
%
% Returns a subset of the input graph containing disjoint closed chains
% with a maximal number of nodes.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rules to the input graph:
% - For each node: in-degree = out-degree     (cycle restriction)
% - For each node: out-degree <= 1            (disjointness restriction)
%
% The cycle restriction can be translated to the form 'Ax=b' as follows:
%   Let A be a nr_nodes x nr_edges matrix, where the rows and columns
%   represent the nodes and edges in some defined order, respectively.
%   Each element (n,e) has the value 0 iff e does not have n as one of its
%   endpoints, the value 1 iff e has n as tail node, and the value -1 iff 
%   e has n as head node.
%   Let x be an activation vector of length nr_edges, i.e. each element e
%   has the value 0 iff the edge is de-activated, and the value 1 iff the 
%   edge is activated.
%   The product Ax results in a vector containing the degree of each
%   node. 
%   The cycle restriction is completed by defining b to be the zero vector.
%
% The disjointness restriction can be translated to the form 'Ax <= b' as
% follows:
%   Let A be as defined in the previous section, except for its values. 
%   Each element (n,e) has the value 0 iff e does not have n as tail 
%   node, and the value 1 iff e has n as tail node.
%   Let x be as defined in the previous section.
%   The product Ax results in a vector containing the out-degree of each 
%   node. 
%   The disjointness restriction is completed by defining b to be the 
%   ones vector.
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
