// script/MintToken.s.sol

pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../../src/interfaces/Temp/ITempNttManager.sol";
import "../../src/interfaces/INttManager.sol";
import "../../src/interfaces/IManagerBase.sol";

contract NTTManagerCall is Script {
    function run() external {
        vm.startBroadcast();

        IManagerBase nttManagerBase = IManagerBase(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        INttManager nttReal = INttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        ITempNttManager ntt = ITempNttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        address tokenAddress = ntt.token();

        //console.log("DEPLOYER After MINT IS", deployer);
        console.log("TOKENS IS", tokenAddress);

        // Get 
        INttManager.NttManagerPeer memory peer = nttReal.getPeer(4);
        bytes32 peerAddress = peer.peerAddress;
        uint decimals = peer.tokenDecimals;
        
        console.log("PEER DATA  IS", decimals);
        console.logBytes32(peerAddress);

        // Check Manager Base
        uint8 mode = nttManagerBase.getMode();
        console.log("MODE DATA  IS", mode);


        vm.stopBroadcast();
    }
}
