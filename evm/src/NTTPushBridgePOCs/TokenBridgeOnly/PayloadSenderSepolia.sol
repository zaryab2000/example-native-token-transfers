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

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {INttManager} from "../../../src/interfaces/INttManager.sol";
import {IManagerBase} from "../../../src/interfaces/IManagerBase.sol";
import {IWormholeTransceiver} from "../../../src/interfaces/IWormholeTransceiver.sol";
import {ITransceiver} from "../../../src/interfaces/ITransceiver.sol";
import "../../../src/libraries/TransceiverStructs.sol";

contract PayloadSenderSepolia {
    uint256 public version = 1;
    address public SEPOLIA_TOKEN = 0x37c779a1564DCc0e3914aB130e0e787d93e21804;
    address public NTT_MANAGER_SEPOLIA = 0x71aA4f90F56434ef3bf740481974F2Ae6bCdb88c;
    address public Transceiver_SEPOLIA = 0x6E44b22d71918aE1c0A1d495a4F7103B46FB9B4d;

    
    function buildTransceiverInstruction(bool relayer_off)
        public
        view
        returns (TransceiverStructs.TransceiverInstruction memory)
    {
        IWormholeTransceiver wormholeTransceiverBSC = IWormholeTransceiver(Transceiver_SEPOLIA);

        IWormholeTransceiver.WormholeTransceiverInstruction memory instruction = IWormholeTransceiver.WormholeTransceiverInstruction(relayer_off);
        bytes memory instructionData = wormholeTransceiverBSC.encodeWormholeTransceiverInstruction(instruction);
       
        return TransceiverStructs.TransceiverInstruction({
            index: 0,
            payload: instructionData
        });
    }
    /**
     * @notice Send Tokens From BSC to ETHEREUM SEPOLIA
     */

    function sendPushTokensOnly(address _to, uint256 _amount) public payable{
        uint16 recipientChain = 4;
        bytes32 recipient =  bytes32(uint256(uint160(_to)));       
        IERC20 token = IERC20(SEPOLIA_TOKEN);


        // Take Tokens from user to PayloadSender Contract
        token.transferFrom(msg.sender, address(this), _amount);

        // Approve the NTT Manager
        token.approve(NTT_MANAGER_SEPOLIA, _amount);

        // Use the NTT Manager tranafer function to invoke the transfer
        INttManager ntt = INttManager(NTT_MANAGER_SEPOLIA);
        ITransceiver transceiverBSC = ITransceiver(Transceiver_SEPOLIA);
        // Get Wormhole Instruction
       
        // Get the GAS COST
        uint256 totalPriceQuote = transceiverBSC.quoteDeliveryPrice(recipientChain, buildTransceiverInstruction(false));
        ntt.transfer{value:totalPriceQuote}(_amount, recipientChain, recipient);
    }


}