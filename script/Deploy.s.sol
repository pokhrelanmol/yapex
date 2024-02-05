// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console2} from "forge-std/Script.sol";
import {Pool} from "../src/Pool.sol";
import {Perp} from "../src/Perp.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract Deploy is Script {
    Pool public pool;
    Perp public perp;
    address wbtcUsdPriceFeed;
    address wbtc;
    address usdc;
    uint256 deployerKey;

    function run() public returns (Pool, Perp) {
        HelperConfig helperConfig = new HelperConfig();
        (wbtcUsdPriceFeed, wbtc, usdc, deployerKey) = helperConfig
            .activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        Pool pool = new Pool(usdc);
        Perp perp = new Perp(wbtcUsdPriceFeed, address(pool), usdc);
        vm.stopBroadcast();
        return (pool, perp);
    }
}

//DEPLOYED ADDRESS
//Pool: 0x7AFbBF267D6d8760dB7e72b3ba802c0dfCb703d3
//Perp: 0x4D6494b5174AE8590A57dF20717b3a966d90c23C
//PriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43
//WBTC: 0x825c0cFD4292EfAD0016f986DAa1e892B52034f0
//USDC: 0x3096e337c30d97152368b7c6a4ea37F2f3241899
