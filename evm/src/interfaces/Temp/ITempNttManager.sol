// SPDX-License-Identifier: Apache 2
pragma solidity >=0.8.8 <0.9.0;


interface ITempNttManager  {

    function deployer() external view returns(address);
    function token() external view returns(address);
    
}
