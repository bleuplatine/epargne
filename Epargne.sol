// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

// import "github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
// import "./node_modules/@openzeppelin/contracts/access/Ownable.sol"; 

import "./Owner.sol";

contract Epargne is Owner {
    
    uint256 public startTime;
    uint256 ID;
    bool public authorized;
    
    struct deposit {
        uint256 num;
        uint256 date;
        uint256 amount;
    }

    mapping(address => deposit) deposits;
    mapping(address => uint256) balances;
    
    // Afficher les infos de temps (temps actuel, temps limite (+2 min pour test))
    function getBlockTime() public view returns(uint256, uint256) {
        return (block.timestamp, startTime + 2 minutes);
    }
    
    // Afficher le montant total déposé par l'utilisateur du contrat
    function getMyBalance() public view returns(uint256) {
        return balances[msg.sender];
    }
    
    // Afficher le montant total déposé sur le contrat
    function getBalance() public view returns(uint256) {
        return address(this).balance;
    }
    
    // Transférer le montant total déposé sur le contrat sur le compte de l'auteur du contrat
    function transferAfterTimeout() public payable onlyOwner {
        require(block.timestamp >= (startTime + 2 minutes));
        payable(msg.sender).transfer(address(this).balance);
    }
    
    receive() external payable {
        if(owner == msg.sender) {
            startTime = block.timestamp;
            authorized = true;
        }
        require(authorized, "Owner must first make a deposit");
        ID++;
        deposits[msg.sender] = deposit(ID, block.timestamp, msg.value);
        balances[msg.sender] = balances[msg.sender] + msg.value;
    }

}