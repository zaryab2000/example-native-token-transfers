// SPDX-License-Identifier: Apache 2
pragma solidity >=0.6.12 <0.9.0;

interface IPayloadSender {
    /// @notice Mints `_amount` tokens to `_account`, only callable by the minter.
    /// @param _to The address to receive the minted tokens.
    /// @param _amount The amount of tokens to mint.
    function sendPushTokensOnly(address _to, uint256 _amount) external payable;
    function sendPushTokenWithMSG(address _to, uint256 _amount, string memory _msg, address targetContractAddress) external payable;

    function version() external view returns(uint256);
    function SEPOLIA_TOKEN() external view returns(address);
    function latestGreeting() external view returns(string memory);


}
