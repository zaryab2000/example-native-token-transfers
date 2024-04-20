// SPDX-License-Identifier: Apache 2
pragma solidity >=0.8.8 <0.9.0;

/***
 * @notice Dummy contract to TEST NTT Bridging of Token and MSG Payload
 * @dev Address BSC Token: 0xbbafb3A71819FA7549B000D5bF46EDE74BC4513e
 * @dev Address Sepolia Token: 0x37c779a1564DCc0e3914aB130e0e787d93e21804
 * @dev Address BSC NTT Manager: 0x83dcFc1CEf7E4c09cD570C9d7f142Ad8061298B3
 * @dev Address BSC Transceiver: 0x753BB57fF69e66C407dE983A840CE98D5e0578cC
 */


// Required Features
// 1. Function to Bridge Token from BSC to Sepolia
// 2. Function to Bridge Token + Msg From BSC To SEPOLIA
// 3. Function to send token + msg from BSC TO SEPOLIA

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {INttManager} from "../../../src/interfaces/INttManager.sol";
import {IManagerBase} from "../../../src/interfaces/IManagerBase.sol";
import {IWormholeTransceiver} from "../../../src/interfaces/IWormholeTransceiver.sol";
import {ITransceiver} from "../../../src/interfaces/ITransceiver.sol";
import "../../src/../libraries/TransceiverStructs.sol";

import "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";

contract PayloadMessageSender {
    uint256 public version = 2;

    uint256 constant GAS_LIMIT = 200_000;
    
    uint16 public recipientChain = 10002;
    address BSC_TOKEN = 0x78a86E1fF1359A7D1eAC4A937Bdb9D4650143d56;
    address NTT_MANAGER_BSC = 0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837;
    address Transceiver_BSC = 0xdd6960dd26896D6e2CD903fAf9bf62fFF2c9563e;
    address adminDeployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
    
    // Message Sending Preparation
    address public _wormholeRelayerAddressBSC = 0x80aC94316391752A193C1c47E27D382b507c93F3;
    address public _wormholeRelayerAddressETH = 0x7B1bD7a6b4E61c2a123AC6BC2cbfC614437D0470;

    IWormholeRelayer public wormholeRelayer = IWormholeRelayer(_wormholeRelayerAddressBSC);
    IWormholeRelayer public wormholeRelayerETH = IWormholeRelayer(_wormholeRelayerAddressBSC);

     struct Channel {
        string callerAddress;
        uint8 channelState;
        address verifiedBy;
        bool isVerified;
        uint256 magicValData;
        bytes4 functionSignature;
    }

    function buildTransceiverInstruction(bool relayer_off)
        public
        view
        returns (TransceiverStructs.TransceiverInstruction memory)
    {
        IWormholeTransceiver wormholeTransceiverBSC = IWormholeTransceiver(Transceiver_BSC);

        IWormholeTransceiver.WormholeTransceiverInstruction memory instruction = IWormholeTransceiver.WormholeTransceiverInstruction(relayer_off);
        bytes memory instructionData = wormholeTransceiverBSC.encodeWormholeTransceiverInstruction(instruction);
       
        return TransceiverStructs.TransceiverInstruction({
            index: 0,
            payload: instructionData
        });
    }

    function quoteCrossChainGreeting(uint16 targetChain) public view returns (uint256 cost) {
        (cost,) = wormholeRelayer.quoteEVMDeliveryPrice(targetChain, 0, GAS_LIMIT);
    }
    function sendPushTokenWithMSG(address _to, uint256 _amount, Channel memory _channelData, address targetContractAddress) public payable{
        bytes32 recipient =  bytes32(uint256(uint160(_to)));       
        IERC20 token = IERC20(BSC_TOKEN);
        // Use the NTT Manager tranafer function to invoke the transfer
        INttManager ntt = INttManager(NTT_MANAGER_BSC);
        ITransceiver transceiverBSC = ITransceiver(Transceiver_BSC);

        // Calculate the cost of the message and the token bridging
        uint256 msgBridgeCost = quoteCrossChainGreeting(recipientChain);
        uint256 tokenBridgeCost = transceiverBSC.quoteDeliveryPrice(recipientChain, buildTransceiverInstruction(false));

        require(msg.value >= msgBridgeCost + tokenBridgeCost, "Insufficient funds to bridge message and token");

        // Take Tokens from user to PayloadSender Contract
        token.transferFrom(msg.sender, address(this), _amount);
        // Approve the NTT Manager
        token.approve(NTT_MANAGER_BSC, _amount);
    
        // Send the Token
        ntt.transfer{value:tokenBridgeCost}(_amount, recipientChain, recipient);
        // Send the message
        wormholeRelayer.sendPayloadToEvm{value: msgBridgeCost}(
            recipientChain,
            targetContractAddress,
            abi.encode(_channelData, msg.sender), // payload
            0, // no receiver value needed since we're just passing a message
            GAS_LIMIT,
            recipientChain, 
            adminDeployer 
        );
        
    }
    /**
     * @notice Send Tokens From BSC to ETHEREUM SEPOLIA
     */

    function sendPushTokensOnly(address _to, uint256 _amount) public payable{
        bytes32 recipient =  bytes32(uint256(uint160(_to)));       
        IERC20 token = IERC20(BSC_TOKEN);


        // Take Tokens from user to PayloadSender Contract
        token.transferFrom(msg.sender, address(this), _amount);

        // Approve the NTT Manager
        token.approve(NTT_MANAGER_BSC, _amount);

        // Use the NTT Manager tranafer function to invoke the transfer
        INttManager ntt = INttManager(NTT_MANAGER_BSC);
        ITransceiver transceiverBSC = ITransceiver(Transceiver_BSC);
        // Get Wormhole Instruction
       
        // Get the GAS COST
        uint256 totalPriceQuote = transceiverBSC.quoteDeliveryPrice(recipientChain, buildTransceiverInstruction(false));
        ntt.transfer{value:totalPriceQuote}(_amount, recipientChain, recipient);
    }

}