pragma solidity ^0.8.10;

contract MyContract{
    address public lastSender;

// send eth to the contract
    function recieve() external payable{
        lastSender=msg.sender;
    }
//get the balance
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

//send eth from the contract
//address payable allows us to send the money to that address
    function pay(address payable addr) public payable {
        (bool sent,bytes memory data)=addr.call{value:1 ether }("");
        require(sent,"Error sending money");

    }
   

}
