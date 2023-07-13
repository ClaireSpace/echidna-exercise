// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DamnValuableToken is ERC20 {
    constructor() ERC20("Damn Valuable Token", "DVT") {
        _mint(msg.sender, type(uint256).max);
    }
}
