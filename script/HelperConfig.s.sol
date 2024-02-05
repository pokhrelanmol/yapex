// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {Pool} from "../src/Pool.sol";
import {Perp} from "../src/Perp.sol";
import {USDCToken} from "../src/mock/USDCToken.sol";

import {WBTCToken} from "../src/mock/WBTCToken.sol";
import {MockV3Aggregator} from "../src/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address wbtcUsdPriceFeed;
        address wbtc;
        address usdc;
        uint256 deployerKey;
    }
    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant ETH_USD_PRICE = 2000e8;
    int256 public constant BTC_USD_PRICE = 1000e8;
    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory) {
        return
            NetworkConfig({
                wbtcUsdPriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43,
                wbtc: 0x825c0cFD4292EfAD0016f986DAa1e892B52034f0,
                usdc: 0x3096e337c30d97152368b7c6a4ea37F2f3241899,
                deployerKey: vm.envUint("PRIVATE_KEY")
            });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.wbtcUsdPriceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();

        MockV3Aggregator btcUsdPriceFeed = new MockV3Aggregator(
            DECIMALS,
            BTC_USD_PRICE
        );
        WBTCToken wbtcMock = new WBTCToken();
        USDCToken usdcMock = new USDCToken();

        vm.stopBroadcast();
        return
            NetworkConfig({
                wbtcUsdPriceFeed: address(btcUsdPriceFeed),
                wbtc: address(wbtcMock),
                usdc: address(usdcMock),
                deployerKey: DEFAULT_ANVIL_PRIVATE_KEY
            });
    }

    function run() public {}
}
