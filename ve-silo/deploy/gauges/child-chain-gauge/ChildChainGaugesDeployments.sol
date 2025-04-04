// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.7.6;

import {KeyValueStorage} from "silo-foundry-utils/key-value/KeyValueStorage.sol";
import {AddrLib} from "silo-foundry-utils/lib/AddrLib.sol";

library ChildChainGaugesDeployments {
    string public constant DEPLOYMENTS_FILE =
        "ve-silo/deploy/gauges/child-chain-gauge/_childChainGaugesDeployments.json";

    function save(string memory _chain, string memory _configName, address _gauge) internal {
        KeyValueStorage.setAddress(DEPLOYMENTS_FILE, _chain, _configName, _gauge);
    }

    function get(string memory _chain, string memory _configName) internal returns (address) {
        address shared = AddrLib.getAddress(_configName);

        if (shared != address(0)) {
            return shared;
        }

        return KeyValueStorage.getAddress(DEPLOYMENTS_FILE, _chain, _configName);
    }
}
