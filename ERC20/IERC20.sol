// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//external functions are functions that are a part of the contract inteface but can be called from other contracts or via transactions


interface IERC20{
    //total amount of ERC20 tokens- Anyone can view this function and it returns a uint256 value
    function totalSupply() external view returns (uint256); 
    // returns the amount of ERC20 token that that account has-Anyone can view this func and it returns a uint256 value
    function balanceOf(address account ) external view returns (uint256); 
    //Holder of the ERC20 token can call the function transfer to transfer an amount of ERC20 tokens to the recipient
    function transfer (address recipient , uint256 amount) external returns (bool); 
    //amount of tokens a spender can spend from a token holder or how much the token holder allows the spender to spend.
    function allowance (address owner , address spender) external view returns (uint256); 
    // if the token holder does not himself wants to transfer the tokens , then he/she can call the function approve,approving the spender to spend some of his tokens
    function approve(address spender , uint256 amount ) external  returns (bool);
    //once the token holder approves the spender to spend the token on his behalf the spender can call the function transferFrom to transfer from the holder to another recipient 
    function transferFrom(address sender,address recipient , uint256 amount) external  returns (bool);
    
    event Transfer(address indexed from ,  address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender,uint256 value);



}
