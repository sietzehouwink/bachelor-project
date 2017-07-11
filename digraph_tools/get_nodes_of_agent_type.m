function [nodes] = get_nodes_of_agent_type(market_digraph, agent_type)
    nodes = find(strcmp(market_digraph.Nodes.AgentType, agent_type));
end

