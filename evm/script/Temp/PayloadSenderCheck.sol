// script/MintToken.s.sol

pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../../src/interfaces/Temp/ITempNttManager.sol";
import "../../src/interfaces/INttManager.sol";
import "../../src/interfaces/IManagerBase.sol";
import {ISpokeToken} from "../../src/BridgeDemo/ISpokeToken.sol";
import {IPayloadSender} from "../../src/BridgeDemo/IPayloadSender.sol";


/**
 * @title Aim is to check:
 * First: Approve the NTT Manager of BSC Chain from SCRIPT for Deployer
 * Then: Use PayloadSender contract to call sendPushTokensOnly() by passing 10 Tokens to a Different Address
 * Then Check the following:
 * BSC Token Gets bridged from BSC to ETH Sepolia
 * Balance of Sender Gets reduced by 10 - Spoke Token Gets BURNT on BSC
 * Balance of Receiver gets increases by 10
 * Balance of NTT Manager on Sepolia becomes less by 10
 * Identify and Document Issues if any
 */

//Payload Deployed to : 0x9cca7fedB4d52669107f4071B6ec5d08DE5f687C
contract TokenTransferCheckBSC is Script {
    function run() external {
        vm.startBroadcast();

        uint256 initialSupply = 100 ether;
        IManagerBase nttManagerBase = IManagerBase(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        INttManager ntt = INttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);

        address deployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
        address tokenAddress = ntt.token();

        //console.log("DEPLOYER After MINT IS", deployer);
        console.log("TOKENS IS", tokenAddress);

        // Get Toekn Balance of Sender
        ISpokeToken tokenContract = ISpokeToken(tokenAddress);

        //tokenContract.mint(deployer, initialSupply);
        uint256 balanceOfDeployer = tokenContract.balanceOf(deployer);

        console.log("Initial Balance of USER", balanceOfDeployer);
        console.log("----------##################################-----------------");

        IPayloadSender payloadSender = IPayloadSender(0x9cca7fedB4d52669107f4071B6ec5d08DE5f687C);

        uint256 versionData = payloadSender.version();
        console.log("Version is", versionData);

        // Check Allowance, Approve Allowance for NTT 
        uint256 gasAmount = 500000000000000000;
        uint256 amountToBridge = 5 ether;
        address recipient = 0x7500A89e0EE75ab7d55787462b16Db0AF4AFe6a0;
        // tokenContract.approve(address(payloadSender), amountToBridge);

        uint256 currentAllowance = tokenContract.allowance(deployer, address(payloadSender));
        console.log("Initial ALLOWANCE OF NTT MANAGER", currentAllowance);
        
        // BRIDGE PUSH TOKENS 
       payloadSender.sendPushTokensOnly{ value: gasAmount}(recipient, amountToBridge);

        vm.stopBroadcast();
    }
}
