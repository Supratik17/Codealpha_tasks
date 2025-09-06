// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSend {
    // Payable function to send Ether to multiple addresses
    function multiSend(address[] calldata recipients) external payable {
        uint256 amountPerRecipient = msg.value / recipients.length;

        require(amountPerRecipient > 0, "Not enough ETH sent");

        for (uint256 i = 0; i < recipients.length; i++) {
            (bool success, ) = recipients[i].call{value: amountPerRecipient}("");
            require(success, "Transfer failed");
        }
    }
}
