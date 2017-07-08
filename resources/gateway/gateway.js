#!/usr/bin/env node
var fs = require('fs');

// Process command line arguments from the original array form into a hash of the form option: value
var args = function processArgs(argArray) {
	var result = {};
	argArray
		.slice(2) // Cut off the first two parameters (node invocation and this script file as an argument to node)
		.forEach(function(arg) {
			arg = arg.split('='); // Arguments are in the form option=value, split current one into array [option,value]
			if (arg[0].startsWith('--')) { arg[0] = arg[0].slice(2); } // Cut off the -- at the beginning of the argument
			result[arg[0]] = arg[1];
		});
	return result;
}(process.argv);

// Print help text if run with --help
if (args.hasOwnProperty('help')) {
	console.log(
		'You can specify the following command line options: \n' + 
		'\n' + 
		'    --sitepath=PATH        Read site definitions from PATH instead of standard /etc/redbird/sites.d\n' +
		'    --debug                Output bunyan debug information that is normally suppressed\n' + 
		'    --help                 Display this help message'
	);
	process.exit();
}

var sitepath = args['sitepath'] || '/etc/redbird/sites.d/'; // Override default site path from command line
if (!sitepath.endsWith('/')) { sitepath += '/' }; // Make sure there's a trailing slash

var config = JSON.parse(fs.readFileSync(args['config'] || '/etc/redbird/redbird.conf')); // Read configuration from default or overridden config file
//config.bunyan = (config.bunyan || args.hasOwnProperty('debug') && { name: 'gateway' } || false; // Default bunyan logging to false unless specifically overridden in config or by command line

console.log(
	'Redbird based gateway\n' + 
	'\n' +
	'Reading sites from ' + sitepath
);

var proxy = require('redbird')(config);


// Core of this script: Read site definitions and register them as proxy routes
fs
	// Read sites directory
	.readdirSync(sitepath)
	// Filter only files with the .site extension
	.filter(function(file) { return file.indexOf('.site') !== 0; })
	// 
	.forEach(function(file) {
		var config = JSON.parse(fs.readFileSync(sitepath + file)); // Load a file
		console.log('Registering site ' + config.domain + ' to be proxied to ' + config.target);
		proxy.register(config.domain, config.target, config.options);
	});