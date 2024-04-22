// SPDX-License-Identifier: Apache 2
pragma solidity >=0.6.12 <0.9.0;

interface IPayloadSimpleReceiver {

    function version() external view returns(uint256);
    function recipientChain() external view returns(uint256);
    function latestGreeting() external view returns(string memory);

}
