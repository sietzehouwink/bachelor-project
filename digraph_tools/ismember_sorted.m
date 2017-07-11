function [result] = ismember_sorted(a, b)
    result = false(length(a), 1);
    i = 1;
    j = 1;
    while i <= length(a) && j <= length(b)
        if a(i) == b(j)
            result(i) = true;
            i = i + 1;
        elseif a(i) > b(j)
            j = j + 1;
        else
            i = i + 1;
        end
    end
end

