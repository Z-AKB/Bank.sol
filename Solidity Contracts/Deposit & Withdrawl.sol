// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Bank 
{
    struct User
    {
        string name;
        address userAddress;
        uint256 balance;
    }

    // Mapping from address to User struct
    mapping(address => User) public users;
    mapping(address => uint256) private myMap;

    // Function to create a user profile
    function createUser(string memory _name) public {
        users[msg.sender] = User(_name, msg.sender, 0);
    }

    function get(address _addr) public view returns (uint256) 
    {
        // If the value is never set, it will return the default value.
        return myMap[_addr];
    }

    function set(address _addr, uint256 _i) public 
    {
        // Update the value at this address
        myMap[_addr] = _i;
    }

    function remove(address _addr) public 
    {
        // Reset the value to the default value.
        delete myMap[_addr];
    }
    
    // Function modifier to check if the deposit amount is greater than 50
    modifier depositAmount() {
        require(msg.value > 50, "Deposit amount must be greater than 50");
        _;
    }

    // Function modifier to check if the sender has enough balance to perform a withdrawal
    modifier sufficientBalance(uint256 _amount) {
        require(myMap[msg.sender] >= _amount, "Insufficient balance");
        _;
    }
    
    // Function to deposit balance into the contract
    function deposit() public payable depositAmount 
    {
        myMap[msg.sender] += msg.value;
    }

    // Function to withdraw balance from the contract
    function withdraw(uint256 _amount) public payable sufficientBalance(_amount) 
    {
        // Subtract the amount requested from the sender's balance in the contract
        myMap[msg.sender] -= _amount;
        
        // Transfer the amount requested back to the sender's wallet
        (bool sent,) = msg.sender.call{value:_amount}("");
        require(sent, "Failed to send Ether");
    }
}
