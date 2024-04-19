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

//Payload Deployed to : 0x301D8e51F2e2aA518960D9909d7656F32F2e0e0E
contract TokenTransferCheckBSC is Script {
    function run() external {
        vm.startBroadcast();

        uint256 initialSupply = 100 ether;
        IManagerBase nttManagerBase = IManagerBase(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        INttManager ntt = INttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);

        address deployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;


        IPayloadSender payloadSender = IPayloadSender(0x301D8e51F2e2aA518960D9909d7656F32F2e0e0E);

        uint256 versionData = payloadSender.version();
        console.log("Version is", versionData);

        string memory latestGreeting = payloadSender.latestGreeting();
        console.logString(latestGreeting);

        vm.stopBroadcast();
    }
}
// NotEnoughCapacity:  failed: custom error 26fb55dd:00000000000000000000000000000000…0000000000000003cb71f51fc5580000 (64 bytes)


// Commands to run the script
// forge script script/Temp/BSCPayloadSender.sol --rpc-url https://data-seed-prebsc-1-s1.bnbchain.org:8545 --private-key --broadcast  -vvv ffi