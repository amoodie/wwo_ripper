function WWO_ripper()
    %WWO_ripper collects hour location specific data from the WWO historical api.
    %
    % This script is useful for scraping meteorological data from the web 
    % for a single location. Note that the quality or source of data is 
    % unknown, so this approach should be used only if no science-ready 
    % data sources exist.
    %
    % See the readme at GitHub source for complete instructions on use.
    %   https://github.com/amoodie/wwo_ripper
    % 
    % In summary, you must first obtain an API key from the WWO website. 
    % Then, edit the parameters as needed below to set up the API calls.
    % Finally, run this script daily until all data are aquired.
    % The script only saves the raw data, see WWO_outputprocessor.m for how
    % to turn the raw data into useful organized tables.
    %

    
    %% authentication
    apikey_fid = fopen(fullfile('src', 'key.txt'));
    apikey = fgetl(apikey_fid);


    %% load last date
    lastdate_fid = fopen(fullfile('lastdate.txt'));
    lastdate_str = fgetl(lastdate_fid);
    lastdate = str2double(lastdate_str);


    %% parameters
    querylocation = 'dongying+china';
    queryformat = 'json';
    queryinterval = '1';
    pausedur = 4;
    apioptions = weboptions('Timeout', 25);
    baseapi = 'http://api.worldweatheronline.com/premium/v1/past-weather.ashx';


    %% get dates to hit on this script run
    % method to find all missing dates and do the most recent n
    n = 450; % set to 2 for testing, 450 for real running
    datesall = (datenum('2008-01-01'):today-1)';
    [~, fileshave] = listmats(fullfile('..', 'output'));
    [filessplit] = cellfun(@(x) strsplit(x, '_'), fileshave, 'Unif', 0);
    [datestrs] = cellfun(@(x) x{1}, filessplit, 'Unif', 0);
    dateshave = datenum(datestrs);
    dateshave_log = ismember(datesall, dateshave);
    datesdonthave = datesall(~dateshave_log);
    ntoidx = min([n, length(datesdonthave)]);
    dates = datesdonthave(end-ntoidx+1:end);
    

    %% preallocate
    errorlist = {};


    %% loop through the dates
    for d = 1:n
        % determine the date to make the call for
        thedate = dates(d);
        thedateform = datestr(thedate, 'YYYY-mm-dd');

        % format the api call and make the call    
        apicall = [baseapi, '?', 'key=', apikey, '&', 'q=', querylocation, '&', 'date=', thedateform, '&',  'tp=', queryinterval, '&', 'format=', queryformat];
        disp(['making api call for ' thedateform])
        try
            % make the api call with webread
            apiresult = webread(apicall, apioptions);
            disp('api call success')

            % save the api result to file without processing
            save(fullfile('..', 'output', [thedateform, '_weather', '.mat']), 'apiresult')
        catch
            apiresult = [];
            warning(['ERROR COLLECTING FOR DATE: ' thedateform '\n No file created.'])
            errorlist(end+1,1) = {thedateform};
        end

        % pause before next call
        pause(pausedur)

    end

    
    %% print out errored
    if ~isempty(errorlist)
        disp('Error collection for dates:')
        for e = 1:length(errorlist)
            disp(errorlist{e})
        end
    end


    %% update the lastdate file
    fclose(lastdate_fid);
    lastdate_fid = fopen(fullfile('lastdate.txt'), 'w');
    fprintf(lastdate_fid, '%d', lastdate_new);
    fclose(lastdate_fid);

    
end
