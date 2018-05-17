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
    
    % make the data into one really long hourly table
    
    
    
    % I have made some convenience functions for manipulating the data, they are located in bin/
    %       [subset] = daterange(table, start, end)
    
    
    
    
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
