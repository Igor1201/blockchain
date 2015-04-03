Package.describe({
	name: 'borges:blockchain',
	version: '0.1.2',
	summary: 'A simple NPM wrapper of Blockchain\'s Official API Library for Meteor',
	git: 'https://github.com/Igor1201/blockchain'
});

Npm.depends({
	"blockchain.info": "1.3.1",
	"url": "0.10.3"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0.5');
	api.use('coffeescript');
	api.use('underscore');
	api.use('meteorhacks:async@1.0.0');
	api.use('iron:router@1.0.5');
	api.addFiles('server.coffee', 'server');
	api.export('Blockchain', 'server');
});
