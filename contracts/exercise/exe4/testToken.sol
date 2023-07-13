// SPDX-License-Identifier: AGPL-3.0
pragma solidity ^0.5.0;

import "./token.sol";

/* Assertion mode
* Explain:
* The result of this case is :
*       Call sequence:
*           transfer(0xdeadbeef,1)
* No tokens in any accounts ,so the transfer will be reverted.
*
* Run:
* 1.solc-select use 0.5.0
* 2.echidna-test  contracts/exercise/exe4/testToken.sol --contract TestToken --test-mode assertion
*/
contract TestToken is MyToken {
    function transfer(address to, uint256 value) public {
        uint256 oldBalanceFrom = balances[msg.sender];
        uint256 oldBalanceTo = balances[to];

        super.transfer(to, value);

        assert(balances[msg.sender] <= oldBalanceFrom);
        assert(balances[to] >= oldBalanceTo);
    }
}
