// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "./FlashLoanReceiver.sol";
import "./NaiveReceiverLenderPool.sol";


/*
* Target: Deploy NaiveReceiverLenderPool and FlashLoanReceiver
* Detect the receiver's balance decrease, which means that the receiver's balance will be decreased by the flash loan everytime until the receiver's balance is 0.
*
* Steps:
* 1. solc-select use [version > 0.8]
* 2. echidna-test contracts/exercise/exe5/NaiveReceiverEchidna.sol --contract NaiveReceiverEchidna --config contracts/exercise/exe5/config.yaml
*/
contract NaiveReceiverEchidna{
    using Address for address payable;
    
    NaiveReceiverLenderPool public pool;
    FlashLoanReceiver public receiver;

    // We will send ETHER_IN_POOL to the flash loan pool.
    uint256 constant ETHER_IN_POOL = 10e18;
    // We will send ETHER_IN_RECEIVER to the flash loan receiver.
    uint256 constant ETHER_IN_RECEIVER = 1e18;

    constructor() payable{
       pool = new NaiveReceiverLenderPool();
        payable(address(pool)).sendValue(ETHER_IN_POOL);
        receiver = new FlashLoanReceiver(address(pool));
        payable(address(receiver)).sendValue(ETHER_IN_RECEIVER);
    }

    
    function echidna_test_reciever_balance_decrease() public view returns (bool){
        return address(receiver).balance>=ETHER_IN_RECEIVER;
    }        
}