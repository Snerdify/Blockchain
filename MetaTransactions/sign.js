//after creating the call data  for the action to be performed
//sign the transaction


let rawData= web3.eth.abi.encodeParameters(
	['address','bytes'],
	[tokenAddress,data]);


//hash the data

let hash = web.utils.soliditySha3(rawData);

//sign the hash

let sign = web3.eth.sign(hash,signer);


