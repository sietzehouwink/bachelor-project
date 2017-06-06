load('digraphs')
d = digraphs{1};
adj = adjacency(d);


cycles = {1};
for i = 1:5
    cycles = cellfun(@(cycle) arrayfun(@(adj) [cycle adj], find(adj(cycle(end),:)), 'UniformOutput', false), cycles, 'UniformOutput', false);
    cycles = horzcat(cycles{:});
end