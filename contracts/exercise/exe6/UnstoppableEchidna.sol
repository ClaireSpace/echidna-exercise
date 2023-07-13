// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./UnstoppableLender.sol";
import "./DamnValuableToken.sol";
import "./ReceiverUnstoppable.sol";


contract UnstoppableEchidna {


   UnstoppableLender public pool;
//    ReceiverUnstoppable public receiver;
   DamnValuableToken public token;
 
   constructor () payable{
      token=new DamnValuableToken();
      pool=new UnstoppableLender(address(token));
      token.approve(address(pool),10e18);
      pool.depositTokens(10e18);
      //This is very important, if you don't do this, the attacker is unable to broke the flashLoan function
      token.transfer(msg.sender,1e18);
  }

    // Pool will call this function during the flash loan
    function receiveTokens(address tokenAddress,uint256 amount) external {
        require(msg.sender == address(pool), "Sender must be pool");
        // Return all tokens to the pool
        require(IERC20(tokenAddress).transfer(msg.sender, amount),
            "Transfer of tokens failed");
    }

    // Test the flashloan can always be made
    function echidna_test_always_success() public returns (bool) {
        pool.flashLoan(10);
        return true;
    }
    
}