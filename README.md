# wwo ripper

Matlab scripts for ripping historical meteorological data for a location


## What is the program?

There are two main functions to this program.
The first `wwo_ripper.m` makes API calls to the [WWO Local Historical API](https://developer.worldweatheronline.com/api/historical-weather-api.aspx), and the second `wwo_outputprocessor.m` creates usable tabularized data for the user from the API call returns.

![demo image](./private/example_plot.png "exampleplot")
_Hourly precipitation data at Dongying, China._



## Getting started

### Download the program

To use the program you should begin by downloading the program source either as a `.zip` by clicking the "Clone or download button on this page", or by [clicking here](https://github.com/amoodie/wwo_ripper/archive/master.zip).
Unzip the folder in your preferred location.
Alternatively, you can use `git` and

```
git clone https://github.com/amoodie/wwo_ripper.git
```

__NOTE:__ if you use this program and make changes you think are beneficial, please don't hesitate to open a pull request :)


### Running the program

#### collecting the data

First, you will need to obtain an API key from the [WWO website by signing up](https://developer.worldweatheronline.com/signup.aspx) for an account.
This will give you an API key, which will be a 31 alphanumeric string.
This string needs to be placed on the first line of a file which you will create at `src/key.txt` (the key should be the only thing in the file).

Now you can open the file `wwo_ripper.m` in your Matlab session (note that the script was written on 2017b).
Edit the section called `parameters` and change as needed. 
See the [API documentation online](https://developer.worldweatheronline.com/api/docs/historical-weather-api.aspx) for information on what options you have available.

You can now run the script, which will collect 450 of the most recent dates, which you do not already have collected in the `output` folder.
In this way, the script can be run daily to collect more and more historical data.

#### processing the data

The second script `wwo_outputprocessor.m` will loop through every file in the `output` folder and make "daily" and "hourly" tables of all of the data collected in the API call.
The tables are then saved into the `clean` folder.



## Disclaimers

### Data quality disclaimer

It is important to note that the quality or source of data provided through the WWO API is unknown.
There is no readily identifiable information about the source or how the data were collected. 
Therefore, this approach should be used only if no alternative high-quality data sources exist.


### Legal disclaimers

Every attempt has been made to keep the functionality of this program completely within the terms outlined in the [WWO API Terms and Conditions](https://developer.worldweatheronline.com/api/api-t-and-c.aspx).
Specifically, the API T+C state:

> World Weather Online grants you the right to access, use, and view the standard (free) Services, together with any Premium Services for which you have subscribed and agreed to pay the applicable subscription fees, You may access, view and make copies of the data in the API for your personal or commercial use, including making the data in the API available in online and/or mobile applications/services (a single API key/subscription may be used in respect of one online or mobile application/service only – e.g. iSuite online) which are, as applicable, sold or resold by you or your group companies or other third parties authorised by you (‘Representatives’). If you are Free API user then for all uses of the data, you will credit World Weather Online by name or brand logo as the source of the data. You may not transfer your access privileges or disclose your password to any third party. World Weather Online reserves the right to modify or terminate any of the Services at any time. You agree not to sell our weather data to any third party. As a condition of your use of the Services, you warrant to World Weather Online that you will not use the Services for any purpose that is unlawful or prohibited by these Terms and Conditions. If you violate any of these Terms and Conditions, your authorization to use the Services automatically terminates and you must immediately destroy any downloaded or printed materials.

__Importantly, if you use the data from the WWO you must cite them as such!!__

I believe this program is in compliance with the T+C because of the following line:

    You may access, view and make copies of the data in the API for your personal or commercial use

    

## Authors

* Andrew J. Moodie
