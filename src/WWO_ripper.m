function WWO_ripper()
% this script will download the data from WWO

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
pausedur = 5;
baseapi = 'http://api.worldweatheronline.com/premium/v1/past-weather.ashx';


%% get dates to hit on this script run
n = 100; % set to 2 for testing, 490 for real running
lastdate_new = lastdate-n;
dates = lastdate-1:-1:lastdate_new;


%% preallocate 
errorlist = [];


%% loop through the dates
for d = 1:n
    % determine the date to make the call for
    thedate = dates(d);
    thedateform = datestr(thedate, 'YYYY-mm-dd');
    
    % format the api call and make the call    
    apicall = [baseapi, '?', 'key=', apikey, '&', 'q=', querylocation, '&', 'date=', thedateform, '&',  'tp=', queryinterval, '&', 'format=', queryformat];
    disp(['making api call for ' thedateform])
    try
        apiresult = webread(apicall);
    catch
        apiresult = [];
        warning(['ERROR COLLECTING FOR DATE: ' thedateform])
        errorlist(end+1) = {thedateform};
    end
    
    % save the api result to file without processing
    save(fullfile('..', 'output', [thedateform, '_weather', '.mat']), 'apiresult')
    
    % pause before next call
    pause(pausedur)
    
end

%% print out errored
disp('Error collection for dates:')
for e = 1:length(errorlist)
    disp(errorlist{e})
end


%% update the lastdate file
fclose(lastdate_fid);
lastdate_fid = fopen(fullfile('lastdate.txt'), 'w');
fprintf(lastdate_fid, '%d', lastdate_new);
fclose(lastdate_fid);

end


function [str] = format_apicall(baseapi, key, q, varargin)
    % format to a proper api call
    % requires baseapi string, key, and location (q)
    % takes the supported fields (see below) as options
    
    ip = inputParser();
    addRequired(ip, 'baseapi', @ischar);
    addRequired(ip, 'key', @ischar);
    addRequired(ip, 'q', @ischar);
    addParameter(ip, 'date', @ischar);
    addParameter(ip, 'tp', @ischar);
    addParameter(ip, 'format', @ischar);
    
    parse(ip, baseapi, key, q, varargin{:});
    
%     a = p.Results.width*p.Results.height; 

%     str = [ip.Results.baseapi
end