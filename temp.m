load('digraphs');
digraph_ = digraphs{1};

% n = 2000;
% digraph_ = get_random_digraph(n,n*(n-1));

profile off
profile on
cycles = find_cycles(digraph_, 1:numnodes(digraph_), 2,2,10);
profile viewer

celldisp(cycles)