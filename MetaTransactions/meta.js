// meta transaction is a message with data signed by the 
//whoever wants to execute the transaction
//the signed data is verified and sent to noraml eth transaction
//by another party.

//call data => read-only byte-addressable space 
//where the data parameter of a transaction or call is held
//Call data is stored as part of the eth chain history. 
//If you want to validate the whole chain you need to have the call data so it needs 
//to be available for a chian to be considered valid.

let senderAddress = "0x0000EF76331b59b1cc5e82bA1D2f840dBac1C73e"
let receiverAddress = "0x00007e87416D7328fC74663f37e0DF53777188fb"
let tokenValue = "1000000000000000000000"




let calldata = ""


//get the function signature

let fnSignature = web3.utils.keccak256("transferFrom(address, address, uint256)").substr(0,10)


//encode the function parameters

let fnPara = web3.eth.abi.encodeParameters(
    ['address','address','uint256'],
    [senderAddress,receiverAddress,tokenValue]
)



calldata=fnSignature + fnPara.substr(2)

console.log(calldata)
