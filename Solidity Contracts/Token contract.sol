// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ZToken is ERC20, Ownable {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    constructor(uint256 initialSupply) ERC20("ZToken", "ZTK") {
        // Mint initial supply to the contract deployer
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    // Transfer tokens to a specified address
    function transferToken(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    // Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    // Transfer tokens from one address to another
    function transferFrom(address sender, address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, allowance(sender, msg.sender) - amount);
        return true;
    }

    // Check the balance of a specific address
    function checkBalance(address account) public view returns (uint256) {
        return balanceOf(account);
    }

    // Burn a specific amount of tokens from an account (onlyOwner)
    function burn(address account, uint256 amount) public onlyOwner {
        _burn(account, amount);
    }

    // Mint new tokens and assign them to the owner (onlyOwner)
    function mint(uint256 amount) public onlyOwner {
        _mint(msg.sender, amount);
    }

    // Internal mint function
    function _mint(address to, uint256 amount) internal override {
        super._mint(to, amount);
    }

    // Internal burn function
    function _burn(address from, uint256 amount) internal override {
        super._burn(from, amount);
    }
}
