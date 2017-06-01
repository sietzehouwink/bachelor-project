function [] = get_significant_settings(digraphs, solver)
    settings = {{'BranchRule' {'maxpscost' 'mostfractional' 'maxfun'}} ...
               {'CutGeneration' {'none' 'basic' 'intermediate' 'advanced'}} ...
               {'Heuristics' {'rss' 'rins' 'round' 'diving' 'rss-diving' 'rins-diving' 'round-diving' 'none'}} ...
               {'IntegerPreprocess' {'none' 'basic' 'advanced'}} ...
               {'LPPreprocess' {'none' 'basic'}} ...
               {'NodeSelection' {'simplebestproj' 'minobj' 'mininfeas'}} ...
               {'RootLPAlgorithm' {'dual-simplex' 'primal-simplex'}}};

    optimoptions_ = optimoptions('intlinprog');
    [~, ~, timed_outs_default, core_exec_times_default] = evaluate_solver_for_digraphs(digraphs, @(digraph) solver(digraph, optimoptions_)); 
    
    for setting_index = 1:length(settings)
        option = settings{setting_index}{1};
        choices = settings{setting_index}{2};
        for choice_index = 1:length(choices)
            choice = choices{choice_index};
            
            optimoptions_ = optimoptions('intlinprog', option, choice);
            [~, ~, timed_outs, core_exec_times] = evaluate_solver_for_digraphs(digraphs, @(digraph) solver(digraph, optimoptions_));
            
            not_timed_out = ~ (timed_outs_default | timed_outs);
            decision = ttest(core_exec_times_default(not_timed_out), core_exec_times(not_timed_out), 'Tail', 'right');
            
            if decision == 1
                option
                choice
            end
        end
    end
end
