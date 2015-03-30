Package.describe({
	name: 'borges:blockchain',
	version: '0.0.1',
	summary: 'A simple NPM wrapper of Blockchain\'s Official API Library for Meteor',
	git: 'https://github.com/Igor1201/blockchain'
});

Npm.depends({
	"blockchain.info": "1.3.1"
});

Package.onUse(function(api) {
	api.versionsFrom('1.0.5');
	api.use('meteorhacks:async@1.0.0');
	api.addFiles('blockchain.js', 'server');
	api.export('Blockchain');
});
