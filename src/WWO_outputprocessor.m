function WWO_outputprocessor()
    
    directory = fullfile('..', 'output');

    % load all the files
    [datastruct] = listfiles(directory);
    [datanames] = vertcat(datastruct.name);
    
    % strip the date out and sort them for looping into a table
    [splitnames] = arrayfun(@(x) strsplit(x, '_'), datanames, 'Unif', 0);
    dates = cellfun(@(x) x{1}, splitnames)
    
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
