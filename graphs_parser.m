function [] = graphs_parser()
    fileID = fopen('graphs.txt');
    line = fgets(fileID);
    i = 1;
    while ~isempty(line)
        [attributes, edges, remaining_string] = parse_line(line);
        attributes
        i
        i = i + 1;
        line = fgets(fileID);
    end

end

function [matched, line] = match(character, line)
    if line(1) == character
        line = line(2:end);
        matched = true;
    else
        matched = false;
    end
end

function [line] = accept(string, line)
    [matched, line] = match(string, line);
    if ~matched
        error('Could not accept character.');
    end
end

function [attributes, edges, line] = parse_line(line)
    line = accept('{', line);
    [attributes, line] = parse_attributes(line);
    line = accept(',', line);
    line = accept(' ', line);
    [edges, line] = parse_edges(line);
    line = accept('}', line);
end

function [attributes, line] = parse_attributes(line)
    [matched, line] = match('{', line);
    if matched
        [name, line] = parse_name(line);
        line = accept(',', line);
        line = accept(' ', line);
        [info, line] = parse_info(line);
        line = accept('}', line);
        attributes = {name; info};
    else
        [name, line] = parse_name(line);
        attributes = {name};
    end
end

function [name, line] = parse_name(line)
    indices = regexp(line,'"');
    name = line(indices(1)+1:indices(2)-1);
    line = line(indices(2)+1:end);
end

function [info, line] = parse_info(line)
    info = [];
    [matched, line] = match('{', line);
    if matched
        [integer, line] = parse_integer(line);
        info(end+1,1) = integer;
        while true
            [matched, line] = match(',', line);
            if ~matched
                break;
            end
            line = accept(' ', line);
            [integer, line] = parse_integer(line);
            info(end+1,1) = integer;
        end
        line = accept('}', line);
    else
        [integer, line] = parse_integer(line);
        info(end+1,1) = integer;
    end
end

function [edges, line] = parse_edges(line)
    edges = {};
    line = accept('{', line);
    [matched, line] = match('}', line);
    if matched
        return;
    end
    [edge, line] = parse_edge(line);
    edges{end+1} = edge;
    while true
        [matched, line] = match(',', line);
        if ~matched
            break;
        end
        line = accept(' ', line);
        [edge, line] = parse_edge(line);
        edges{end+1} = edge;
    end
    line = accept('}', line);
end

function [edge, line] = parse_edge(line) 
    line = accept('{', line);
    [integer, line] = parse_integer(line);
    edge(1) = integer;
    line = accept(',', line);
    line = accept(' ', line);
    [integer, line] = parse_integer(line);
    edge(2) = integer;
    line = accept('}', line);
end

function [integer, line] = parse_integer(line)
    [integer,~,~,nextIndex] = sscanf(line, '%d');
    line = line(nextIndex:end);
end