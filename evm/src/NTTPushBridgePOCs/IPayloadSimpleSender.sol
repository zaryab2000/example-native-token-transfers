// SPDX-License-Identifier: Apache 2
pragma solidity >=0.6.12 <0.9.0;

interface IPayloadSimpleSender {
        struct Channel {
        string callerAddress;
        uint8 channelState;
        address verifiedBy;
        bool isVerified;
        uint256 magicValData;
        bytes4 functionSignature;
    }
    function sendPushTokensOnly(address _to, uint256 _amount) external payable;
    function sendPushTokenWithMSG(address _to, uint256 _amount, Channel memory channelData, address targetContractAddress) external payable;

    function version() external view returns(uint256);
    function SEPOLIA_TOKEN() external view returns(address);
    function latestGreeting() external view returns(string memory);


}
