// script/MintToken.s.sol

pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../../src/interfaces/Temp/ITempNttManager.sol";
import "../../src/interfaces/INttManager.sol";
import "../../src/interfaces/IManagerBase.sol";
import {ISpokeToken} from "../../src/NTTPushBridgePOCs/ISpokeToken.sol";
import {IPayloadSimpleSender} from "../../src/NTTPushBridgePOCs/IPayloadSimpleSender.sol";

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

//Payload Deployed to : 0x6022e75241826D6b0e1B8c38185e9126F79Eaf2b
contract TokenTransferCheckBSC is Script {

    function run() external {
        vm.startBroadcast();

        IPayloadSimpleSender.Channel memory _channelData = IPayloadSimpleSender.Channel(
                                            "0xf6861DA1964BBdFE1f6942387EC967f820850162", 
                                            1, 
                                            0x74415Bc4C4Bf4Baecc2DD372426F0a1D016Fa924, 
                                            true, 
                                            786687, 
                                            0xe5632241);

        IManagerBase nttManagerBase = IManagerBase(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        INttManager ntt = INttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        address targetMessageContract = 0xF860F20fFf807041e214Fa722A877df9c456b6Fa;
        address deployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
        address tokenAddress = ntt.token();

        //console.log("DEPLOYER After MINT IS", deployer);
       // console.log("TOKENS IS", tokenAddress);

        // Get Toekn Balance of Sender
        ISpokeToken tokenContract = ISpokeToken(tokenAddress);
        IPayloadSimpleSender payloadSender = IPayloadSimpleSender(0x6022e75241826D6b0e1B8c38185e9126F79Eaf2b);

        // uint256 versionData = payloadSender.version();
        // console.log("Version is", versionData);

        // console.log("----------##################################-----------------");

        // tokenContract.setMinter(0xf6861DA1964BBdFE1f6942387EC967f820850162);
        // address minterOfBSCToken = tokenContract.minter();
        // console.log("Minter of BSC Token", minterOfBSCToken);

        // // Check Allowance, Approve Allowance for NTT 
        uint256 gasAmount = 100000000000000000;
        uint256 amountToBridge = 2 ether;
        // address recipient = 0x7C1B612e86D688f1A41Fa17DD9f80971bc754696;
        
    //     // Approval Checks 
   //     tokenContract.approve(address(payloadSender), amountToBridge);
    //    uint256 currentAllowance = tokenContract.allowance(deployer, address(payloadSender));
    //    console.log("Initial ALLOWANCE OF NTT MANAGER", currentAllowance);
        
    //     // // BRIDGE PUSH TOKENS 
    //     //payloadSender.sendPushTokensOnly{ value: gasAmount}(recipient, amountToBridge);
    payloadSender.sendPushTokenWithMSG{ value: gasAmount}(targetMessageContract, amountToBridge, _channelData, targetMessageContract);

    //     // CUSTOM ERROR DEBUGGER 
    //     // bytes4 desiredSelector = bytes4(keccak256(bytes("NotEnoughCapacity(uint256,uint256)")));
    //     // console.logBytes4(desiredSelector);
    //     vm.stopBroadcast();
    }
}
// NotEnoughCapacity:  failed: custom error 26fb55dd:00000000000000000000000000000000…0000000000000003cb71f51fc5580000 (64 bytes)


// Commands to run the script
// forge script script/Temp/BSCPayloadSender.sol --rpc-url https://data-seed-prebsc-1-s1.bnbchain.org:8545 --private-key --broadcast  -vvv ffi