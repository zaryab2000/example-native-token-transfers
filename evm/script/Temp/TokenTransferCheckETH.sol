// script/MintToken.s.sol

pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../../src/interfaces/Temp/ITempNttManager.sol";
import "../../src/interfaces/INttManager.sol";
import "../../src/interfaces/IManagerBase.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract TokenTransferCheckETH is Script {
    function run() external {
        vm.startBroadcast();

        uint256 initialSupply = 100 ether;
        IManagerBase nttManagerBase = IManagerBase(0x71aA4f90F56434ef3bf740481974F2Ae6bCdb88c);
        INttManager nttReal = INttManager(0x71aA4f90F56434ef3bf740481974F2Ae6bCdb88c);
        ITempNttManager ntt = ITempNttManager(0x71aA4f90F56434ef3bf740481974F2Ae6bCdb88c);

        address deployer = 0xf6861DA1964BBdFE1f6942387EC967f820850162;
        address tokenAddress = ntt.token();

        //console.log("DEPLOYER After MINT IS", deployer);
        console.log("TOKENS IS", tokenAddress);

        // Get Toekn Balance of Sender
        IERC20 tokenContract = IERC20(tokenAddress);

        //tokenContract.mint(deployer, initialSupply);
        uint256 balanceOfDeployer = tokenContract.balanceOf(deployer);
        //address minter = tokenContract.minter();

        console.log("Initial Balance of USER", balanceOfDeployer);
       // console.log("MINTER ADDRESS is", minter);



        vm.stopBroadcast();
    }
}
