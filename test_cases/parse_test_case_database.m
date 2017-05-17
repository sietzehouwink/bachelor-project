function [digraphs, descriptions] = parse_test_case_database()
    fileID = fopen('test_case_database.txt');
    digraphs = {};
    descriptions = {};
    while true
        line = fgets(fileID);
        if line == -1
            break;
        end
        
        [digraph, description] = parse_line(line);
        digraphs{end+1,1} = digraph;
        descriptions{end+1,1} = description;
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
        digraph_ = digraph(edges(:,1), edges(:,2), 1);
        digraph_.Nodes.AgentType = repmat({'trader'}, numnodes(digraph_), 1);
    end
end