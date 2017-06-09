function [setting, maximum, timed_out, core_exec_time] = BILP_solver(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout, options)
    if isempty(weight_vector)
        setting = [];
        maximum = 0;
        timed_out = false;
        core_exec_time = 0;
        return;
    end
    
    options = cplexoptimset(options, 'Display', 'off', 'MaxTime', timeout);
    
    timer = tic;
    [setting, minimum, exitflag, ~] = cplexbilp(-weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, [], options);
    core_exec_time = toc(timer);
    
    timed_out = exitflag ~= 1;
    if timed_out
        setting = [];
        maximum = 0; 
        core_exec_time = 0;
        return;
    end
    
    setting = round(setting);
    maximum = -minimum;
end
