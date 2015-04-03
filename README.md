# Meteor Blockchain API
A simple NPM wrapper of [Blockchain's Official API Library](https://github.com/blockchain/api-v1-client-node) for Meteor using Meteorhacks' Async library.

## Installation
```
meteor add borges:blockchain
```

## Warning
Sadly it won't work on projects deployed on `*.meteor.com`:

> Access denied | blockchain.info used CloudFlare to restrict access.
> The owner of this website (blockchain.info) has banned your IP address (23.20.228.167).

## DOCS
Check the official Blockchain's docs [here](https://github.com/blockchain/api-v1-client-node/tree/master/docs).

### Receive.listen caveat
The Receive.listen method differs from official docs because on Meteor, we're using [Iron Router](https://github.com/iron-meteor/iron-router):

```
receive.listen(server, callback);
```

Parameters:

* **server**: Iron Router object (*object*, required)
* **callback**: Server callback to be called when the route is fired (*function(data)*)

Listens for when the callback url sends data back to the server. Occurs whenever a transaction to the forwarding address happens.  
Responds with an *object* in the data parameter of the callback.

Response Object:

* **value**: the value of the payment received, in satoshi (*number*)
* **input_address**: the bitcoin address that received the transaction (*string*)
* **confirmations**: the number of confirmations of this transaction (*number*)
* **transaction_hash**: the hash of the transaction (*string*)
* **input_transaction_hash**: the original hash, before forwarding (*string*)
* **destination_address**: the destination bitcoin address (*string*)
* **{Custom Parameter}**: any parameters included in the callback url that have been passed back


## License
MIT License
