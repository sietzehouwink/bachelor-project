function [activated_digraph, exchange_value, timed_out] = edge_formulation_solver(digraph_, timeout)
    [inequality_matrix, inequality_vector] = get_unrestricted_constraints(digraph_);
    [activated_edge_indices, exchange_value, timed_out] = activate_maximizing_value(digraph_.Edges.Weight, inequality_matrix, inequality_vector, [], [], timeout);  
    if timed_out
        activated_digraph = digraph();
        return;
    end
    activated_digraph = digraph(digraph_.Edges(activated_edge_indices,:), digraph_.Nodes);
end