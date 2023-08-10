// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract EtherBank {
    error EtherBank__TransferFailed();

    mapping(address => uint256) public s_balances;

    function depositEth() external payable {
        s_balances[msg.sender] += msg.value;
    }

    function withdrawEth() external payable {
        uint256 userBalance = s_balances[msg.sender];

        (bool success,) = msg.sender.call{value: userBalance}("");

        if (!success) {
            revert EtherBank__TransferFailed();
        }

        // update the user's balance.
        s_balances[msg.sender] = 0;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance(address) public view returns (uint256) {
        return s_balances[msg.sender];
    }

 
}
