function [cycles_chains, timed_out] = get_cycles_chains(digraph, min_edges_cycle, max_edges_cycle, min_edges_chain, max_edges_chain, timeout)
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    tic;
    [cycles, timed_out] = find_cycles(digraph, nodes_trader, min_edges_cycle, max_edges_cycle, timeout);
    if timed_out
        cycles_chains = {};
        return;
    end
    timeout = max(timeout-toc, 0);
    nodes_donor = find(strcmp(digraph.Nodes.AgentType, 'donor'));
    [chains, timed_out] = find_paths(digraph, nodes_donor, min_edges_chain, max_edges_chain, timeout);
    if timed_out
        cycles_chains = {};
        return;
    end
    cycles_chains = [cycles; chains];
end