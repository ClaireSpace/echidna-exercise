// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.5.0;
import "./token.sol";

/*
 * Test Token
 * Explain: Find Overflow Problem
 * - Deploy a Token contract with initial balance of 10000
 * - The balance of this contract should not be more than 10000
 *
 * Run:
 * 1. solc-select use 0.5.0
 * 2. echidna-test contracts/exercise/exe1/testToken.sol
 */

contract TestToken is Token {
    address test = msg.sender;

    constructor() public {
        balances[test] = 10000;
    }

    function echidna_test_balance() public view returns (bool) {
        return balances[test] <= 10000;
    }
}
        

















