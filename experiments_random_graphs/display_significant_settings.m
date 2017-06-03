function [] = display_significant_settings(digraphs, solver)
    settings = {{'BranchRule' {'maxpscost' 'mostfractional' 'maxfun'}} ...
               {'CutGeneration' {'none' 'basic' 'intermediate' 'advanced'}} ...
               {'Heuristics' {'rss' 'rins' 'round' 'diving' 'rss-diving' 'rins-diving' 'round-diving' 'none'}} ...
               {'IntegerPreprocess' {'none' 'basic' 'advanced'}} ...
               {'LPPreprocess' {'none' 'basic'}} ...
               {'NodeSelection' {'simplebestproj' 'minobj' 'mininfeas'}} ...
               {'RootLPAlgorithm' {'dual-simplex' 'primal-simplex'}}};
    nr_choices = sum(cellfun(@(setting) length(setting{2}), settings));
    
    overall_index_choice = 0;
    waitbar_ = waitbar(overall_index_choice, 'display significant settings');
    
    optimoptions_ = optimoptions('intlinprog');
    [~, ~, timed_outs_default, core_exec_times_default] = evaluate(digraphs, @(digraph) solver(digraph, optimoptions_)); 
    
    overall_index_choice = overall_index_choice + 1;
    waitbar(overall_index_choice/(nr_choices+1), waitbar_);
    
    
    for index_setting = 1:length(settings)
        option = settings{index_setting}{1};     
        choices = settings{index_setting}{2};
        for index_choice = 1:length(choices)
            choice = choices{index_choice};
            
            optimoptions_ = optimoptions('intlinprog', option, choice);
            [~, ~, timed_outs, core_exec_times] = evaluate(digraphs, @(digraph) solver(digraph, optimoptions_));
            
            not_timed_out = ~ (timed_outs_default | timed_outs);
            [decision, p_value] = ttest(core_exec_times_default(not_timed_out), core_exec_times(not_timed_out), 'Tail', 'right');           

            if decision == 1
                fprintf('option: %s, choice: %s, p-value %d', option, choice, p_value);
            end
            
            overall_index_choice = overall_index_choice + 1;
            waitbar(overall_index_choice/(nr_choices+1), waitbar_);
        end
    end
    
    delete(waitbar_)
end



