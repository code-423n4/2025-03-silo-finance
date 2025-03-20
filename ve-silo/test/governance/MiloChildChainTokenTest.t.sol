// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.24;

import {IERC20} from "openzeppelin5/token/ERC20/ERC20.sol";

import {ChildChainTokenTest} from "./ChildChainTokenTest.t.sol";
import {MiloTokenChildChainDeploy} from "ve-silo/deploy/MiloTokenChildChainDeploy.s.sol";

// FOUNDRY_PROFILE=ve-silo-test forge test --mc MiloChildChainTokenTest --ffi -vvv
contract MiloChildChainTokenTest is ChildChainTokenTest {
    function _deployToken() internal override {
        MiloTokenChildChainDeploy deployment = new MiloTokenChildChainDeploy();
        deployment.disableDeploymentsSync();

        _token = deployment.run();
    }

    function _network() internal pure override returns (string memory) {
        return OPTIMISM_ALIAS;
    }

    function _forkingBlockNumber() internal pure override returns (uint256) {
        return 121673490;
    }

    function _symbol() internal pure override returns (string memory) {
        return "MILO";
    }

    function _name() internal pure override returns (string memory) {
        return "Milo";
    }

    function _decimals() internal pure override returns (uint8) {
        return 18;
    }
}
