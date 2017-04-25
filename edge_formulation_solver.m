% edge_formulation_solver(graph)
%
% Returns a subset of the input graph containing disjoint (closed) chains
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
    nr_nodes = numnodes(graph);
    nr_edges = numedges(graph);

    if nr_edges == 0
        activated_graph = digraph(sparse(nr_nodes, nr_nodes));
        exchange_value = 0;
        return;
    end

    edge_weight_vector = get_edge_weight_vector(nr_edges);
    inequality_matrix = to_out_degree_matrix(graph);
    inequality_vector = get_max_out_degree_vector(nr_nodes);
    equality_matrix = to_degree_matrix(graph);
    equality_vector = get_exact_degree_vector(nr_nodes);
    
    [activated_edge_indices, exchange_value] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout);
    
    activated_graph = digraph(graph.Edges(activated_edge_indices,:), graph.Nodes);
end


function [edge_weight_vector] = get_edge_weight_vector(nr_edges)
    edge_weight_vector = ones(nr_edges,1); 
end

function [out_degree_matrix] = to_out_degree_matrix(graph)
    nr_nodes = numnodes(graph);
    nr_edges = numedges(graph);
    out_degree_matrix = zeros(nr_nodes, nr_edges);
    for edge_index = 1:nr_edges
        tail_node = graph.Edges{:,1}(edge_index);
        out_degree_matrix(tail_node, edge_index) = 1;
    end
end

function [max_out_degree_vector] = get_max_out_degree_vector(nr_nodes)
    max_out_degree_vector = ones(nr_nodes,1);
end

function [degree_matrix] = to_degree_matrix(graph)
    nr_nodes = numnodes(graph);
    nr_edges = numedges(graph);
    degree_matrix = zeros(nr_nodes, nr_edges);
    for edge_index = 1:nr_edges
        edge = graph.Edges{:,1}(edge_index,:);
        degree_matrix(edge(1), edge_index) = 1;
        degree_matrix(edge(2), edge_index) = -1;
    end
end

function [exact_degree_vector] = get_exact_degree_vector(nr_nodes)
    exact_degree_vector = zeros(nr_nodes,1);
end
