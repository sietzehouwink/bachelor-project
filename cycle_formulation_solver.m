% cycle_formulation_solver(graph)
%
% Returns a subset of the input graph containing disjoint (closed) chains
% with a maximal number of nodes.
%
% A feasible solution, i.e. a set of disjoint chains, is a restriction of 
% the following rule to the input graph:
% - Each node is contained in at most one cycle.
%
% The restriction can be translated to the form 'Ax <= b' as follows:
%   Let A be a nr_nodes x nr_cycles matrix, where the rows and columns
%   represent the nodes and cycles in some defined order, respectively.
%   Each element (n,c) has the value 0 iff n does not occur in c, and the
%   value 1 iff n does occur in c.
%   Let x be an activation vector of length nr_cycles, i.e. each element c
%   has the value 0 iff the cycle is de-activated, and the value 1 iff the
%   cycle is activated.
%   The product Ax results in a vector containing the containment count of
%   each node. 
%   The restriction is completed by defining b to be the ones vector.
%
% The solution with the maximal number of nodes is obtained by running an
% ILP maximization over the the dot product of x with the corresponding 
% cycle length vector.

function [activated_graph, exchange_value] = cycle_formulation_solver(graph, timeout)
    nr_nodes = numnodes(graph);
    cycles = find_cycles(graph, timeout);

    if isempty(cycles)
        activated_graph = digraph(sparse(nr_nodes, nr_nodes));
        exchange_value = 0;
        return;
    end
    
    cycle_weight_vector = get_cycle_lengths(cycles);
    inequality_matrix = to_node_containment_count_matrix(graph, cycles);
    inequality_vector = get_max_node_containment_count_vector(nr_nodes);
    
    [activated_cycle_indices, exchange_value] = activate_maximizing_value(cycle_weight_vector, inequality_matrix, inequality_vector, [], [], timeout);
    
    activated_graph = cycles_to_graph(nr_nodes, cycles(activated_cycle_indices));
end

function [cycle_lengths] = get_cycle_lengths(cycles)
    cycle_lengths = cellfun(@length, cycles);
end

function [node_containment_count_matrix] = to_node_containment_count_matrix(graph, cycles)
    nr_cycles = length(cycles);
    nr_nodes = numnodes(graph);
    node_containment_count_matrix = zeros(nr_nodes, nr_cycles);
    for cycle_index = 1:nr_cycles
        for node = cycles{cycle_index}
            node_containment_count_matrix(node, cycle_index) = 1;
        end
    end
end

function [max_node_in_cycle_count] = get_max_node_containment_count_vector(nr_nodes)
    max_node_in_cycle_count = ones(nr_nodes,1);
end

function [subgraph] = cycles_to_graph(nr_nodes, activated_cycles)
    adj_matrix = zeros(nr_nodes, nr_nodes);
    for cycle = activated_cycles
        node_array = cycle{:};
        for node_index = 1:length(node_array)-1
            adj_matrix(node_array(node_index), node_array(node_index+1)) = 1;
        end
        adj_matrix(node_array(end), node_array(1)) = 1;
    end
    subgraph = digraph(adj_matrix);
end
