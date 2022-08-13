// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Yuri.sol";

contract YuriTest is Test {
    using stdStorage for StdStorage;

    Yuri yuri;
    address owner;
    address alice;
    address bob;

    function setUp() public {
        owner = vm.addr(1);
        yuri = new Yuri(owner);

        alice = vm.addr(2);
        vm.deal(alice, 1 ether);

        bob = vm.addr(3);
        vm.deal(bob, 1 ether);

        vm.label(address(this), "YuriTest");
        vm.label(address(yuri), "YuriNFT");
        vm.label(owner, "YuriOwner");
    }

    function testOwner() public {
        assertTrue(yuri.owner() == owner);
    }

    function testCannotMintMoreThanMaxSupply() public {
        uint256 slot = stdstore.target(address(yuri)).sig("counter()").find();
        bytes32 loc = bytes32(slot);
        bytes32 mockedCounter = bytes32(abi.encode(100));
        vm.store(address(yuri), loc, mockedCounter);
        vm.expectRevert("Max supply reached");
        yuri.mint();
        assertEq(yuri.totalSupply(), 100);
    }

    function testCanMintOneToken() public {
        vm.prank(alice);
        yuri.mint{value: 0.01 ether}();
        assertEq(yuri.totalSupply(), 1);
    }

    function testCanMintThreeTokens() public {
        vm.prank(alice);
        yuri.mint{value: 0.03 ether}(3);
        assertEq(yuri.totalSupply(), 3);
    }

    function testCannotMintIfNotEqualToFee() public {
        vm.prank(alice);
        vm.expectRevert("msg.value is not equal to MINT_PRICE");
        yuri.mint{value: 0.001 ether}();
        assertEq(yuri.totalSupply(), 0);
    }

    function testCannotMintPassFiveTokens() public {
        vm.prank(alice);
        vm.expectRevert("Can't mint more than 5");
        yuri.mint{value: 0.06 ether}(6);
        assertEq(yuri.totalSupply(), 0);
    }

    function testOwnerCanWithdrawFunds() public {
        yuri.mint{value: 0.05 ether}(5);
        assertEq(yuri.totalSupply(), 5);
        assert(address(yuri).balance == 0.05 ether);

        uint256 yuriBalance = address(yuri).balance;
        uint256 priorOwnerBalance = address(owner).balance;
        vm.prank(owner);
        yuri.withdraw();
        assertEq(address(owner).balance, priorOwnerBalance + yuriBalance);
    }

    function testBalanceOfAccountAfterMint() public {
        uint256 priorOwnerBalance = address(bob).balance;
        console2.log("priorOwnerBalance: ", priorOwnerBalance);

        uint256 mintPrice = 0.03 ether;
        vm.prank(bob);
        yuri.mint{value: mintPrice}(3);
        console2.log("address(bob).balance: ", address(bob).balance);
        assertEq(address(bob).balance, priorOwnerBalance - mintPrice);
    }
}
