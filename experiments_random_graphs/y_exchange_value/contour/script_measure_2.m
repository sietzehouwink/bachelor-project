clear global;
clear variables;
load('/Users/sietzehouwink/Documents/bachelor-project/experiments_random_graphs/random_matrix.mat')


solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, 3, 3, cplexoptimset);
target = 0.95;
nr_refinement_steps = 3;
min_nr_nodes = 1;
max_nr_nodes = 1200;
min_match_probability = 0.05;
max_match_probability = 1;

% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, Inf, cplexoptimset);
% target = 0.05;
% nr_refinement_steps = 5;
% min_nr_nodes = 1;
% max_nr_nodes = 20;
% min_match_probability = 0.05;
% max_match_probability = 1;

resolution = 2;
to_visit = true(resolution);
for refinement_step = 1:nr_refinement_steps
    samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, resolution));
    samples_match_probability = linspace(min_match_probability, max_match_probability, resolution);
    
    exchange_values = NaN(resolution);
    for index_match_probability = 1:resolution
        match_probability = samples_match_probability(index_match_probability);
        for index_nr_nodes = 1:resolution
            nr_nodes = samples_nr_nodes(index_nr_nodes);        
            
            if ~to_visit(index_match_probability, index_nr_nodes)
                continue;
            end
            
            adjacency_matrix = random_matrix(1:nr_nodes, 1:nr_nodes) <= match_probability;
            digraph_ = digraph(adjacency_matrix, 'OmitSelfLoops');
            digraph_.Edges.Weight = repelem(1, numedges(digraph_), 1);
            digraph_.Nodes.AgentType = repelem({'trader'}, numnodes(digraph_), 1);

            [~, exchange_value, timed_out, ~] = solver(digraph_);
            if timed_out
                exchange_values(index_match_probability, index_nr_nodes) = 1;
                continue;
            end
            exchange_values(index_match_probability, index_nr_nodes) = exchange_value / nr_nodes;
        end
    end

    to_visit(imerode(exchange_values > target | isnan(exchange_values), ones(3))) = false;
    to_visit(imerode(exchange_values < target | isnan(exchange_values), ones(3))) = false;
    to_visit = repelem(to_visit,2,2);
    to_visit = imerode(to_visit,ones(2));
    to_visit = to_visit(1:end-1,1:end-1);
    resolution = 2 * resolution - 1;
end

contour(samples_nr_nodes, samples_match_probability, exchange_values, [target target])