% edge_formulation_solver(graph)
%
% Returns a subset of the input graph containing disjoint (closed) chains
% with a maximal number of nodes.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rules to the input graph:
% - For each vertex: in-degree = out-degree     (cycle restriction)
% - For each vertex: out-degree <= 1            (disjointness restriction)
%
% The cycle restriction can be translated to the form 'Ax=b' as follows:
%   Let A be a nr_vertices x nr_edges matrix, where the rows and columns
%   represent the vertices and edges in some defined order, respectively.
%   Each element (v,e) has the value 0 iff e does not have v as one of its
%   endpoints, the value 1 iff e has v as tail vertex, and the value -1 iff 
%   e has v as head vertex.
%   Let x be an activation vector of length nr_edges, i.e. each element e
%   has the value 0 iff the edge is de-activated, and the value 1 iff the 
%   edge is activated.
%   The product Ax results in a vector containing the degree of each
%   vertex. 
%   The cycle restriction is completed by defining b to be the zero vector.
%
% The disjointness restriction can be translated to the form 'Ax <= b' as
% follows:
%   Let A be as defined in the previous section, except for its values. 
%   Each element (v,e) has the value 0 iff e does not have v as tail 
%   vertex, and the value 1 iff e has v as tail vertex.
%   Let x be as defined in the previous section.
%   The product Ax results in a vector containing the out-degree of each 
%   vertex. 
%   The disjointness restriction is completed by defining b to be the 
%   ones vector.
%
% The solution with the maximal number of nodes is obtained by running an
% ILP maximization over the sum of x.


function [activated_graph, max_exchange_value] = edge_formulation_solver(graph)
    if numedges(graph) == 0
        activated_graph = digraph(sparse(numnodes(graph), numnodes(graph)));
        max_exchange_value = 0;
        return;
    end

    edge_weight_vector = get_edge_weight_vector(numedges(graph));
    inequality_matrix = to_out_degree_matrix(graph);
    inequality_vector = get_max_out_degree_vector(numnodes(graph));
    equality_matrix = to_degree_matrix(graph);
    equality_vector = get_exact_degree_vector(numnodes(graph));
    
    [activated_edge_indices, max_exchange_value] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector);
    
    activated_graph = digraph(graph.Edges(activated_edge_indices,:), graph.Nodes);
end


function [edge_weight_vector] = get_edge_weight_vector(nr_edges)
    edge_weight_vector = ones(nr_edges,1); 
end

function [out_degree_matrix] = to_out_degree_matrix(graph)
    out_degree_matrix = zeros(numnodes(graph), numedges(graph));
    edge_index = 1;
    for tail_vertex = 1:numnodes(graph)
        for head_vertex = successors(graph,tail_vertex)'
            out_degree_matrix(tail_vertex, edge_index) = 1;
            edge_index = edge_index + 1;
        end
    end
end

function [max_out_degree_vector] = get_max_out_degree_vector(nr_vertices)
    max_out_degree_vector = ones(nr_vertices,1);
end

function [degree_matrix] = to_degree_matrix(graph)
    degree_matrix = zeros(numnodes(graph), numedges(graph));
    edge_index = 1;
    for tail_vertex = 1:numnodes(graph)
        for head_vertex = successors(graph,tail_vertex)'
            degree_matrix(tail_vertex, edge_index) = 1;
            degree_matrix(head_vertex, edge_index) = -1;
            edge_index = edge_index + 1;
        end
    end
end

function [exact_degree_vector] = get_exact_degree_vector(nr_vertices)
    exact_degree_vector = zeros(nr_vertices,1);
end
