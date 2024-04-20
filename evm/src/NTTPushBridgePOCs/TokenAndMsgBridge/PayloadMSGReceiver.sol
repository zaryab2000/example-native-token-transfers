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
import "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";

contract PayloadMessageSender is IWormholeReceiver {
    uint256 public version = 2;

    uint16 public recipientChain = 10002;

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
    address public lastCaller;
    uint256 public magicValue;

    string public lastCallerAddressInStringFormat;
    mapping(address => Channel) public channels;


    function receiveWormholeMessages(
        bytes memory payload,
        bytes[] memory, // additionalVaas
        bytes32, // address that called 'sendPayloadToEvm' (HelloWormholeRefunds contract address)
        uint16 sourceChain,
        bytes32 // deliveryHash
    ) public payable override {
        require(msg.sender == address(_wormholeRelayerAddressETH), "Only relayer allowed");

        // Decode the payload
        (Channel memory decodedChannel, address sender) = abi.decode(payload, (Channel, address));
        lastCaller = sender;
        lastCallerAddressInStringFormat = decodedChannel.callerAddress;

        // Store the channel
        channels[sender] = decodedChannel;
        
        // Execute function selector
        if(decodedChannel.functionSignature != bytes4(0)) {
            (bool success, ) = address(this).call(abi.encodeWithSelector(decodedChannel.functionSignature, decodedChannel.magicValData));
            require(success, "Internal Function Execution failed");

        }
    }

    function getChannelData(address _channelOwner) public view returns(Channel memory) {
        return channels[_channelOwner];
    }

    function setMagicValue(uint256 _magicVal) public {
        magicValue = _magicVal;
    }


}