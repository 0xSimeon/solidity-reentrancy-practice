// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {EtherBank} from "../src/EtherBank.sol";
// import {EtherBankAttack} from "../src/EtherBankAttack.sol";
import {DeployEtherBank} from "../script/DeployEtherBank.s.sol";

contract EtherBankTest is Test {
    EtherBank etherBank;

    DeployEtherBank deployer;
    address public USER = makeAddr("USER");
    uint256 public userEtherBalance;

    function setUp() external {
        deployer = new DeployEtherBank();
        etherBank = deployer.run();

        vm.deal(USER, 10 ether);
        userEtherBalance = etherBank.getUserBalance(USER);
    }

    modifier depositEth {
        vm.startPrank(USER);
        etherBank.depositEth{value: 1 ether}();
        userEtherBalance = etherBank.getUserBalance(USER);
        vm.stopPrank();
        _;
    }

    function testUserCanDeposit() public depositEth {
        console.log(userEtherBalance);
        assert(userEtherBalance > 0);
    }

    function testUserCanWithdrawDepositedAmount() public depositEth {
        vm.startPrank(USER);
        console.log("balance of user after deposit: ", userEtherBalance);
        etherBank.withdrawEth();
        userEtherBalance = etherBank.getUserBalance(USER);
        vm.stopPrank();

        console.log("balance of user after withdrawal: ",userEtherBalance);
        assert(userEtherBalance == 0);

    }
}
