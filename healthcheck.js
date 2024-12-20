var http = require('http');
var https = require('https');
var request;

process.env["NODE_TLS_REJECT_UNAUTHORIZED"] = 0;

const default_settings_path = '/node-red/settings/settings.js'
var settings_path = default_settings_path;
if ( process.env.hasOwnProperty("SettingsJSPath") ) {
    settings_path = process.env["SettingsJSPAth"];
}

if ( ! require('fs').existsSync(settings_path) ) {
    process.exit(1);
}

var settings = require(settings_path);
var options = {
    host : "127.0.0.1",
    port : settings.uiPort || 1880,
    timeout : 4000
};

if (settings.hasOwnProperty("https")) {
    request = https.request(options, (res) => {
        //console.log(`STATUS: ${res.statusCode}`);
        if ((res.statusCode >= 200) && (res.statusCode < 500)) { process.exit(0); }
        else { process.exit(1); }
    });
}
else {
    request = http.request(options, (res) => {
        //console.log(`STATUS: ${res.statusCode}`);
        if ((res.statusCode >= 200) && (res.statusCode < 500)) { process.exit(0); }
        else { process.exit(1); }
    });
}

request.on('error', function(err) {
    //console.log('ERROR',err);
    process.exit(1);
});

request.end(); 
