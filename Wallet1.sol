// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

//contract wallet
contract Wallet{
    //initialize the owner
    address payable public owner;

// declare owner = to msg.sender
    constructor(){
        owner=payable(msg.sender);
    }

//this function is receive the eth from anyone
    receive() external payable {}



//only owner can withdraw the eth
//function to withdraw the funds from the account/address
//it requires the user to be the owner of the account

    function withdraw(uint _amount) external{
        require(msg.sender==owner,"You are not the owner !");
        //if the user is the owner, then transfer the said 
        //amount to him, i.e, let him withdraw
        payable(msg.sender).transfer(_amount);
    }

//helper function that lets us check the balance in this wallet
    function getBalance() external view returns (uint){
        return address(this).balance;
    }



}
