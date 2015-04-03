@BlockchainAPI = Npm.require('blockchain.info')
@url = Npm.require('url')
@request = Npm.require('request')

@appendToURL = (param, val) ->
	if val == undefined then '' else ('&' + param + '=' + val).toString()

@makeRequest = (url, callback) ->
	console.log '0: ' + url
	request url, (error, response, body) ->
		console.log '1'
		if !error
			console.log '2 ' + body
			try
				data = JSON.parse body
			catch err
				console.log '3'
				data = { error: err }
			finally
				console.log '4' + JSON.stringify data
				if !data['error']
					callback null, data
				else
					callback 'err: ' + data['error']
		else
			callback error

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
		###
		receive.create = _.bind (address, parameters, callback) ->
			if arguments.length == 2
				callback = parameters
				parameters = {}

			console.log cbURL = @callbackURL + '?format=json'
			_.each parameters, (value, key) ->
				cbURL += appendToURL key, value

			callUrl = 'https://blockchain.info/' + 'api/receive?method=create'
			callUrl += appendToURL 'address', encodeURIComponent(address)
			callUrl += appendToURL 'callback', encodeURIComponent(cbURL)
			callUrl += appendToURL 'api_code', @apiCode

			makeRequest callUrl, callback
		, receive
		###
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
