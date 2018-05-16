function WWO_ripper()
% this script will download the data from WWO

%% authentication
apikey_fid = fopen(fullfile('src', 'key.txt'));
apikey = fgetl(apikey_fid);


%% load last date
lastdate_fid = fopen(fullfile('src', 'lastdate.txt'));
lastdate_str = fgetl(lastdate_fid);
lastdate = str2double(lastdate_str);


%% parameters
querylocation = 'dongying+china';
queryformat = 'json';
queryinterval = '1';
pausedur = 1.5;
baseapi = 'http://api.worldweatheronline.com/premium/v1/past-weather.ashx';


%% get dates to hit on this script run
n = 0; % set to 2 for testing, 490 for real running
lastdate_new = lastdate-n-1;
dates = lastdate-1:-1:lastdate_new;


%% loop through the dates
for d = 1:n
    thedate = dates(d);
    thedateform = datestr(thedate, 'YYYY-mm-dd');
    
%     format_apicall(baseapi, apikey, querylocation, 'date', thedateform, 'tp', queryinterval, 'format', queryformat)
%     '?key=<redacted>&q=dongying+china&date=2017-01-01&tp=1&format=json'
    
    apicall = [baseapi, '?', 'key=', apikey, '&', 'q=', querylocation, '&', 'date=', thedateform, '&',  'tp=', queryinterval, '&', 'format=', queryformat];
    apiresult = webread(apicall);
    
    save(fullfile('..', 'output', [thedateform, '_weather', '.mat']), 'apiresult')
    
    pause(pausedur)
end


%% update the lastdate file
fclose(lastdate_fid);
lastdate_fid = fopen(fullfile('src', 'lastdate.txt'), 'w');
fprintf(lastdate_fid, '%d', lastdate_new)

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