load('digraphs');
i = 11;
plot(digraphs{i}, 'NodeLabel', digraphs{i}.Nodes.AgentType)
set(gca,'visible','off');