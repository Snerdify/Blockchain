pragma solidity ^0.8.10;




interface IERC20{
    function totalSupply() external view returns (uint256); //returns total amount of tokens
    function balanceOf(address account ) external view returns (uint256);  // amount of token that an address holds
    function transfer (address recipient , uint256 amount) external returns (bool); // transfer tokens to other addresses
    function allowance (address owner , address spender) external view returns (uint256); //amount of tokens a spender can spend from a token holder
    function approve(address spender , uint256 amount ) external view returns (bool);// token holder calls the func approve to set the amount of tokens a spender can spend
    function transferFrom(address sender,address recipient , uint256 amount) external view returns (bool);// spender can call transferfrom to send the tokens from token holder to anyone 
    
    event Transfer(address indexed from ,  address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender,uint256 value);



}
