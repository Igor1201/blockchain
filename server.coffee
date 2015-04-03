@BlockchainAPI = Npm.require('blockchain.info')
@url = Npm.require('url')

Blockchain =
	blockexplorer: Async.wrap BlockchainAPI.blockexplorer, ['getBlock','getTx','getBlockHeight','getAddress','getMultiAddress','getUnspentOutputs','getLatestBlock','getUnconfirmedTx','getBlocks','getInventoryData']
	
	exchangeRates: Async.wrap BlockchainAPI.exchangeRates, ['getTicker','toBTC']
	
	pushtx: Async.wrap BlockchainAPI.pushtx, 'pushtx'
	
	statistics: Async.wrap BlockchainAPI.statistics, ['get','getChartData']

	MyWallet: (identifier, password, secondPassword) ->
		wallet = new BlockchainAPI.MyWallet identifier, password, secondPassword
		Async.wrap wallet, ['send','sendMany','getBalance','listAddresses','getAddress','newAddress','archiveAddress','unarchiveAddress','consolidate']

	CreateWallet: (password, apiCode, options) ->
		wallet = new BlockchainAPI.CreateWallet password, apiCode, options
		Async.wrap wallet, ['create','open']

	Receive: (options, callbackURL) ->
		receive = new BlockchainAPI.Receive options, callbackURL

		receive.setConfirmations = _.bind (confirmations, callback) ->
			@confirmations = confirmations
			callback null, confirmations
		, receive
		
		receive.listen = _.bind (server, clientCallback, callback) ->
			thisReceive = @
			
			if arguments.length == 2
				callback = clientCallback

			if !@callbackURL
				callback 'err: Missing callbackURL'

			path = url.parse(@callbackURL).pathname
			# server must be an Iron Router object: check!
			route = server.route path,
				name: '__borges_blockchain',
				where: 'server',
				action: ->
					parsed = url.parse @request.url, true
					callbackUrlData =
						host: @request.headers.host
						path: parsed.pathname
						query: parsed.query

					callbackUrlData.query.confirmations = parseInt(callbackUrlData.query.confirmations) || 0

					if callbackUrlData.host == url.parse(thisReceive.callbackURL).host
						if callbackUrlData.query.confirmations >= thisReceive.confirmations
							@response.write '*ok*'
							if clientCallback
								clientCallback callbackUrlData.query
						else
							@response.write 'Got ' + callbackUrlData.query.confirmations + ' confirmations while at least ' + thisReceive.confirmations + ' are needed.'
					else
						@response.write 'Bad callback URL.'
					@response.end()

			callback null, route
		, receive

		Async.wrap receive, ['create','listen','setConfirmations']
