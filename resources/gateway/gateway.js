#!/usr/bin/env node
var proxy = require('redbird')({ port: 80 });
var fs = require('fs');

var configpath = '/etc/redbird/sites.d/';

console.log('Reading from ' + configpath);

fs
	// Read configuration directory
	.readdirSync(configpath)
	// Filter only files with the .site extension
	.filter(function(file) { return file.indexOf('.site') !== 0; })
	// 
	.forEach(function(file) {
		var config = require(configpath + '/' + file); // Load a file
		console.log('Registering site ' + config.domain + ' to be routed to ' + config.target);
		proxy.register(config.domain, config.target, config.options);
	});