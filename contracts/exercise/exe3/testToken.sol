// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.5.0;

import "./mintable.sol";

/*
 * When comes up with mint function, there is always a true property you can defiened: Any balance of address can't be more than the total value.
 *
 * Find a strange problem of Echidna
 * 1. First should run "solc-select use 0.5.0"
 * 2. Then run "echidna-test contracts/exercise/exe3/testToken.sol" it will result in exception, saying: echidna-test: Constructor arguments are required: [("totalMintable_",int256)]
 * 3. But When change to "echidna-test contracts/exercise/exe3/testToken.sol --contract TestToken" ,it runs without exception.
 */
contract TestToken is MintableToken {
    address echidna = msg.sender;


    // learn the constructor examples of father-and-son contracts here:
    // https://solidity-by-example.org/constructor/
    constructor() public MintableToken(10000) {
        owner = echidna;
    }

    function echidna_test_balance() public view returns (bool) {
        return balances[msg.sender] <= 10000;
    }
}
        