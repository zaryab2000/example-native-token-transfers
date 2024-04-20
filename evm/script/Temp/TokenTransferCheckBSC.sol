// script/MintToken.s.sol

pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../../src/interfaces/Temp/ITempNttManager.sol";
import "../../src/interfaces/INttManager.sol";
import "../../src/interfaces/IManagerBase.sol";
import {ISpokeToken} from "../../src/NTTPushBridgePOCs/ISpokeToken.sol";


contract TokenTransferCheckBSC is Script {
    function run() external {
        vm.startBroadcast();

        uint256 initialSupply = 100 ether;
        IManagerBase nttManagerBase = IManagerBase(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        INttManager nttReal = INttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);
        ITempNttManager ntt = ITempNttManager(0xe13510bd0435a38A40FC5aFB09C86e2C1b05b837);

        address deployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
        address tokenAddress = ntt.token();

        //console.log("DEPLOYER After MINT IS", deployer);
        console.log("TOKENS IS", tokenAddress);

        // Get Toekn Balance of Sender
        ISpokeToken tokenContract = ISpokeToken(tokenAddress);

        //tokenContract.mint(deployer, initialSupply);
        uint256 balanceOfDeployer = tokenContract.balanceOf(deployer);
        address minter = tokenContract.minter();

        console.log("Initial Balance of USER", balanceOfDeployer);
        console.log("MINTER ADDRESS is", minter);



        vm.stopBroadcast();
    }
}
