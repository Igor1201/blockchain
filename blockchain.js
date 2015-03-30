if (Meteor.isServer) {
	BlockchainAPI = Npm.require('blockchain.info');
	Blockchain = {
		blockexplorer: Async.wrap(BlockchainAPI.blockexplorer, ['getBlock','getTx','getBlockHeight','getAddress','getMultiAddress','getUnspentOutputs','getLatestBlock','getUnconfirmedTx','getBlocks','getInventoryData']),
		exchangeRates: Async.wrap(BlockchainAPI.exchangeRates, ['getTicker','toBTC']),
		pushtx: Async.wrap(BlockchainAPI.pushtx, 'pushtx'),
		statistics: Async.wrap(BlockchainAPI.statistics, ['get','getChartData']),
		MyWallet: function(identifier, password, secondPassword) {
			var wallet = new BlockchainAPI.MyWallet(identifier, password, secondPassword);
			return Async.wrap(wallet, ['send','sendMany','getBalance','listAddresses','getAddress','newAddress','archiveAddress','unarchiveAddress','consolidate']);
		},
		CreateWallet: function(password, apiCode, options) {
			var wallet = new BlockchainAPI.CreateWallet(password, apiCode, options);
			return Async.wrap(wallet, ['create','open']);
		},
	}
}
