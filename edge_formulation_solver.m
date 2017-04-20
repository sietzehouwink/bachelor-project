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
    edge_weight_vector = get_edge_weight_vector(graph.nr_edges);
    inequality_matrix = to_out_degree_matrix(graph);
    inequality_vector = get_max_out_degree_vector(graph.nr_vertices);
    equality_matrix = to_degree_matrix(graph);
    equality_vector = get_exact_degree_vector(graph.nr_vertices);
    
    [activated_edge_indices, max_exchange_value] = activate_maximizing_value(edge_weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector);
    
    activated_graph = get_subgraph(graph, activated_edge_indices);
end


function [edge_weight_vector] = get_edge_weight_vector(nr_edges)
    edge_weight_vector = ones(nr_edges,1); 
end

function [out_degree_matrix] = to_out_degree_matrix(graph)
    out_degree_matrix = zeros(graph.nr_vertices, graph.nr_edges);
    edge_index = 1;
    for tail_vertex = 1:graph.nr_vertices
        for head_vertex = graph.adj_list{tail_vertex}'
            out_degree_matrix(tail_vertex, edge_index) = 1;
            edge_index = edge_index + 1;
        end
    end
end

function [max_out_degree_vector] = get_max_out_degree_vector(nr_vertices)
    max_out_degree_vector = ones(nr_vertices,1);
end

function [degree_matrix] = to_degree_matrix(graph)
    degree_matrix = zeros(graph.nr_vertices, graph.nr_edges);
    edge_index = 1;
    for tail_vertex = 1:graph.nr_vertices
        for head_vertex = graph.adj_list{tail_vertex}'
            degree_matrix(tail_vertex, edge_index) = 1;
            degree_matrix(head_vertex, edge_index) = -1;
            edge_index = edge_index + 1;
        end
    end
end

function [exact_degree_vector] = get_exact_degree_vector(nr_vertices)
    exact_degree_vector = zeros(nr_vertices,1);
end

function [subgraph] = get_subgraph(graph, subset_edge_indices)
    adj_list_subgraph = cell(graph.nr_vertices,1);
    
    sum_edges_prev_tails = 0;
    tail_vertex = 1;
    for edge_index = subset_edge_indices'
        % Skip to the correct row in the adjacency list.
        while sum_edges_prev_tails + size(graph.adj_list{tail_vertex},1) < edge_index
            sum_edges_prev_tails = sum_edges_prev_tails + size(graph.adj_list{tail_vertex},1);
            tail_vertex = tail_vertex + 1;
        end
        % Get edge from index.
        list_offset = edge_index - sum_edges_prev_tails;
        head_vertex = graph.adj_list{tail_vertex}(list_offset,1);
        % Add edge to subgraph.
        adj_list_subgraph{tail_vertex}(end+1,1) = head_vertex;
    end
    
    subgraph = struct('nr_vertices', {graph.nr_vertices}, 'nr_edges', {size(subset_edge_indices,1)}, 'adj_list', {adj_list_subgraph});
end

