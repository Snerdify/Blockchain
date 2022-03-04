pragma solidity ^0.8.12;


// import the cryptography utility from openzeppelin 
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/cryptography/ECDSA.sol";



contract Proxy {

  using ECDSA for bytes32;
  
  // mapping to track whether an address is whitelisted
  mapping(address => bool) private isWhitelisted;
  
  //_to: address of the target contract
  //_data:data generated by the call data
  // _signature: the signature after signing the data
  // verify the data and execute the data at the target address
  function forward(address _to, bytes calldata _data, bytes memory _signature) external returns (bytes memory _result) {
    // 
    bool success;
    

    //verify the signature by passing in the parameters
    verifySignature(_to, _data, _signature);
    

    //call is a low level function to interact with other contracts
    //here we use call to check whether the traget address matches
    //the data from the call data of the signer
    (success, _result) = _to.call(_data);

    // if not successful revert the transaction
    if (!success) {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            returndatacopy(0, 0, returndatasize())
            revert(0, returndatasize())
        }
    }
  }
  



  function verifySignature(address _to, bytes calldata _data, bytes memory signature) private view {

      // require the target address to not be empty
    require(_to != address(0), "invalid target address");
    

    //once the target address if verified to be real
    //use abi.encode to read the data generated by the call data
    bytes memory payload = abi.encode(_to, _data);

    //keccak256 recreates a hash of the original msg
    //and recover the signer (signeraddress)  from the signature and the hash

   
    address signerAddress = keccak256(payload).toEthSignedMessageHash().recover(signature);


//check to see if the signer is whitelisted
    require(isWhitelisted[signerAddress], "Signature validation failed");
  }


 //once the signer is checked succesfully add them to the whitelist
 //by saying that _signer is a whitelisted signer 
  function addToWhitelist(address _signer) external {
      isWhitelisted[_signer] = true;
  }
}
