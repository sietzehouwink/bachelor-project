function [graphs] = get_test_graphs()
    fileID = fopen('graphs.txt');
    graphs = {};
    while true
        line = fgets(fileID);
        if line == -1
            break;
        end
        
        [digraph, description] = parse_line(line);
        
        struct.description = description;
        struct.digraph = digraph;
        
        graphs{end+1} = struct;
    end
end

function [digraph, description] = parse_line(line)
    description = parse_description(line(2:end));
    digraph = parse_digraph(line(length(description)+2:end));
end

function [description, idx] = parse_description(line)
    idx = 2;
    if line(1) == '"'
        while true
            if line(idx+3) == '{'
                break;
            end
            idx = idx+1;
        end
    else
        cnt_brackets = 1;
        while true
            if line(idx) == '{'
                cnt_brackets = cnt_brackets + 1;
            elseif line(idx) == '}'
                cnt_brackets = cnt_brackets - 1;
            end
            if cnt_brackets == 0
                break;
            end
            idx = idx+1;
        end
    end
    description = line(1:idx);
end

function [digraph_] = parse_digraph(line)
    edges = sscanf(erase(line,{'{','}',','}), '%d', [2,Inf])';
    if isempty(edges)
        digraph_ = digraph();
    else
        digraph_ = digraph(table(edges, 'VariableNames', {'EndNodes'}));
    end
end