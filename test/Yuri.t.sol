// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Yuri.sol";

contract YuriTest is Test {
    using stdStorage for StdStorage;

    Yuri yuri;
    address owner;

    function setUp() public {
        owner = vm.addr(1);
        yuri = new Yuri(owner);

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
        address alice = vm.addr(2);
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        yuri.mint{value: 0.01 ether}();
        assertEq(yuri.totalSupply(), 1);
    }

    function testCanMintThreeTokens() public {
        address alice = vm.addr(2);
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        yuri.mint{value: 0.03 ether}(3);
        assertEq(yuri.totalSupply(), 3);
    }

    function testCannotMintIfNotEqualToFee() public {
        address alice = vm.addr(2);
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        vm.expectRevert("msg.value is not equal to MINT_PRICE");
        yuri.mint{value: 0.001 ether}();
        assertEq(yuri.totalSupply(), 0);
    }

    function testCannotMintPassFiveTokens() public {
        address alice = vm.addr(2);
        vm.deal(alice, 1 ether);
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
}
