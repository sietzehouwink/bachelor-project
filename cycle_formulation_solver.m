% cycle_formulation_solver(graph)
%
% Returns a subset of the input graph containing disjoint (closed) chains
% with a maximal number of nodes.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rule to the input graph:
% - Each vertex is contained in at most one cycle.
%
% The restriction can be translated to the form 'Ax <= b' as follows:
%   Let A be a nr_vertices x nr_cycles matrix, where the rows and columns
%   represent the vertices and cycles in some defined order, respectively.
%   Each element (v,c) has the value 0 iff v does not occur in c, and the
%   value 1 iff v does occur in c.
%   Let x be an activation vector of length nr_cycles, i.e. each element c
%   has the value 0 iff the cycle is de-activated, and the value 1 iff the
%   cycle is activated.
%   The product Ax results in a vector containing the containment count of
%   each vertex. 
%   The restriction is completed by defining b to be the ones vector.
%
% The solution with the maximal number of nodes is obtained by running an
% ILP maximization over the the dot product of x with the corresponding 
% cycle length vector.

function [activated_graph, max_exchange_value] = cycle_formulation_solver(graph)
    cycles = find_cycles(graph);
    
    if size(cycles,1) == 0
        activated_graph = digraph(sparse(numnodes(graph), numnodes(graph)));
        max_exchange_value = 0;
        return;
    end
    
    cycle_weight_vector = get_cycle_lengths(cycles);
    inequality_matrix = to_vertex_containment_count_matrix(graph, cycles);
    inequality_vector = get_max_vertex_containment_count_vector(numnodes(graph));
    
    [activated_cycle_indices, max_exchange_value] = activate_maximizing_value(cycle_weight_vector, inequality_matrix, inequality_vector, [], []);
    
    activated_graph = get_subgraph(numnodes(graph), cycles, activated_cycle_indices);
end

function [cycle_lengths] = get_cycle_lengths(cycles)
    nr_cycles = size(cycles,1);
    cycle_lengths = zeros(nr_cycles,1);
    for cycle_index = 1:nr_cycles
        cycle = cycles{cycle_index};
        cycle_lengths(cycle_index) = size(cycle,1);
    end
end

function [vertex_containment_count_matrix] = to_vertex_containment_count_matrix(graph, cycles)
    nr_cycles = size(cycles,1);
    vertex_containment_count_matrix = zeros(numnodes(graph), nr_cycles);
    for cycle_index = 1:nr_cycles
        for vertex = cycles{cycle_index}
            vertex_containment_count_matrix(vertex, cycle_index) = 1;
        end
    end
end

function [max_vertex_in_cycle_count] = get_max_vertex_containment_count_vector(nr_vertices)
    max_vertex_in_cycle_count = ones(nr_vertices,1);
end

function [subgraph] = get_subgraph(nr_vertices, cycles, activated_cycle_indices)
    activated_cycles = cycles(activated_cycle_indices);
    adj_matrix = zeros(nr_vertices, nr_vertices);
    for cycle_index = 1:size(activated_cycles,1)
        cycle = activated_cycles{cycle_index};
        nr_vertices = size(cycle,1);
        for vertex = 1:nr_vertices-1
            adj_matrix(cycle(vertex,1), cycle(vertex+1,1)) = 1;
        end
        adj_matrix(cycle(end,1), cycle(1,1)) = 1;
    end
    subgraph = digraph(adj_matrix);
end
