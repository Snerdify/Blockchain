// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

//event 
//array
//mapping
//struct
//constructor
//error
//fallback
//payable
//function modifier
//call
//view function
//multisig wallets require two or more keys to send the trasaction

contract MultiSig{
//this event will be emited when ether is sent to this account
    event Deposit(address indexed sender, uint amount,uint balance);
   
//event for the func submittransaction   
    event SubmitTransaction(
        address indexed owner,
        uint indexed txIndex,
        address indexed to,
        uint value,
        bytes data
    );

    
    //event for confirmtransaction
    event ConfirmTransaction(
        address indexed owner,
        uint indexed txIndex
    );
   
   
   //event for revoke transaction
    event RevokeTransaction(
        address indexed owner,
        uint indexed txIndex
    );
   
   
   //event for execute transaction
    event ExecuteTransaction(
       address indexed owner,
        uint indexed txIndex 
    );


//create an empty array to store the owners of this wallet
    address[] public owners;
    //use mapping to keep track that whether address is 
    // of a particular owner,tells us whether as address
    //is an owner or not
    mapping(address => bool) public isOwner;
//initialize a variable that keeps track of no. of confiramtions required
//to confirm a transaction 
    uint public numConfirmationsRequired;

    //create a Struct to hold all the state variables needed for the contract
    struct Transaction{
        address to;   //address that the transaction is sent to
        uint value;  //amount that is sent to the address
        bytes data;  //if we r calling another cotract
        //then we store the data that is going to be sent to that contract
        bool executed;  //whether our transaction is executed or not
        uint numConfirmations;  //store the no of confirmations
        
    }

    //mapping
    mapping(uint=>mapping(address=>bool)) public isConfirmed;
 

 //create an empty array to keep track of transactions
    Transaction[] public transactions;





//the modifier onlyowner will check that whether,
//msg.sender is the owner of the multisig wallet,
// it will do this using the mapping isOwner
    modifier onlyOwner(){
        require(isOwner[msg.sender],"Not the owner !!");
        
        _;
    }




// a modfier which checks if the transaction already exists
    modifier txExists(uint _txIndex){
        //check that the transaction exists by saying that the txindex of the current transaction is less than the length of the transaction
        require(_txIndex < transactions.length, "Tx does not exist");
        
        _;
    }




// this modifier checks whether a transaction has executed or not

    modifier notExecuted(uint _txIndex){
// to check whether a transaction has happened or not- we can do this by getting the transaction at the index and making sure that the field executed is false
        require(!transactions[_txIndex].executed,"Tx already exists");
        _;
    }





//this modifier checks whether has confirmed a transaction

    modifier notConfirmed(uint _txIndex){ 
        //how to check that owner has confirmed the transaction or not. start by getting the transaction at the index,then check that mapping for isConfirmed[msg.sender]
        //is equals to false
        require(!isConfirmed[_txIndex][msg.sender],"Tx already confirmed");
        _;
    }






//constructor is used to initialize the state variables 
//defined  in the struct
//input for this constructor are the owners of the multisig wallet and 
//no of confirmations required
    constructor(address[] memory _owners,
    uint _numConfirmationsRequired){
        //condition 1- the array of owners is not empty
        require(_owners.length > 0, "Owners required!");
        //condition 2- no of confirmations required 
        //is greater than 0 and less that or equal to the 
        //no of owners
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length,
        "Invalid no of confirmations");

        //copy the owners from the inputs to the state variables
        //for loop runs from the i=0 to the length of the owner,
        
        for (uint i =0 ; i<_owners.length ; i++){
            // get the owner and store in a variable
            address owner=_owners[i];
            //make sure that owner has a real address
            require(owner != address(0) , "Invalid owner");
// acc to mapping we created above we can check whether 
//an address is owner or not
//this can be used to check duplicate owners
            require(!isOwner[owner],"Owner not unique");
            //if the owner is unique or an addres is not already an 
            //owner
            isOwner[owner]=true;
            //now we can add the owner to the owner state variable
            //
            owners.push(owner);

        }
        //after setting up the owners
        //get the no of confirmations required
        numConfirmationsRequired=_numConfirmationsRequired;
    }





    //declare a receive  function as payable
    receive() payable external {
        emit Deposit(msg.sender , msg.value , address(this).balance);

    }

   









//owner will have to propose a transaction by calling other'
//owners- when the owner submits a transaction they will need an
//address the trasaction is for, the amount of value to transact,
//and the transaction data.it will be a public func,
// and only owner of the contract can call this func

    function submitTransaction(address _to,uint _value,
    bytes memory _data) public onlyOwner{
        //id for the transaction we use lenght
        //of the transaction array
        //i.e. 1st transaction will have the id of 0 and so on
        uint txIndex= transactions.length;
        // initialize the Transaction struct and append it to array of transactions

        transactions.push(
            Transaction({to:_to,value:_value
            ,data:_data,executed:false,numConfirmations:0})
        );
//emit the event
        emit SubmitTransaction(msg.sender,txIndex,_to,_value,_data);
    }








//the other owners can comfirm transactions by calling
//func confirmtransactions--input will be the id of the transaction that is going to be confirmed
//it can only be confirmed by the owner
    function confirmTransaction(uint _txIndex) public onlyOwner
        //owner should only be able to create a transaction that exists
        txExists(_txIndex)
        //now if the transaction exists it should not be executed yet
        notExecuted(_txIndex)
        //owner should not have confirmed the transaction yet
        notConfirmed(_txIndex)  
        {
            //update the transaction struct by getting the transaction at the index
            Transaction storage transaction = transactions[_txIndex];
            //set is.Confirmed for msg.sender = true , i.e , msg.sender has approved the transaction
            isConfirmed[_txIndex][msg.sender]=true;
            //increment the no of confirmations
            transaction.numConfirmations +=1;

//emit the event
            emit ConfirmTransaction(msg.sender,_txIndex);
    }









//if enough owners confirm the trnsaction,then this func executes
// input for this func is the current transaction index, only the owner can do execution , the transaction should exist, and it should have not been executed
    function executeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex) {
//to execute a transaction, first get a transaction struct
        Transaction storage transaction = transactions[_txIndex];
//n of owners is >= no of required transactions
        require(transaction.numConfirmations  >= numConfirmationsRequired,
        "Can't execute transaction" );

        //if they are enough confirmations, set executed to true
        transaction.executed=true;

        //then execute the transaction using the call method
        (bool success,) = transaction.to.call{value:transaction.value}(transaction.data);
        //then check whether the call was succcessful
        require (success , "Transaction Failed");

        // now emit the event using owner who called the execution func and the id of the transaction that got executed 
        emit ExecuteTransaction(msg.sender, _txIndex);


    }










//if the owner wants to return from the confirmation
    function revokeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex)  {
        Transaction storage transaction = transactions[_txIndex];

        require(isConfirmed[_txIndex][msg.sender] , "Transaction is not yet confirmed");

        transaction.numConfirmations-=1;
        isConfirmed[_txIndex][msg.sender] = false;

        //emit the event

        emit RevokeTransaction(msg.sender,_txIndex);


    }


   

    function getOwners() public view returns (address[] memory) {
        return owners;
    }


    function getTransactionCount(uint _txIndex) public view returns(
        address to,
        uint value,
        bytes memory data,
        bool executed,
        uint numConfirmations
    
    
    ){

        Transaction storage transaction = transactions[_txIndex];

        return(
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }

    


    



}
