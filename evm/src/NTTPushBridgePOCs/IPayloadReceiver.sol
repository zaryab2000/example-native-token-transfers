// SPDX-License-Identifier: Apache 2
pragma solidity >=0.6.12 <0.9.0;

interface IPayloadReceiver {
    struct Channel {
        string callerAddress;
        uint8 channelState;
        address verifiedBy;
        bool isVerified;
        uint256 magicValData;
        bytes4 functionSignature;
    }

    function version() external view returns(uint256);
    function magicValue() external view returns(uint256);
    function lastCaller() external view returns(address);
    function recipientChain() external view returns(uint256);
    function lastCallerAddressInStringFormat() external view returns(string memory);

    function getChannellData(address _channelOwner) external view returns(Channel memory);


}
