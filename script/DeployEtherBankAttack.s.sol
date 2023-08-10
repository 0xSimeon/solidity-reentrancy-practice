// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {EtherBank} from "../src/EtherBank.sol";
import {EtherBankAttack} from "../src/EtherBankAttack.sol";

contract DeployEtherBank is Script {
    EtherBank etherBank; 
    EtherBankAttack etherBankAttack; 
     uint256 public constant DEFAULT_ANVIL_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    function run() external returns (EtherBank, EtherBankAttack) {
        vm.startBroadcast(DEFAULT_ANVIL_KEY);
        etherBank = new EtherBank();
        etherBankAttack = new EtherBankAttack(address(etherBank));
        vm.stopBroadcast();
        return (etherBank, etherBankAttack);
    }
}