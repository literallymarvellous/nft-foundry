// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

/**
 * @title Marvels NFT
 * @author Ahiara Ikechukwu Marvellous
 * @notice A 100 NFT token that can be collected by anyone
 */

import "solmate/src/tokens/ERC721.sol";
import "solmate/src/auth/Owned.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract Yuri is ERC721, Owned {
    using Strings for uint256;
    uint8 private constant _maxSupply = 100;
    uint256 private constant MINT_PRICE = 0.01 ether;

    uint8 private _counter;

    constructor(address _owner) ERC721("Marvels", "MARV") Owned(_owner) {}

    function _baseURI() internal pure returns (string memory) {
        return
            "https://bafybeibhqislilo36kh2bhepzilr44hgfzpkngnf2x3tbuhopg4qb3fuha.ipfs.dweb.link/metadata/";
    }

    function totalSupply() public view returns (uint8) {
        return _counter;
    }

    function mint() external payable returns (uint8) {
        mint(1);
    }

    /**
     * @notice Mints tokenId and transfers it to `to`.
     * @param _quantity number of tokens to mint
     *
     * Emits a {Transfer} event.
     */

    function mint(uint256 _quantity)
        external
        payable
        returns (uint256[] memory)
    {
        require(_counter < _maxSupply, "No more tokens to mint");
        require(quantity * MINT_PRICE == msg.value, "Fee is incorrect");
        require(_quantity <= 5, "Can't mint more than 5");
        uint256[] memory ids = new uint256[](_quantity);

        for (uint256 i = 0; i < _quantity; i++) {
            uint256 id = _counter++;

            _mint(msg.sender, id);
            ids[i] = id;
        }

        return ids;
    }

    /**
     * @notice returns url of the token
     * @param tokenId id of the token
     */
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721)
        returns (string memory)
    {
        require(ownerOf(tokenId) != address(0), "Token does not exist");

        return string(abi.encodePacked(_baseURI(), tokenId.toString()));
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance != 0, "No balance to withdraw");
        (bool success, ) = owner.call{value: balance}("");
        require(success, "withdrawal failed");
    }
}
