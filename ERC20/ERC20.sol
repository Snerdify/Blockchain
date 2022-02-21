// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    //keep track of total supply of the token
    uint public totalSupply;
    //mapping from address to uint which tells how much each user has a token
    mapping(address => uint) public balanceOf;
    //mapping to store the data when the owner approves the spender to spend a certain amount
    mapping(address => mapping(address => uint)) public allowance;

    //Meta Data about the ERC20 tokens
    //name of the token
    string public name = "Dummy";
    // symbol of the token
    string public symbol = "DUM";
    //decimals in the token- how many zeroes are used to represent one erc20 token
    uint8 public decimals = 18;  //10**18= one of this Token,i.e.,=1 DUM



// TRANSFER tokens from msg.sender to recipient,balance of msg.sender reduces and balance of recipient increases 
    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        //acc to ERC20 std we need to emit the event Transfer
        emit Transfer(msg.sender, recipient, amount);
        return true;  // returing a boolean that means the function to this call was successful
    }


//msg.sender approves a spender to spend his token 
    function approve(address spender, uint amount) external  returns (bool) {
        allowance[msg.sender][spender] = amount;   //msg.sender is allowing the spender to spend
        // emit event
        emit Approval(msg.sender, spender, amount);
        return true;
    }


// this function transfers the amount from sender to recipient , this function can be called by anyone as long as the sender has given his/her approval to msg.sender 
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external   returns (bool) {
        allowance[sender][msg.sender] -= amount;  // allowance of sender to msg.sender deducted after the approval
        balanceOf[sender] -= amount;  //balance of sender reduces
        balanceOf[recipient] += amount;  //balance of the recipient increases
        emit Transfer(sender, recipient, amount);  
        return true;
    }
    
 
    //minting or creating new tokens - allow msg.sender to mint
    function mint(uint amount) external { 
        balanceOf[msg.sender] += amount;  //balance of msg.sender increases
        totalSupply += amount;  // supply of token increases
        emit Transfer(address(0), msg.sender, amount);   // we are not transferring tokens. instead we are creating them. set the sender to address 0,recipient is msg.sender as the sender is getting new tokens.

    }


     //burn-destroy the existing tokens 
    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount; //balance of msg.sender decreases
        totalSupply -= amount;  //supply of token decreases
        emit Transfer(msg.sender, address(0), amount);  // transfer from msg.sender to address 0
    }
}
