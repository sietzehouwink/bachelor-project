function [bipartite_graph] = to_bipartite_graph(digraph)     
    node_table = get_node_table(digraph);
    edge_table_weight_1 = get_edge_table_weight_1(digraph);
    edge_table_weight_0 = get_edge_table_weight_0(digraph);
    bipartite_graph = graph([edge_table_weight_1; edge_table_weight_0], node_table);
end

function [node_table] = get_node_table(digraph)
    node_table_provided = digraph.Nodes;
    node_table_provided.ItemType = repmat({'provided'},height(node_table_provided),1);
    node_table_wanted = digraph.Nodes;
    node_table_wanted.ItemType = repmat({'wanted'},height(node_table_wanted),1);
    node_table = [node_table_provided; node_table_wanted];
end

function [edge_table] = get_edge_table_weight_1(digraph)
    edge_table = digraph.Edges;
    edge_table.EndNodes(:,2) = edge_table.EndNodes(:,2) + numnodes(digraph);
    edge_table.Weight = ones(height(edge_table),1);
end

function [edge_table] = get_edge_table_weight_0(digraph)
    nodes_trader = find(strcmp(digraph.Nodes.AgentType, 'trader'));
    EndNodes = [nodes_trader, nodes_trader + numnodes(digraph)];
    Weight = zeros(length(nodes_trader),1);
    edge_table = table(EndNodes, Weight);
end