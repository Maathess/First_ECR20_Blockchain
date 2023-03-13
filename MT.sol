// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract MTToken is ERC20, Ownable {
    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => bool) private _admins;
    mapping(address => bool) private _locks;
    uint256 private _price;

    constructor(uint256 initialSupply, address adminAddress) ERC20("MyToken","MT") {
        _mint(msg.sender, initialSupply);
        _totalSupply = initialSupply;
        _balances[msg.sender] = initialSupply;
        _admins[adminAddress] = true;
        _price = 1;
        _amountETH = 1000
    }

    function giveAdminRights(address to) public returns (bool) {
        require(_admins[msg.sender] == true, "You do not have admin rights!");
        _admins[to] = true;
        return true;
  }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount <= _balances[msg.sender], "Insufficient balance");
        require(_locks[msg.sender] == false, "Your transfers has been locked.");
        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function lockAddress(address to) public returns (bool) {
        require(_admins[msg.sender] == true, "You do not have admin rights!");
        _locks[to] = true;
        return true;
    }

    function unlockAddress(address to) public returns (bool) {
        require(_admins[msg.sender] == true, "You do not have admin rights!");
        _locks[to] = false;
        return true;
    }

    function setPrice(uint256 newPrice) public returns (bool) {
        require(newPrice > 0, "The price is not valid");
        _price = newPrice;
        return true;
    }

    function mintFor(address receiver, uint256 amount) public returns (bool) {
        require(_admins[msg.sender] == true, "You do not have admin rights!");
        _mint(receiver, amount);
        _totalSupply += amount;
        _balances[receiver] += amount;
        return true;
    }

    
}