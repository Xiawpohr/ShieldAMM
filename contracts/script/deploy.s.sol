// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";
import {MockToken} from "../src/MockToken.sol";
import {IHasher} from "../src/MerkleTreeWithHistory.sol";
import {IVerifier, ShieldAMM} from "../src/ShieldAMM.sol";
import {DepositUltraVerifier} from "../src/plonk_vk_deposit.sol";
import {SwapUltraVerifier} from "../src/plonk_vk_swap.sol";
import {AddLiquidityUltraVerifier} from "../src/plonk_vk_add_liquidity.sol";
import {RemoveLiquidityUltraVerifier} from "../src/plonk_vk_remove_liquidity.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address hasherAddress = vm.envAddress("HASH_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        ERC20 baseToken = new MockToken("Base Token", "BASE", 4);
        ERC20 quoteToken = new MockToken("Quote Token", "QUOTE", 4);
        IVerifier depositVerifier = IVerifier(address(new DepositUltraVerifier()));
        IVerifier swapVerifier = IVerifier(address(new SwapUltraVerifier()));
        IVerifier addLiquidityVerifier = IVerifier(address(new AddLiquidityUltraVerifier()));
        IVerifier removeLiquidityVerifier = IVerifier(address(new RemoveLiquidityUltraVerifier()));

        ShieldAMM exchange = new ShieldAMM(
            baseToken,
            quoteToken,
            depositVerifier,
            swapVerifier,
            addLiquidityVerifier,
            removeLiquidityVerifier,
            IHasher(hasherAddress)
        );

        vm.stopBroadcast();
    }
}
