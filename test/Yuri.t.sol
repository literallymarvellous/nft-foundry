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

    function testCannotMintIfNotEqualToFee() public {
        address alice = vm.addr(2);
        vm.deal(alice, 0.001 ether);
        vm.prank(alice);
        vm.expectRevert("msg.value is not equal to MINT_PRICE");
        yuri.mint();
        assertEq(yuri.totalSupply(), 0);
    }
}
