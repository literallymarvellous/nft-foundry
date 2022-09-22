// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Yuri.sol";

contract ContractScript is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Yuri nft = new Yuri(0xcF4AbEE5eCe1979C139A3837a7aCE130c782863e);

        vm.stopBroadcast();
    }
}
