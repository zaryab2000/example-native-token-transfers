// script/MintToken.s.sol

pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../../src/interfaces/Temp/ITempNttManager.sol";
import "../../src/interfaces/INttManager.sol";
import "../../src/interfaces/IManagerBase.sol";
import {ISpokeToken} from "../../src/NTTPushBridgePOCs/ISpokeToken.sol";
import {IPayloadSender} from "../../src/NTTPushBridgePOCs/IPayloadSender.sol";


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

//Payload Deployed to : 0x91eBC677C5009b57238eE8BeeA201C62cdEf8b44
contract TokenTransferCheckSepolia is Script {
    function run() external {
        vm.startBroadcast();

        uint256 initialSupply = 100 ether;
        IManagerBase nttManagerBase = IManagerBase(0x71aA4f90F56434ef3bf740481974F2Ae6bCdb88c);
        INttManager ntt = INttManager(0x71aA4f90F56434ef3bf740481974F2Ae6bCdb88c);

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

        IPayloadSender payloadSender = IPayloadSender(0x91eBC677C5009b57238eE8BeeA201C62cdEf8b44);

        uint256 versionData = payloadSender.version();
        console.log("Version is", versionData);

        address tokenOfPayload = payloadSender.SEPOLIA_TOKEN();
        console.log("Token of Payload is", tokenOfPayload);

        // // Check Allowance, Approve Allowance for NTT 
        uint256 gasAmount = 500000000000000000;
        uint256 amountToBridge = 2 ether;
        address recipient = 0x25d168F92E2EB8BfFA6570725DddD547176deab0;
        //tokenContract.approve(address(payloadSender), amountToBridge);

        // uint256 currentAllowance = tokenContract.allowance(deployer, address(payloadSender));
        // console.log("Initial ALLOWANCE OF PAYLOAD SENDER SEPOLIA", currentAllowance);
        
        // // BRIDGE PUSH TOKENS 
        payloadSender.sendPushTokensOnly{ value: gasAmount}(recipient, amountToBridge);
        
        // CUSTOM ERROR DEBUGGER 
        // bytes4 desiredSelector = bytes4(keccak256(bytes("NotEnoughCapacity(uint256,uint256)")));
        // console.logBytes4(desiredSelector);
        vm.stopBroadcast();
    }
}
// NotEnoughCapacity:  failed: custom error 26fb55dd:00000000000000000000000000000000…0000000000000003cb71f51fc5580000 (64 bytes)

// Command to run the script
// forge script script/Temp/SepoliaPayloadSender.sol --rpc-url --private-key --broadcast  -vvv ffi