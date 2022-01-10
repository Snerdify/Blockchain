pragma solidity ^0.8.7;


contract ZombieFactory{
    uint dnaDigits=16;
    uint dnaModulus=10**dnaDigits;
    struct Zombie {
        string name;
        uint dna;
    }
    
    Zombie[] public zombie;// public array of zombie 
    
    //creating a function
    function  createZombie(string memory_name, uint _dna) private{
        zombie.push(Zombie("SJ",21))
    }
    // creating a private function
    function _generateRandomDna(string memory_str) private view returns(unit){
            uint rand =uint(keccak256(abi.encodePacked(__str)) );
            return rand % dnaModulus;
    }
     function createRandomZombie(string memory_str) public {
         uint ranDna= _generateRandomDna(_name);
         createZombie(_name,ranDna)
     }
     
     event NewZombie(unit zombieId,string name,uint dna)
}
