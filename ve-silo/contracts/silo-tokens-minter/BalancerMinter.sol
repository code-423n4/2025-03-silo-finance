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

pragma solidity 0.8.24;

import {IBalancerMinter, IERC20} from "./interfaces/IBalancerMinter.sol";
import {ISiloLiquidityGauge} from "ve-silo/contracts/gauges/interfaces/ISiloLiquidityGauge.sol";

import {Ownable} from "openzeppelin5/access/Ownable2Step.sol";
import {ReentrancyGuard} from "openzeppelin5/utils/ReentrancyGuard.sol";
import {EIP712} from "openzeppelin5/utils/cryptography/EIP712.sol";
import {SafeMath} from "ve-silo/contracts/utils/SafeMath.sol";
import {EOASignaturesValidator, Errors, _require} from "./helpers/EOASignaturesValidator.sol";

import {FeesManager} from "./FeesManager.sol";

abstract contract BalancerMinter is IBalancerMinter, ReentrancyGuard, EOASignaturesValidator, FeesManager {
    using SafeMath for uint256;

    IERC20 private immutable _token;

    // user -> gauge -> value
    mapping(address => mapping(address => uint256)) private _minted;
    mapping(address => mapping(address => uint256)) private _mintedToUser;
    // minter -> user -> can mint?
    mapping(address => mapping(address => bool)) private _allowedMinter;

    // solhint-disable-next-line var-name-mixedcase
    bytes32 private constant _SET_MINTER_APPROVAL_TYPEHASH =
        keccak256("SetMinterApproval(address minter,bool approval,uint256 nonce,uint256 deadline)");

    event MinterApprovalSet(address indexed user, address indexed minter, bool approval);

    event FeeCollected(
        address indexed gauge,
        address indexed daoReceiver,
        address indexed deployerReceiver,
        uint256 mintedToDao,
        uint256 mintedToDeployer
    );

    constructor(IERC20 token, string memory name, string memory version) EIP712(name, version) Ownable(msg.sender) {
        _token = token;
    }

    // solhint-disable ordering

    /// @inheritdoc IBalancerMinter
    function getBalancerToken() public view override returns (IERC20) {
        return _token;
    }

    /// @inheritdoc IBalancerMinter
    function mint(address gauge) external override nonReentrant returns (uint256) {
        return _mintFor(gauge, msg.sender);
    }

    /// @inheritdoc IBalancerMinter
    function mintMany(address[] calldata gauges) external override nonReentrant returns (uint256) {
        return _mintForMany(gauges, msg.sender);
    }

    /// @inheritdoc IBalancerMinter
    function mintFor(address gauge, address user) external override nonReentrant returns (uint256) {
        require(_allowedMinter[msg.sender][user], "Caller not allowed to mint for user");
        return _mintFor(gauge, user);
    }

    /// @inheritdoc IBalancerMinter
    function mintManyFor(address[] calldata gauges, address user) external override nonReentrant returns (uint256) {
        require(_allowedMinter[msg.sender][user], "Caller not allowed to mint for user");
        return _mintForMany(gauges, user);
    }

    /// @inheritdoc IBalancerMinter
    function minted(address user, address gauge) public view override returns (uint256) {
        return _minted[user][gauge];
    }

    /// @inheritdoc IBalancerMinter
    function mintedToUser(address user, address gauge) public view override returns (uint256) {
        return _mintedToUser[user][gauge];
    }

    /// @inheritdoc IBalancerMinter
    function getMinterApproval(address minter, address user) external view override returns (bool) {
        return _allowedMinter[minter][user];
    }

    /// @inheritdoc IBalancerMinter
    function setMinterApproval(address minter, bool approval) public override {
        _setMinterApproval(minter, msg.sender, approval);
    }

    /// @inheritdoc IBalancerMinter
    function setMinterApprovalWithSignature(
        address minter,
        bool approval,
        address user,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external override {
        bytes32 structHash = keccak256(
            abi.encode(_SET_MINTER_APPROVAL_TYPEHASH, minter, approval, getNextNonce(user), deadline)
        );

        _ensureValidSignature(user, structHash, _toArraySignature(v, r, s), deadline, Errors.INVALID_SIGNATURE);

        _setMinterApproval(minter, user, approval);
    }

    function _setMinterApproval(address minter, address user, bool approval) private {
        _allowedMinter[minter][user] = approval;
        emit MinterApprovalSet(user, minter, approval);
    }

    // Internal functions

    function _setMinted(address user, address gauge, uint256 value) internal {
        _minted[user][gauge] = value;
        emit Minted(user, gauge, value);
    }

    function _addMintedToUser(address user, address gauge, uint256 value) internal {
        uint256 totalMintedToUser = _mintedToUser[user][gauge] + value;
        _mintedToUser[user][gauge] = totalMintedToUser;

        emit MintedToUser(user, gauge, totalMintedToUser);
    }

    function _mintFor(address gauge, address user) internal virtual returns (uint256 tokensToMint);

    function _mint(address user, uint256 tokensToMint) internal virtual;

    function _mintForMany(address[] calldata gauges, address user) internal virtual returns (uint256 tokensToMint);

    // The below functions are near-duplicates of functions available above.
    // They are included for ABI compatibility with snake_casing as used in vyper contracts.
    // solhint-disable func-name-mixedcase

    /// @inheritdoc IBalancerMinter
    function allowed_to_mint_for(address minter, address user) external view override returns (bool) {
        return _allowedMinter[minter][user];
    }

    /// @inheritdoc IBalancerMinter
    function mint_many(address[8] calldata gauges) external override nonReentrant {
        for (uint256 i = 0; i < 8; ++i) {
            if (gauges[i] == address(0)) {
                break;
            }
            _mintFor(gauges[i], msg.sender);
        }
    }

    /// @inheritdoc IBalancerMinter
    function mint_for(address gauge, address user) external override nonReentrant {
        if (_allowedMinter[msg.sender][user]) {
            _mintFor(gauge, user);
        }
    }

    /// @inheritdoc IBalancerMinter
    function toggle_approve_mint(address minter) external override {
        setMinterApproval(minter, !_allowedMinter[minter][msg.sender]);
    }

    /// @notice Calculates and collects fees for the DAO and for the gauge deployer
    /// @param gauge Address of the gauge that incentives to be minted for
    /// @param totalTokensToMint Total tokens to be minted for a user
    /// @return tokensToMint Amount of tokens to be minted after the fee is deducted
    function _collectFees(address gauge, uint256 totalTokensToMint) internal returns (uint256 tokensToMint) {
        if (totalTokensToMint == 0) return 0;

        address daoFeeReceiver;
        address deployerFeeReceiver;

        (daoFeeReceiver, deployerFeeReceiver) = ISiloLiquidityGauge(gauge).getFeeReceivers();

        uint256 mintedToDao = _calculateFeeAndMint(daoFeeReceiver, totalTokensToMint, daoFee);
        uint256 mintedToDeployer = _calculateFeeAndMint(deployerFeeReceiver, totalTokensToMint, deployerFee);

        tokensToMint = totalTokensToMint;

        if (mintedToDao != 0 || mintedToDeployer != 0) {
            unchecked {
                // `mintedToDao` + `mintedToDeployer` <= `tokensToMint`
                tokensToMint -= (mintedToDao + mintedToDeployer);
            }

            emit FeeCollected(gauge, daoFeeReceiver, deployerFeeReceiver, mintedToDao, mintedToDeployer);
        }
    }

    /// @notice Calculate a fee and mint tokens
    /// @param feeReceiver Fee receiver
    /// @param totalTokensToMint Total tokens that we will mint for the user
    /// @param bps Fee percentage in basis points (1e4 == 100%)
    /// @return fee Collected fee for the `feeReceiver`
    function _calculateFeeAndMint(
        address feeReceiver,
        uint256 totalTokensToMint,
        uint256 bps
    ) internal returns (uint256 fee) {
        if (bps == 0 || feeReceiver == address(0)) return 0;

        fee = totalTokensToMint * bps;
        // Safe math makes no sense. In the worst case, we may end up with `0`
        unchecked {
            fee = fee / 1e4;
        }

        _mint(feeReceiver, fee);
    }
}
