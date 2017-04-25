function [] = graphs_parser()
    fileID = fopen('graphs.txt');
    line = fgets(fileID);
    i = 1;
    while ~isempty(line)
        if i == 204
            
        end
        [attributes, edges, idx] = parse_line(line,1);
        attributes
        i
        i = i + 1;
        line = fgets(fileID);
    end

end

function [matched, idx] = match(character, line, idx)
    if line(idx) == character
        idx = idx+1;
        matched = true;
    else
        matched = false;
    end
end

function [idx] = accept(string, line, idx)
    [matched, idx] = match(string, line, idx);
    if ~matched
        error('Could not accept character.');
    end
end

function [attributes, edges, idx] = parse_line(line, idx)
    idx = accept('{', line, idx);
    [attributes, idx] = parse_attributes(line, idx);
    idx = accept(',', line, idx);
    idx = accept(' ', line, idx);
    [edges, idx] = parse_edges(line, idx);
end

function [attributes, idx] = parse_attributes(line, idx)
    [matched, idx] = match('{', line, idx);
    if matched
        [name, idx] = parse_name(line, idx);
        idx = accept(',', line, idx);
        idx = accept(' ', line, idx);
        [info, idx] = parse_info(line, idx);
        while true
            [matched, idx] = match(',', line, idx);
            if ~matched
                break;
            end
            [~,idx] = parse_info(line,idx);
        end
        idx = accept('}', line, idx);
        attributes = {name; info};
    else
        [name, idx] = parse_name(line, idx);
        attributes = {name};
    end
end

function [name, idx] = parse_name(line, idx)
    indices = regexp(line,'"');
    name = line(indices(1)+1:indices(2)-1);
    idx = indices(2)+1;
end

function [info, idx] = parse_info(line, idx)
    info = [];
    [matched, idx] = match('{', line, idx);
    if matched
        [integer, idx] = parse_integer(line, idx);
        info(end+1,1) = integer;
        while true
            [matched, idx] = match(',', line, idx);
            if ~matched
                break;
            end
            idx = accept(' ', line, idx);
            [integer, idx] = parse_integer(line, idx);
            info(end+1,1) = integer;
        end
        idx = accept('}', line, idx);
    else
        [integer, idx] = parse_integer(line, idx);
        info(end+1,1) = integer;
    end
end

function [edges, idx] = parse_edges(line, idx)
    line = strrep(line(idx:end-1),'{','');
    line = strrep(line,'}','');
    line = strrep(line,',','');
    [A,n] = sscanf(line,'%d');
    edges = reshape(A,2,n/2);
    idx = length(line)-1;
end

% function [edges, idx] = parse_edges(line, idx)
%     edges = cell(length(line),1);
%     cell_idx = 1;
%     idx = accept('{', line, idx);
%     [matched, idx] = match('}', line, idx);
%     if matched
%         return;
%     end
%     [edge, idx] = parse_edge(line, idx);
%     edges{cell_idx} = edge;
%     cell_idx = cell_idx + 1;
%     while true
%         [matched, idx] = match(',', line, idx);
%         if ~matched
%             break;
%         end
%         idx = accept(' ', line, idx);
%         [edge, idx] = parse_edge(line, idx);
%         edges{cell_idx} = edge;
%         cell_idx = cell_idx + 1;
%     end
%     idx = accept('}', line, idx);
% end

function [edge, idx] = parse_edge(line, idx) 
    idx = accept('{', line, idx);
    [integer, idx] = parse_integer(line, idx);
    edge(1) = integer;
    idx = accept(',', line, idx);
    idx = accept(' ', line, idx);
    [integer, idx] = parse_integer(line, idx);
    edge(2) = integer;
    idx = accept('}', line, idx);
end

function [integer, idx] = parse_integer(line, idx)
    [integer,~,~,nextIndex] = sscanf(line(idx:end), '%d');
    idx = idx + nextIndex - 1;
end