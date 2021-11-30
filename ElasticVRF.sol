pragma solidity ^0.8.7;

import "./hardhat-starter-kit/contracts/RandomNumberConsumer.sol";
import "./node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ElasticVRF is VRFConsumerBase, ERC20 {
    /* At set time intervals, increase, decrease, or do nothing to total supply randomly (by a random 
    amount based off how far the # is from 40 or 60. 1-40 decrease, 40-60 no effect, 60-100 increase)
    */
    int public chainlinkVRF;

    function checkTimeStamp (uint time, address to) public returns (bool){
        if(block.number < time){
            chainlinkVRF = RandomNumberConsumer.fulfillRandomness(requestId, randomness);
            checkVRF(chainlinkVRF, to);
        }
    }

    function checkVRF(uint value, address to) public {
        if(value >= 0 && value < 40){
            decreaseSupply(value, to);
        }
        if(value >= 60){
            increaseSupply(value, to);
        }
    }

    function increaseSupply(uint value, address to) private returns (bool) {
    totalSupply = safeAdd(totalSupply, value);
     balances[for] = safeAdd(balances[to], value);
    Transfer(0, to, value);
    return true;
    }

    function safeAdd(uint a, uint b) internal returns (uint) {
    if (a + b < a) { throw; }
    return a + b;
    }

    function decreaseSupply(uint value, address from) private returns (bool) {
    balances[from] = safeSub(balances[from], value);
    totalSupply = safeSub(totalSupply, value);  
    Transfer(from, 0, value);
    return true;
    }

    function safeSub(uint a, uint b) internal returns (uint) {
    if (b > a) { throw; }
    return a - b;
    }
}