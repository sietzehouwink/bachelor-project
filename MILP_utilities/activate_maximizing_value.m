function [activated, maximum, timed_out, core_exec_time] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout, optimoptions_)
    nr_variables = size(weight_vector, 1);
    
    if nr_variables == 0
        activated = [];
        maximum = 0;
        timed_out = false;
        core_exec_time = 0;
        return;
    end
    
    options = cplexoptimset('Display', 'off', 'MaxTime', timeout);
    
    timer = tic;
    [activated_bitmap, minimum, exitflag, ~] = cplexbilp(-weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, [], options);
    core_exec_time = toc(timer);

    timed_out = exitflag ~= 1;
    if timed_out
        activated = [];
        maximum = 0; 
        core_exec_time = 0;
        return;
    end
    
    activated = find(activated_bitmap);
    maximum = round(-minimum);
end
