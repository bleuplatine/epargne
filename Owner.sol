// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.9;

contract Owner {
    
    address owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
}
