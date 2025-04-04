// SPDX-License-Identifier: GPL-3.0-or-later
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

pragma solidity ^0.7.0;

import "../BaseGaugeFactory.sol";
import "./GnosisRootGauge.sol";

contract GnosisRootGaugeFactory is BaseGaugeFactory {
    constructor(
        IMainnetBalancerMinter minter,
        IGnosisBridge gnosisBridge
    ) BaseGaugeFactory(address(new GnosisRootGauge(minter, gnosisBridge))) {
        // solhint-disable-previous-line no-empty-blocks
    }

    /**
     * @notice Deploys a new gauge which bridges all of its BAL allowance to a single recipient on Gnosis.
     * @dev Care must be taken to ensure that gauges deployed from this factory are suitable before they are
     * added to the GaugeController.
     * @param recipient The address to receive BAL minted from the gauge
     * @param relativeWeightCap The relative weight cap for the created gauge (18-decimal FP value from 0 to 1)
     * @return The address of the deployed gauge
     */
    function create(address recipient, uint256 relativeWeightCap) external returns (address) {
        address gauge = _create();
        GnosisRootGauge(gauge).initialize(recipient, relativeWeightCap);
        return gauge;
    }
}
