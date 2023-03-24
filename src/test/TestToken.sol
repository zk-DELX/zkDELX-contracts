// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//Token for test only
// The line above is recommended and let you define the license of your contract
// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.

// This is the main building block for smart contracts.
contract TestToken is ERC20 {
    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public _totalSupply = 100000000000 * (10**uint256(decimals()));

    constructor(address _owner) ERC20("TestToken", "TT") {
        _mint(_owner, _totalSupply);
    }
}
