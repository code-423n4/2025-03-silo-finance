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
pragma experimental ABIEncoderV2;

import "@balancer-labs/v2-interfaces/contracts/solidity-utils/openzeppelin/IERC20.sol";

import "@balancer-labs/v2-interfaces/contracts/vault/IVault.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IBasePool.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IGeneralPool.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IPoolSwapStructs.sol";
import "@balancer-labs/v2-interfaces/contracts/vault/IMinimalSwapInfoPool.sol";

import "@balancer-labs/v2-vault/contracts/ProtocolFeesCollector.sol";

contract MockVault is IPoolSwapStructs {
    struct Pool {
        IERC20[] tokens;
        mapping(IERC20 => uint256) cash;
        mapping(IERC20 => uint256) managed;
    }

    IAuthorizer private _authorizer;
    IProtocolFeesCollector private _protocolFeesCollector;

    mapping(bytes32 => Pool) private pools;

    event Swap(
        bytes32 indexed poolId,
        IERC20 indexed tokenIn,
        IERC20 indexed tokenOut,
        uint256 amountIn,
        uint256 amountOut
    );

    event PoolBalanceChanged(
        bytes32 indexed poolId,
        address indexed liquidityProvider,
        IERC20[] tokens,
        int256[] deltas,
        uint256[] protocolFeeAmounts
    );

    constructor(IAuthorizer authorizer) {
        _authorizer = authorizer;
        _protocolFeesCollector = new ProtocolFeesCollector(IVault(address(this)));
    }

    function getAuthorizer() external view returns (IAuthorizer) {
        return _authorizer;
    }

    function getProtocolFeesCollector() public view returns (IProtocolFeesCollector) {
        return _protocolFeesCollector;
    }

    function getPoolTokens(bytes32 poolId) external view returns (IERC20[] memory tokens, uint256[] memory balances) {
        Pool storage pool = pools[poolId];
        tokens = new IERC20[](pool.tokens.length);
        balances = new uint256[](pool.tokens.length);

        for (uint256 i = 0; i < pool.tokens.length; i++) {
            tokens[i] = pool.tokens[i];
            balances[i] = pool.cash[tokens[i]] + pool.managed[tokens[i]];
        }
    }

    function getPoolTokenInfo(
        bytes32 poolId,
        IERC20 token
    ) external view returns (uint256 cash, uint256 managed, uint256, address) {
        Pool storage pool = pools[poolId];
        cash = pool.cash[token];
        managed = pool.managed[token];
    }

    function registerPool(IVault.PoolSpecialization) external view returns (bytes32) {
        // solhint-disable-previous-line no-empty-blocks
    }

    function registerTokens(bytes32 poolId, IERC20[] memory tokens, address[] memory) external {
        Pool storage pool = pools[poolId];
        for (uint256 i = 0; i < tokens.length; i++) {
            pool.tokens.push(tokens[i]);
        }
    }

    function updateCash(bytes32 poolId, uint256[] memory cash) external {
        Pool storage pool = pools[poolId];
        for (uint256 i = 0; i < cash.length; i++) {
            pool.cash[pool.tokens[i]] = cash[i];
        }
    }

    function updateManaged(bytes32 poolId, uint256[] memory managed) external {
        Pool storage pool = pools[poolId];
        for (uint256 i = 0; i < managed.length; i++) {
            pool.managed[pool.tokens[i]] = managed[i];
        }
    }

    function callMinimalPoolSwap(
        address pool,
        SwapRequest memory request,
        uint256 balanceTokenIn,
        uint256 balanceTokenOut
    ) external {
        uint256 amountCalculated = IMinimalSwapInfoPool(pool).onSwap(request, balanceTokenIn, balanceTokenOut);
        (uint256 amountIn, uint256 amountOut) = request.kind == IVault.SwapKind.GIVEN_IN
            ? (request.amount, amountCalculated)
            : (amountCalculated, request.amount);
        emit Swap(request.poolId, request.tokenIn, request.tokenOut, amountIn, amountOut);
    }

    function callGeneralPoolSwap(
        address pool,
        SwapRequest memory request,
        uint256[] memory balances,
        uint256 indexIn,
        uint256 indexOut
    ) external {
        uint256 amountCalculated = IGeneralPool(pool).onSwap(request, balances, indexIn, indexOut);
        (uint256 amountIn, uint256 amountOut) = request.kind == IVault.SwapKind.GIVEN_IN
            ? (request.amount, amountCalculated)
            : (amountCalculated, request.amount);
        emit Swap(request.poolId, request.tokenIn, request.tokenOut, amountIn, amountOut);
    }

    function callJoinPool(
        address poolAddress,
        bytes32 poolId,
        address recipient,
        uint256[] memory currentBalances,
        uint256 lastChangeBlock,
        uint256 protocolFeePercentage,
        bytes memory userData
    ) external {
        (uint256[] memory amountsIn, uint256[] memory dueProtocolFeeAmounts) = IBasePool(poolAddress).onJoinPool(
            poolId,
            msg.sender,
            recipient,
            currentBalances,
            lastChangeBlock,
            protocolFeePercentage,
            userData
        );

        Pool storage pool = pools[poolId];
        for (uint256 i = 0; i < pool.tokens.length; i++) {
            pool.cash[pool.tokens[i]] += amountsIn[i];
        }

        IERC20[] memory tokens = new IERC20[](currentBalances.length);
        int256[] memory deltas = new int256[](amountsIn.length);
        for (uint256 i = 0; i < amountsIn.length; ++i) {
            deltas[i] = int256(amountsIn[i]);
        }

        emit PoolBalanceChanged(poolId, msg.sender, tokens, deltas, dueProtocolFeeAmounts);
    }

    function callExitPool(
        address poolAddress,
        bytes32 poolId,
        address recipient,
        uint256[] memory currentBalances,
        uint256 lastChangeBlock,
        uint256 protocolFeePercentage,
        bytes memory userData
    ) external {
        (uint256[] memory amountsOut, uint256[] memory dueProtocolFeeAmounts) = IBasePool(poolAddress).onExitPool(
            poolId,
            msg.sender,
            recipient,
            currentBalances,
            lastChangeBlock,
            protocolFeePercentage,
            userData
        );

        Pool storage pool = pools[poolId];
        for (uint256 i = 0; i < pool.tokens.length; i++) {
            pool.cash[pool.tokens[i]] -= amountsOut[i];
        }

        IERC20[] memory tokens = new IERC20[](currentBalances.length);
        int256[] memory deltas = new int256[](amountsOut.length);
        for (uint256 i = 0; i < amountsOut.length; ++i) {
            deltas[i] = int256(-amountsOut[i]);
        }

        emit PoolBalanceChanged(poolId, msg.sender, tokens, deltas, dueProtocolFeeAmounts);
    }

    // Needed to support authorizer adaptor entrypoint
    function getActionId(bytes4 selector) public view returns (bytes32) {
        return keccak256(abi.encodePacked(bytes32(uint256(address(this))), selector));
    }

    function setAuthorizer(IAuthorizer newAuthorizer) external {
        _authorizer = newAuthorizer;
    }

    // This supports calls from the VaultReentrancyLib in unit tests, so that they don't revert.
    // Note that it isn't itself protected by the Vault context, like the real Vault would be.
    function manageUserBalance(IVault.UserBalanceOp[] memory ops) external payable {
        // solhint-disable-previous-line no-empty-blocks
    }
}
