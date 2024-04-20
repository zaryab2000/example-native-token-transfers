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

//Payload Deployed to : 0x9cca7fedB4d52669107f4071B6ec5d08DE5f687C
contract TokenTransferCheckBSC is Script {
    function run() external {
        vm.startBroadcast();

        uint256 initialSupply = 100 ether;
        IManagerBase nttManagerBase = IManagerBase(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        INttManager ntt = INttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);

        address deployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
        address bob = 0x25d168F92E2EB8BfFA6570725DddD547176deab0;
        address alice = 0x7500A89e0EE75ab7d55787462b16Db0AF4AFe6a0;
        address tokenAddress = ntt.token();

        //console.log("DEPLOYER After MINT IS", deployer);
        console.log("TOKENS IS", tokenAddress);

        // Get Toekn Balance of Sender
        ISpokeToken tokenContract = ISpokeToken(tokenAddress);

        //tokenContract.mint(deployer, initialSupply);


        IPayloadSender payloadSender = IPayloadSender(0x9cca7fedB4d52669107f4071B6ec5d08DE5f687C);

        uint256 versionData = payloadSender.version();
        console.log("Version is", versionData);


        // TESTS


        // Transfer tokens from BOB to alice
        //tokenContract.transfer(alice, 10 ether);

        uint256 balanceOfBob = tokenContract.balanceOf(bob);
        uint256 balanceOfAlice = tokenContract.balanceOf(alice);

        console.log("Balance of Bob", balanceOfBob);
        console.log("Balance of Alice", balanceOfAlice);

        console.log("----------##################################-----------------");

        //tokenContract.setMinter(0xf6861DA1964BBdFE1f6942387EC967f820850162);
        address minterOfBSCToken = tokenContract.minter();
        console.log("Minter of BSC Token", minterOfBSCToken);

        // Check Allowance, Approve Allowance for NTT 
        uint256 gasAmount = 500000000000000000;
        uint256 amountToBridge = 10 ether;
        address recipient = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
        
        // Approval Checks 
        //tokenContract.approve(address(payloadSender), amountToBridge);
        //uint256 currentAllowance = tokenContract.allowance(alice, address(payloadSender));
        //console.log("Initial ALLOWANCE OF NTT MANAGER", currentAllowance);
        
        // // BRIDGE PUSH TOKENS 
       // payloadSender.sendPushTokensOnly{ value: gasAmount}(recipient, amountToBridge);
        
        // CUSTOM ERROR DEBUGGER 
        // bytes4 desiredSelector = bytes4(keccak256(bytes("NotEnoughCapacity(uint256,uint256)")));
        // console.logBytes4(desiredSelector);
        vm.stopBroadcast();
    }
}
// NotEnoughCapacity:  failed: custom error 26fb55dd:00000000000000000000000000000000…0000000000000003cb71f51fc5580000 (64 bytes)


// Commands to run the script
// forge script script/Temp/BSCPayloadSender.sol --rpc-url https://data-seed-prebsc-1-s1.bnbchain.org:8545 --private-key --broadcast  -vvv ffi