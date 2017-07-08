#!/usr/bin/env node
var proxy = require('redbird')({ port: 80, bunyan: false });
var fs = require('fs');

// Process command line arguments from the original array form into a hash of the form option: value
var args = function processArgs(argArray) {
	var result = {};
	argArray
		.slice(2) // Cut off the first two parameters (node invocation and this script file as an argument to node)
		.forEach(function(arg) {
			arg = arg.split('='); // Arguments are in the form option=value, split current one into array [option,value]
			result[arg[0]] = arg[1];
		});
	return result;
}(process.argv);

var sitepath = '/etc/redbird/sites.d/' || args['sitepath']; // Override default site path from command line
if (!sitepath.endsWith('/')) { sitepath += '/' };


console.log('Redbird based gateway\n');

// Print help text if run with --help
if (args.hasOwnProperty('help')) {
	console.log(
		'You can specify the following command line options: \n' + 
		'    --sitepath=PATH        Read site definitions from PATH instead of standard /etc/redbird/sites.d\n' +
		'    --help                 Display this help message'
	);
}

console.log('Reading sites from ' + sitepath);

fs
	// Read configuration directory
	.readdirSync(sitepath)
	// Filter only files with the .site extension
	.filter(function(file) { return file.indexOf('.site') !== 0; })
	// 
	.forEach(function(file) {
		var config = JSON.parse(fs.readFileSync(sitepath + file)); // Load a file
		console.log('Registering site ' + config.domain + ' to be proxied to ' + config.target);
		proxy.register(config.domain, config.target, config.options);
	});