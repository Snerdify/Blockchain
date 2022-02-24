//preventing reentrancy part 1
//all the state changes should happen before calling the external contracts 



function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);
       
       //Change the withdraw function 
       //update your state variable(balances) before you 
       //make any external calls from your contract.
        balances[msg.sender] = 0;
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send funds");
        
        
    }
