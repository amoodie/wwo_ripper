function WWO_outputprocessor()
    %WWO_outputprocessor churns through the downloaded API calls and produces tables
    %
    % This script simply loops through every file in output folder and makes
    % daily and hourly tables of all of the data in the API call.
    %
    
    %% get the file information to loop through
    % directory of the raw dl files
    directory = fullfile('..', 'output');

    % load all the files
    [datastruct] = listmats(directory);
    [datanames] = vertcat({datastruct.name});
    
    % strip the date out and sort them for looping into a table
    [splitnames] = cellfun(@(x) strsplit(x, '_'), datanames, 'Unif', 0);
    dates = cellfun(@(x) x{1}, splitnames, 'Unif', 0);
    datesnum = cellfun(@(x) datenum(x), dates);
    [~, sortidx] = sort(datesnum);
    
    %% make the daily data table
    % one row per day
    daydata = [];
    datalist = datanames(sortidx);
    for d = 1:length(datalist)
        % load the day's raw data file
        ddata_raw = load(fullfile('..', 'output', datalist{d}));
        
        % extract only the weather (exlude apirequest info)
        ddata = ddata_raw.apiresult.data.weather;
        
        % convert to a table (and numerics)
        dayrow_raw = make_datatable(ddata);
        
        % add datetime numeric variable
        dayrow_raw.Properties.VariableNames(strcmp('date', dayrow_raw.Properties.VariableNames)) = {'datetimestr'};
        daydatetime = array2table(datenum(dayrow_raw.datetimestr), 'VariableNames', {'datetime'});
        dayrow = horzcat(daydatetime, dayrow_raw);
        
        % vertcat it into a big table
        daydata = vertcat(daydata, dayrow);
        
        % print progress
        disp(['processed the ', num2str(d), 'th day'])
    end
    
    % save the daydata to a mat file
    save(fullfile('..', 'clean', 'daydata.mat'), 'daydata')
    
    % also save a version that does not have hourly data within (for size)
    hourly = daydata.hourly;
    daydata.hourly = [];
    save(fullfile('..', 'clean', 'daydata_nohourly.mat'), 'daydata')
    
    %% make the hourly table
    % make the data into one really long hourly table
    hourdata = [];
    for d = 1:size(daydata, 1)
        % get the raw hourly from the daydata table
        hdata_raw = hourly{d};
        
        % convert to a table (and numerics)
        hdata_table = make_datatable(hdata_raw);
        
        % manually create a datetime and delete the old time objs
        man_datetime = repmat(daydata.datetime(d), size(hdata_table, 1), 1) + (hdata_table.time / 2400);
        hdata_times = array2table(man_datetime, 'VariableNames', {'datetime'});
        hdata_times.datetimestr = datestr(hdata_times.datetime, 'YYYY-mm-dd HH:MM');
        hdata_table.time = [];
        
        % vertcat it into a big table
        hdata_day = horzcat(hdata_times, hdata_table);
        hourdata = vertcat(hourdata, hdata_day);
        
        % print progress
        disp(['processed the ', num2str(d), 'th day'])
    end
    
    % save the hourdata to a mat file
    save(fullfile('..', 'clean', 'hourdata.mat'), 'hourdata')
    
end


function [data_table] = make_datatable(data_raw)
    %make_datatable converts the raw data into a table
    %
    % function also attempts to convert each field in the raw 
    % structure to numeric
    %
    
    fields = fieldnames(data_raw);
    data_table = table();
    
    % remove misconverted field from loop-list but put in final
    if ismember('date', fields)
        fields = fields(~strcmp('date', fields));
        data_table.date = data_raw.date;
    end
    
    for f = 1:length(fields)
        thefield = fields{f};
        thedata = horzcat({data_raw.(thefield)});
        try
            thedatanumeric = cellfun(@str2num, thedata)';
            % disp(['converted field "', thefield, '"'])
            data_table.(thefield) = thedatanumeric;
        catch
            % warning(['nonnumeric field: "', thefield, '" not converted'])
            data_table.(thefield) = thedata';
        end
    end
    
end

