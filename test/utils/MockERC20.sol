// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {
    
    // USDC, USDT with 6 decimals
    constructor() ERC20("Stable Token", "MOCK", 18) {
        mint(msg.sender, 100000000*decimals);
    }

    function mint(address _to, uint256 _amount) public {
        _mint(_to, _amount);
    }
}