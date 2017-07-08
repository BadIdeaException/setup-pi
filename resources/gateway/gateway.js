#!/usr/bin/env node
var proxy = require('redbird')({ port: 80, bunyan: false });
var fs = require('fs');

function processArgs(argArray) {
	var result = {};
	argArray
		.slice(2) // Cut off the first two parameters (node invocation and this script file as an argument to node)
		.forEach(function(arg) {
			arg = arg.split('='); // Arguments are in the form option=value, split current one into array [option,value]
			result[arg[0]] = arg[1];
		});
}
var args = processArgs(process.argv);


var configpath = '/etc/redbird/sites.d/';


console.log('Starting Redbird based gateway');
console.log('Reading sites from ' + configpath);

fs
	// Read configuration directory
	.readdirSync(configpath)
	// Filter only files with the .site extension
	.filter(function(file) { return file.indexOf('.site') !== 0; })
	// 
	.forEach(function(file) {
		var config = JSON.parse(fs.readFileSync(configpath + '/' + file)); // Load a file
		console.log('Registering site ' + config.domain + ' to be proxied to ' + config.target);
		proxy.register(config.domain, config.target, config.options);
	});