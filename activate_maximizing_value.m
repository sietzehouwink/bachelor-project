function [activated, maximum, timed_out] = activate_maximizing_value(weight_vector, inequality_matrix, inequality_vector, equality_matrix, equality_vector, timeout)
    nr_variables = size(weight_vector, 1);
    
    if nr_variables == 0
        activated = [];
        maximum = 0;
        timed_out = false;
        return;
    end
    
    to_integer_restricted_bitmap = ones(nr_variables,1);
    lowerbound_vector = zeros(nr_variables,1);
    upperbound_vector = ones(nr_variables,1);
    options = optimoptions('intlinprog', 'Display', 'none', 'MaxTime', timeout);
    
    [activated_bitmap, minimum, exitflag, ~] = intlinprog(-weight_vector, to_integer_restricted_bitmap, inequality_matrix, inequality_vector, equality_matrix, equality_vector, lowerbound_vector, upperbound_vector, options);
    
    timed_out = exitflag <= 0;
    if timed_out
        activated = [];
        maximum = 0;
        return;
    end
    
    activated = find(activated_bitmap);
    maximum = -minimum;
end
