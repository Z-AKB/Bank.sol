// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "Token contract.sol"; // Assuming the Token contract is in the same directory

contract Bank {
    // Define a User struct to hold user profile information
    struct User {
        string name;
        address userAddress;
        uint256 balance;
    }

    // Enum to represent transaction status
    enum Status {
        Failed,
        Successful 
    }

    // Mapping each user's address with their User struct
    mapping(address => User) public users;

    // Reference to the Token contract
    Token public token;

    // Event to be emitted on deposit
    event Deposit(address indexed user, uint256 amount);

    // Event to be emitted on withdrawal
    event Withdrawal(address indexed user, uint256 amount);

    // Event to emit transaction status
    event TransactionStatusEvent(address indexed user, Status status);

    // Constructor to initialize the Token contract
    constructor(address tokenAddress) {
        token = Token(tokenAddress);
    }

    // Function to create a user profile
    function createUser(string memory _name) public {
        users[msg.sender] = User(_name, msg.sender, 0);
    }

    // Function to get a user profile
    function getUser(address _addr) public view returns (string memory, address, uint256) {
        User memory user = users[_addr];
        return (user.name, user.userAddress, user.balance);
    }

    // Function to set balance for a user
    function setBalance(address _addr, uint256 _amount) internal {
        users[_addr].balance = _amount;
    }

    // Modifier to check if the deposit amount is greater than 50 tokens
    modifier depositAmount(uint256 _amount) {
        require(_amount > 50 * (10 ** token.decimals()), "Deposit amount must be greater than 50 tokens");
        _;
    }

    // Modifier to check if the caller has sufficient balance for withdrawal
    modifier sufficientBalance(uint256 _amount) {
        require(users[msg.sender].balance >= _amount, "Insufficient balance");
        _;
    }

    // Modifier to trigger a status event
    modifier triggerStatus(bool _success) {
        if (_success) 
        {
            emit TransactionStatusEvent(msg.sender, Status.Successful);
        } else 
        {
            emit TransactionStatusEvent(msg.sender, Status.Failed);
        }
        _;
    }

    // Function to deposit tokens into the contract
    function deposit(uint256 _amount) public depositAmount(_amount) triggerStatus(true) {
        require(token.transferFrom(msg.sender, address(this), _amount), "Token transfer failed");
        users[msg.sender].balance += _amount;
        emit Deposit(msg.sender, _amount);
    }

    // Function to withdraw tokens from the contract
    function withdraw(uint256 _amount) public sufficientBalance(_amount) triggerStatus(true) {
        users[msg.sender].balance -= _amount;
        require(token.transfer(msg.sender, _amount), "Token transfer failed");
        emit Withdrawal(msg.sender, _amount);
    }
}
