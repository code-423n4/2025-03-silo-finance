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

import "@balancer-labs/v2-interfaces/contracts/liquidity-mining/IVeDelegation.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IVault.sol";

import "@balancer-labs/v2-solidity-utils/contracts/helpers/SingletonAuthentication.sol";

contract VotingEscrowDelegationProxy is SingletonAuthentication {
    IERC20 private immutable _votingEscrow;
    IVeDelegation private _delegation;

    event DelegationImplementationUpdated(address indexed newImplementation);

    constructor(IVault vault, IERC20 votingEscrow, IVeDelegation delegation) SingletonAuthentication(vault) {
        _votingEscrow = votingEscrow;
        _delegation = delegation;
    }

    /**
     * @notice Returns the current delegation implementation contract.
     */
    function getDelegationImplementation() external view returns (IVeDelegation) {
        return _delegation;
    }

    /**
     * @notice Returns the Voting Escrow (veBAL) contract.
     */
    function getVotingEscrow() external view returns (IERC20) {
        return _votingEscrow;
    }

    /**
     * @notice Get the adjusted veBAL balance from the active boost delegation contract
     * @param user The user to query the adjusted veBAL balance of
     * @return veBAL balance
     */
    function adjustedBalanceOf(address user) external view returns (uint256) {
        return _adjustedBalanceOf(user);
    }

    /**
     * @notice Get the adjusted veBAL balance from the active boost delegation contract
     * @param user The user to query the adjusted veBAL balance of
     * @return veBAL balance
     */
    // solhint-disable-next-line func-name-mixedcase
    function adjusted_balance_of(address user) external view returns (uint256) {
        return _adjustedBalanceOf(user);
    }

    /**
     * @notice Get the current veBAL total supply from the votingEscrow contract.
     * @return The current veBAL total supply.
     */
    function totalSupply() external view returns (uint256) {
        IVeDelegation implementation = _delegation;
        if (implementation == IVeDelegation(0)) {
            return IERC20(_votingEscrow).totalSupply();
        }
        return implementation.totalSupply();
    }

    // Internal functions

    function _adjustedBalanceOf(address user) internal view returns (uint256) {
        IVeDelegation implementation = _delegation;
        if (implementation == IVeDelegation(0)) {
            return IERC20(_votingEscrow).balanceOf(user);
        }
        return implementation.adjusted_balance_of(user);
    }

    // Admin functions

    function setDelegation(IVeDelegation delegation) external authenticate {
        // call `adjusted_balance_of` to make sure it works
        delegation.adjusted_balance_of(msg.sender);

        _delegation = delegation;
        emit DelegationImplementationUpdated(address(delegation));
    }

    function killDelegation() external authenticate {
        _delegation = IVeDelegation(0);
        emit DelegationImplementationUpdated(address(0));
    }
}
