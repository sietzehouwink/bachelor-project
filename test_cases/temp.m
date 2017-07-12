load('digraphs');
i = 10;

plot(digraphs{i}, 'NodeLabel', digraphs{i}.Nodes.AgentType, 'EdgeColor', 'black', 'NodeColor', 'black')
set(gca,'visible','off');
