// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {EtherBank} from "../src/EtherBank.sol";
import {EtherBankAttack} from "../src/EtherBankAttack.sol";
import {DeployEtherBank} from "../script/DeployEtherBankAttack.s.sol";

contract EtherBankTest is Test {
    EtherBank etherBank;
    EtherBankAttack etherBankAttack;
    DeployEtherBank deployer;
    address public USER = makeAddr("USER");
    address public USER1 = makeAddr("USER1");
    address public USER2 = makeAddr("USER2");
    address public USER3 = makeAddr("USER3");
    uint256 public userEtherBalance;
    address public etherBankAttackAddress;

    function setUp() external {
        deployer = new DeployEtherBank();
        (etherBank, etherBankAttack) = deployer.run();
        etherBankAttackAddress = address(etherBankAttack);
        vm.deal(USER, 10 ether);
        vm.deal(USER1, 10 ether);
        vm.deal(USER2, 10 ether);
        vm.deal(USER3, 10 ether);
        vm.deal(address(etherBankAttack), 1 ether);
    }

    modifier depositEthForallUsers() {
        vm.prank(USER);
        etherBank.depositEth{value: 4 ether}();

        vm.prank(USER1);
        etherBank.depositEth{value: 4 ether}();

        vm.prank(USER2);
        etherBank.depositEth{value: 4 ether}();

        vm.prank(USER3);
        etherBank.depositEth{value: 4 ether}();
        _;
    }

    function testCanAttackContract() public depositEthForallUsers {
        vm.startPrank(etherBankAttackAddress);
        console.log("owner balance before attack: ", etherBankAttack.getOwner().balance);
        console.log("etherBank contract balance before attack: ",address(etherBank).balance);
        console.log("etherBankAttack contract balance before attack: ",address(etherBankAttack).balance);

        etherBankAttack.attack();

        // userEtherBalance = etherBank.getUserBalance(USER);
        vm.stopPrank();

        console.log("owner balance after the attack: ",etherBankAttack.getOwner().balance);
        console.log("etherBank contract balance after attack: ",address(etherBank).balance);
        console.log("etherBankAttack contract balance after attack: ",address(etherBankAttack).balance);

        assertEq(etherBankAttack.getOwner().balance, 17 ether);
    }
}
