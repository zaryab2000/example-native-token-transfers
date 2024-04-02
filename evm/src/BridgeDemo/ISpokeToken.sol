// SPDX-License-Identifier: Apache 2
pragma solidity >=0.6.12 <0.9.0;

interface ISpokeToken {
    /// @notice Mints `_amount` tokens to `_account`, only callable by the minter.
    /// @param _account The address to receive the minted tokens.
    /// @param _amount The amount of tokens to mint.
    function mint(address _account, uint256 _amount) external;

    /// @notice Sets a new minter address, only callable by the contract owner.
    /// @param newMinter The address of the new minter.
    function setMinter(address newMinter) external;

    /// @notice Emitted when a new minter is set.
    /// @param newMinter The address of the new minter.
    event NewMinter(address indexed newMinter);

    function balanceOf(address owner) external view returns(uint256);
    function minter() external view returns(address);
    function owner() external view returns(address);


}
