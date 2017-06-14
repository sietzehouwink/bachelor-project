clear global;
clear variables;
rng('shuffle');
format long g

target_time = 1;
timeout_other = 8;

nr_measurements = 5;


% solver = @(digraph_) unrestricted_edge_bipartite_solver(digraph_, target_time, cplexoptimset);
% min_nr_nodes = 450;
% max_nr_nodes = 2000;
% nr_samples_nr_nodes = 30;

% solver = @(digraph_) unrestricted_edge_digraph_solver(digraph_, target_time, cplexoptimset);
% min_nr_nodes = 200;
% max_nr_nodes = 1000;
% nr_samples_nr_nodes = 30;

% solver = @(digraph_) restricted_edge_paths_solver(digraph_, 2, Inf, target_time, cplexoptimset);
% min_nr_nodes = 25;
% max_nr_nodes = 600;
% nr_samples_nr_nodes = 30;

% solver = @(digraph_) restricted_edge_cycles_chains_solver(digraph_, 2, 0, Inf, target_time, cplexoptimset);
% min_nr_nodes = 7;
% max_nr_nodes = 25;
% nr_samples_nr_nodes = 19;

% solver = @(digraph_) restricted_cycle_chain_solver(digraph_, 2, 0, Inf, target_time, cplexoptimset);
% min_nr_nodes = 370;
% max_nr_nodes = 3500;
% nr_samples_nr_nodes = 30;


samples_nr_nodes = round(linspace(min_nr_nodes, max_nr_nodes, nr_samples_nr_nodes));
samples_match_probability = linspace(max_match_probability, min_match_probability, nr_samples_match_probability);

visited_nr_nodes = [];
visited_match_probability = [];

index_nr_nodes = 1;
index_match_probability = 1;
while index_nr_nodes <= nr_samples_nr_nodes && index_match_probability <= nr_samples_match_probability
    nr_nodes = samples_nr_nodes(index_nr_nodes);
    match_probability = samples_match_probability(index_match_probability);
    
    for index_measurement = 1:nr_measurements
        digraph_ = digraph(rand(nr_nodes) <= match_probability, 'OmitSelfLoops');
        digraph_.Edges.Weight = repelem(1,numedges(digraph_),1);
        digraph_.Nodes.AgentType = repelem({'trader'},numnodes(digraph_),1);
        
        [~, ~, timed_out, ~] = solver(digraph_);
        
        if timed_out
            break;
        end
    end
    
    visited_nr_nodes(end+1) = nr_nodes;
    visited_match_probability(end+1) = match_probability;
    
    if timed_out
        index_match_probability = index_match_probability + 1;
    else
        index_nr_nodes = index_nr_nodes + 1;
    end   
end

figure;
plot(visited_nr_nodes, visited_match_probability);
xlim([0 Inf]);
ylim([0 1]);
