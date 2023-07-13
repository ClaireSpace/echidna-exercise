// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.5.0;
 import "./token.sol";
/*
 * TestToken.sol
 * Explain: Find function control problem
 * - Problem :the onwnership of this contract can be transfered by anyone who call the Owner() function
 * - And the "owner" is public, also can be changed easily
 * 
 * Run:
 * 1. solc-select use 0.5.0
 * 2. echidna-test contracts/exercise/exe2/testToken.sol
 */
contract TestToken is Token {
    //Lose control of the contract
    constructor() public {
        pause();
        owner=address(0);
    }

    function echidna_test_paused() public view returns (bool) {
        return paused()==true;
    }
}
