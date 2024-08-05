// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GaslessERC20Token
 * @dev Implementation of the GaslessERC20Token
 * This contract creates an ERC20 token with gasless transactions (ERC20Permit) and pausable functionality.
 */
contract GaslessERC20Token is ERC20, ERC20Permit, ERC20Pausable, Ownable {
    uint256 private immutable _maxSupply;

    /**
     * @dev Constructor that gives msg.sender all of initial supply.
     * @param name_ The name of the token.
     * @param symbol_ The symbol of the token.
     * @param maxSupply_ The maximum supply of the token.
     */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_
    ) ERC20(name_, symbol_) ERC20Permit(name_) {
        require(maxSupply_ > 0, "GaslessERC20Token: Max supply must be greater than 0");
        _maxSupply = maxSupply_;
        _mint(msg.sender, maxSupply_);
    }

    /**
     * @dev Returns the max supply of the token.
     * @return The max supply of the token.
     */
    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    /**
     * @dev Pauses all token transfers.
     * See {ERC20Pausable} and {Pausable-_pause}.
     *
     * Requirements:
     * - the caller must be the contract owner.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers.
     * See {ERC20Pausable} and {Pausable-_unpause}.
     *
     * Requirements:
     * - the caller must be the contract owner.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}.
     *
     * Requirements:
     * - the contract must not be paused.
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override(ERC20, ERC20Pausable) {
        super._beforeTokenTransfer(from, to, amount);
    }
}