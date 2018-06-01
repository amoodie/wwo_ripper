function [datastruct, filenames] = listmats(directory)
    %listfiles loads a list of all names
    
    % get the directory listing and identify the .mat files
    [listing] = dir(directory); % all items in directory
    listing(ismember( {listing.name}, {'.', '..'})) = [];  % dont want . or ..
    [filesBool] = ~[listing.isdir]; % logical of files only
    [listing] = listing(filesBool);
    [listingnames] = arrayfun(@(x) x.name, listing, 'Unif', 0);
    [ismat] = cellfun(@(x) contains(x, '.mat'), listingnames);
    [datastruct] = listing(ismat);
    [filenames] = vertcat({datastruct.name});
    
end