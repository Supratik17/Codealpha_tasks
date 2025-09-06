// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PersonalPortfolio {
    struct Deposit {
        uint amount;
        uint unlockTime;
    }

    mapping(address => Deposit) public deposits;

    function deposit(uint lockTime) external payable {
        require(msg.value > 0, "Deposit must be > 0");
        deposits[msg.sender] = Deposit({
            amount: msg.value,
            unlockTime: block.timestamp + lockTime
        });
    }

    function withdraw() external {
        Deposit storage dep = deposits[msg.sender];
        require(block.timestamp >= dep.unlockTime, "Lock time not reached");
        uint amount = dep.amount;
        dep.amount = 0;
        payable(msg.sender).transfer(amount);
    }
}
