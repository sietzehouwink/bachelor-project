function [digraph_] = cycles_chains_to_digraph(cycles_chains, nr_nodes)
    edges_per_cycle_chain = cellfun(@(cycle_chain) [cycle_chain(1:end-1), cycle_chain(2:end)], cycles_chains, 'UniformOutput', false);
    edges = vertcat(edges_per_cycle_chain{:});
    if isempty(edges)
        digraph_ = digraph();
        return;
    end
    digraph_ = digraph(edges(:,1), edges(:,2), 1, nr_nodes);
end