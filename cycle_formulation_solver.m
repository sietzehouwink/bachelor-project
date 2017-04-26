% cycle_formulation_solver(graph, timeout)
%
% Returns a subset of the input graph containing disjoint closed chains
% with a maximal number of nodes, or returns when the execution time 
% exceeds 'timeout'.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rule to the input graph:
% - Each node is contained in at most one cycle.
%
% The restriction is translated to the form 'Ax <= b' as follows:
%   'A' : A nr_nodes x nr_cycles matrix, where the rows represent the
%         nodes of the graph in some defined order (1), and the columns
%         represent the cycles in the graph in some defined order (2).
%   'x' : A nr_cycles vector, where each element represents the activation
%         of the cycles in the graph in the order defined by (2). The
%         values in this vector are determined by the optimization.
%   'b' : A nr_nodes vector, where each element represents the restriction
%         of cycle containment count, for each node of the graph, in the
%         order defined by (1).
%   We construct 'A' in such a way that 'Ax' represents the cycle
%   containment count, for each node of the graph, in the order defined by
%   (1).
%
% The solution with the maximal number of nodes is obtained by running an
% ILP maximization over the the dot product of 'x' with the corresponding 
% cycle length vector.

function [activated_graph, exchange_value] = cycle_formulation_solver(graph, timeout)
    cycles = find_cycles(graph, timeout);
    
    cycle_weight_vector = cellfun(@length, cycles);
    [inequality_matrix, inequality_vector] = get_node_in_cycle_containment_constraints(numnodes(graph), cycles);
    
    [activated_cycle_indices, exchange_value] = activate_maximizing_value(cycle_weight_vector, inequality_matrix, inequality_vector, [], [], timeout);
    
    activated_graph = cycles_to_graph(numnodes(graph), cycles(activated_cycle_indices));
end

function [inequality_matrix, inequality_vector] = get_node_in_cycle_containment_constraints(nr_nodes, cycles)
    inequality_matrix = cycles_to_node_containment_count_matrix(nr_nodes, cycles);
    inequality_vector = ones(nr_nodes,1);
end

function [node_containment_count_matrix] = cycles_to_node_containment_count_matrix(nr_nodes, cycles)
    node_containment_count_matrix = zeros(nr_nodes, length(cycles));
    for cycle_index = 1:length(cycles)
        node_containment_count_matrix(cycles{cycle_index}, cycle_index) = 1;
    end
end

function [graph] = cycles_to_graph(nr_nodes, cycles)
    adjacency_matrix = sparse(nr_nodes, nr_nodes);
    for cycle = cycles
        node_vector = cycle{:};
        adjacency_matrix(sub2ind(size(adjacency_matrix), node_vector(1:end), [node_vector(2:end); node_vector(1)])) = 1;
    end
    graph = digraph(adjacency_matrix);
end
