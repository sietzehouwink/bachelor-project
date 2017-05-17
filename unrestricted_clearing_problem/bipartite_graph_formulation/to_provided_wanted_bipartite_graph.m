function [bipartite_graph] = to_provided_wanted_bipartite_graph(digraph)     
    node_table = get_provided_wanted_bipartite_graph_node_table(digraph);
    edge_table_1 = get_provided_wanted_bipartite_graph_edge_table(digraph);
    edge_table_2 = get_trader_provided_wanted_zero_weight_edge_table(digraph);
    bipartite_graph = graph([edge_table_1; edge_table_2], node_table);
end

function [node_table] = get_provided_wanted_bipartite_graph_node_table(digraph)
    provided_node_table = digraph.Nodes;
    provided_node_table.ItemType = repmat({'provided'},height(provided_node_table),1);
    wanted_node_table = digraph.Nodes;
    wanted_node_table.ItemType = repmat({'wanted'},height(wanted_node_table),1);
    node_table = [provided_node_table; wanted_node_table];
end

function [edge_table] = get_provided_wanted_bipartite_graph_edge_table(digraph)
    edge_table = digraph.Edges;
    edge_table.EndNodes(:,2) = edge_table.EndNodes(:,2) + numnodes(digraph);
    edge_table.Weight = ones(height(edge_table),1);
end

function [edge_table] = get_trader_provided_wanted_zero_weight_edge_table(digraph)
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    EndNodes = [nodes_trader, nodes_trader + numnodes(digraph)];
    Weight = zeros(numnodes(digraph),1);
    edge_table = table(EndNodes, Weight);
end