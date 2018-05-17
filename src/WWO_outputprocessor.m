function WWO_outputprocessor()
    
    directory = fullfile('..', 'output');

    % load all the files
    [datastruct] = listfiles(directory);
    [datanames] = vertcat({datastruct.name});
    
    % strip the date out and sort them for looping into a table
    [splitnames] = cellfun(@(x) strsplit(x, '_'), datanames, 'Unif', 0);
    dates = cellfun(@(x) x{1}, splitnames, 'Unif', 0);
    datesnum = cellfun(@(x) datenum(x), dates);
    [sortlist, sortidx] = sort(datesnum);
    
    % make the table with one row per day first
    daydata = [];
    datalist = datanames(sortidx);
    for d = 1:length(datalist)
        ddata_raw = load(fullfile('..', 'output', datalist{d}));
        ddata = ddata_raw.apiresult.data.weather;
        dayrow = struct2table(ddata, 'asarray', 1);
        daydata = vertcat(daydata, dayrow);
    end
    % save the data to a mat file?
    
    % make the data into one really long hourly table
    hourdata = [];
    for d = 1:size(daydata, 1)
        hdata_raw = daydata.hourly{d};
        hdata_table = struct2table(hdata_raw, 'asarray', 1);
        hdata_date = repmat(string(daydata.date{d}), size(hdata_table, 1), 1);
        hdata_table.time = datestr(cellfun(@(x) str2num(x)/2400, hdata_table.time));
        hdata_table = maketablenumeric(hdata_table);
        
        hdata_man = array2table(date, 'VariableNames', {'date'})
        hourdata = vertcat(hourdata, a)
    end
    
    
    % I have made some convenience functions for manipulating the data, they are located in bin/
    %       [subset] = daterange(table, start, end)
    
    
    
    
end

function [table] = maketablenumeric(table)
    %maketablenumeric attempts to convert each column in the table to numeric
    %
    
    for c = 1:size(table, 2)
        for r = 1:size(table, 1)
            try
%                 asarray = str2num(cell2mat(table{:,c}));
%                 table{:, c} = asarray;
                table{r, c} = {str2double(table{r, c})};
                j=1;
            catch

            end
        end
    end
end



function [datastruct] = listfiles(directory)
    %listfiles loads a list of all names
    
    % get the directory listing and identify the .mat files
    listing = dir(directory); % all items in directory
    listing(ismember( {listing.name}, {'.', '..'})) = [];  % dont want . or ..
    filesBool = ~[listing.isdir]; % logical of files only
    listing = listing(filesBool);
    listingnames = arrayfun(@(x) x.name, listing, 'Unif', 0);
    ismat = cellfun(@(x) contains(x, '.mat'), listingnames);
    datastruct = listing(ismat);
    
end
