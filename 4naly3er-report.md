# Report


## Gas Optimizations


| |Issue|Instances|
|-|:-|:-:|
| [GAS-1](#GAS-1) | Don't use `_msgSender()` if not supporting EIP-2771 | 22 |
| [GAS-2](#GAS-2) | `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings) | 13 |
| [GAS-3](#GAS-3) | Using bools for storage incurs overhead | 8 |
| [GAS-4](#GAS-4) | Cache array length outside of loop | 18 |
| [GAS-5](#GAS-5) | For Operations that will not overflow, you could use unchecked | 190 |
| [GAS-6](#GAS-6) | Avoid contract existence checks by using low level calls | 5 |
| [GAS-7](#GAS-7) | Functions guaranteed to revert when called by normal users can be marked `payable` | 23 |
| [GAS-8](#GAS-8) | `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`) | 15 |
| [GAS-9](#GAS-9) | Using `private` rather than `public` for constants, saves gas | 3 |
| [GAS-10](#GAS-10) | Use shift right/left instead of division/multiplication if possible | 1 |
| [GAS-11](#GAS-11) | Splitting require() statements that use && saves gas | 1 |
| [GAS-12](#GAS-12) | Increments/decrements can be unchecked in for-loops | 24 |
| [GAS-13](#GAS-13) | Use != 0 instead of > 0 for unsigned integer comparison | 11 |
### <a name="GAS-1"></a>[GAS-1] Don't use `_msgSender()` if not supporting EIP-2771
Use `msg.sender` if the code does not implement [EIP-2771 trusted forwarder](https://eips.ethereum.org/EIPS/eip-2771) support

*Instances (22)*:
```solidity
File: ./silo-vaults/contracts/SiloVault.sol

133:         address sender = _msgSender();

141:         address sender = _msgSender();

151:         if (_msgSender() != owner() && _msgSender() != guardian) revert ErrorsLib.NotGuardianRole();

158:         if (_msgSender() != guardian && _msgSender() != curator && _msgSender() != owner()) {

220:         emit EventsLib.SetFee(_msgSender(), fee);

265:             emit EventsLib.SubmitCap(_msgSender(), _market, _newSupplyCap);

279:         emit EventsLib.SubmitMarketRemoval(_msgSender(), _market);

299:         emit EventsLib.SetSupplyQueue(_msgSender(), _newSupplyQueue);

346:         emit EventsLib.SetWithdrawQueue(_msgSender(), newWithdrawQueue);

397:                 emit EventsLib.ReallocateWithdraw(_msgSender(), allocation.market, withdrawnAssets, withdrawnShares);

421:                 emit EventsLib.ReallocateSupply(_msgSender(), allocation.market, suppliedAssets, suppliedShares);

438:         emit EventsLib.RevokePendingTimelock(_msgSender());

445:         emit EventsLib.RevokePendingGuardian(_msgSender());

452:         emit EventsLib.RevokePendingCap(_msgSender(), _market);

459:         emit EventsLib.RevokePendingMarketRemoval(_msgSender(), _market);

580:         _deposit(_msgSender(), _receiver, _assets, shares);

597:         _deposit(_msgSender(), _receiver, assets, _shares);

619:         _withdraw(_msgSender(), _receiver, _owner, _assets, shares);

641:         _withdraw(_msgSender(), _receiver, _owner, assets, _shares);

835:         emit EventsLib.SetTimelock(_msgSender(), _newTimelock);

844:         emit EventsLib.SetGuardian(_msgSender(), _newGuardian);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

35:         if (_msgSender() != owner() && _msgSender() != guardian) revert ErrorsLib.NotGuardianRole();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="GAS-2"></a>[GAS-2] `a = a + b` is more gas effective than `a += b` for state variables (excluding arrays and mappings)
This saves **16 gas per instance.**

*Instances (13)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

56:                 _totalSupply += _amount;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

111:             unclaimedRewards += _getRewardsBalance(_user, programId, stakedByUser, totalStaked);

123:         unclaimedRewards += _getUnclaimedRewards(_programId, _user, _stakedByUser, _totalStaked);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

315:         newIndex += currentIndex;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

100:         if (msg.value > 0) accruedFee[vault] += msg.value;

128:             flowCaps[vault][market].maxIn += withdrawal.amount;

133:             totalWithdrawn += withdrawal.amount;

141:         flowCaps[vault][supplyMarket].maxOut += totalWithdrawn;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

399:                 totalWithdrawn += withdrawnAssets;

423:                 totalSupplied += suppliedAssets;

650:             assets += _expectedSupplyAssets(market, address(this));

699:             totalSuppliable += Math.min(suppliable, internalSuppliable);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

171:                 totalLogics += _claimingLogics[IERC4626(_marketsInput[i])].length();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="GAS-3"></a>[GAS-3] Using bools for storage incurs overhead
Use uint256(1) and uint256(2) for true/false to avoid a Gwarmaccess (100 gas), and to avoid Gsset (20000 gas) when changing from ‘false’ to ‘true’, after having been ‘true’ in the past. See [source](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/58f635312aa21f947cae5f8578638a85aa2519f5/contracts/security/ReentrancyGuard.sol#L23-L27).

*Instances (8)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol

10:     mapping(address => bool) public isSiloIncentivesController;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol

18:     bool internal _isKilled;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol

9:     mapping(address => bool) public createdInFactory;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol)

```solidity
File: ./silo-vaults/contracts/IdleVaultsFactory.sol

17:     mapping(address => bool) public isIdleVault;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

56:     mapping(address => bool) public isAllocator;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/SiloVaultsFactory.sol

24:     mapping(address => bool) public isSiloVault;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol

9:     mapping(address => bool) public createdInFactory;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

19:         mapping(address => bool) storage _isAllocator

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="GAS-4"></a>[GAS-4] Cache array length outside of loop
If not cached, the solidity compiler will always read the length of the array during each iteration. That is, if it is a storage array, this is an extra sload operation (100 additional extra gas for each iteration except for the first) and if it is a memory array, this is an extra mload operation (3 additional gas for each iteration except for the first).

*Instances (18)*:
```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

100:         for (uint256 i = 0; i < _programNames.length; i++) {

232:         for (uint256 i = 0; i < accruedRewards.length; i++) {

292:         for (uint256 i = 0; i < _programIds.length; i++) {

307:         for (uint256 i = 0; i < _programNames.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

64:         for (uint256 i = 0; i < config.length; i++) {

112:         for (uint256 i = 0; i < withdrawals.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

357:         for (uint256 i; i < _allocations.length; ++i) {

648:         for (uint256 i; i < withdrawQueue.length; ++i) {

676:         for (uint256 i; i < supplyQueue.length; ++i) {

869:         for (uint256 i; i < supplyQueue.length; ++i) {

902:         for (uint256 i; i < withdrawQueue.length; ++i) {

1001:         for (uint256 i; i < receivers.length; i++) {

1017:         for (uint256 i; i < logics.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

168:         for (uint256 i = 0; i < _marketsInput.length; i++) {

178:         for (uint256 i = 0; i < _marketsInput.length; i++) {

181:             for (uint256 j = 0; j < marketLogics.length; j++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

28:         for (uint256 i = 0; i < accruedRewards.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

73:         for (uint256 i; i < _withdrawQueue.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="GAS-5"></a>[GAS-5] For Operations that will not overflow, you could use unchecked

*Instances (190)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

4: import {SafeERC20} from "openzeppelin5/token/ERC20/utils/SafeERC20.sol";

5: import {IERC20} from "openzeppelin5/token/ERC20/IERC20.sol";

6: import {EnumerableSet} from "openzeppelin5/utils/structs/EnumerableSet.sol";

7: import {Strings} from "openzeppelin5/utils/Strings.sol";

9: import {ISiloIncentivesController} from "./interfaces/ISiloIncentivesController.sol";

10: import {BaseIncentivesController} from "./base/BaseIncentivesController.sol";

11: import {DistributionTypes} from "./lib/DistributionTypes.sol";

50:                 _totalSupply -= _amount;

56:                 _totalSupply += _amount;

66:                 _senderBalance = _senderBalance + _amount;

74:                 _recipientBalance = _recipientBalance - _amount;

79:         for (uint256 i = 0; i < numberOfPrograms; i++) {

111:         program.lastUpdateTimestamp = uint40(block.timestamp - 1);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol

4: import {SiloIncentivesController} from "./SiloIncentivesController.sol";

5: import {ISiloIncentivesControllerFactory} from "./interfaces/ISiloIncentivesControllerFactory.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol

4: import {IERC20} from "openzeppelin5/token/ERC20/IERC20.sol";

6: import {IGaugeLike as IGauge} from "../interfaces/IGaugeLike.sol";

7: import {SiloIncentivesController} from "./SiloIncentivesController.sol";

8: import {ISiloIncentivesController} from "./interfaces/ISiloIncentivesController.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol

4: import {SiloIncentivesControllerGaugeLike} from "./SiloIncentivesControllerGaugeLike.sol";

5: import {ISiloIncentivesControllerGaugeLikeFactory} from "./interfaces/ISiloIncentivesControllerGaugeLikeFactory.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

4: import {IERC20} from "openzeppelin5/token/ERC20/IERC20.sol";

5: import {SafeERC20} from "openzeppelin5/token/ERC20/utils/SafeERC20.sol";

6: import {EnumerableSet} from "openzeppelin5/utils/structs/EnumerableSet.sol";

8: import {DistributionTypes} from "../lib/DistributionTypes.sol";

9: import {DistributionManager} from "./DistributionManager.sol";

10: import {ISiloIncentivesController} from "../interfaces/ISiloIncentivesController.sol";

100:         for (uint256 i = 0; i < _programNames.length; i++) {

111:             unclaimedRewards += _getRewardsBalance(_user, programId, stakedByUser, totalStaked);

123:         unclaimedRewards += _getUnclaimedRewards(_programId, _user, _stakedByUser, _totalStaked);

208:             uint256 newUnclaimedRewards = _usersUnclaimedRewards[_user][_incentivesProgramId] + accruedRewards;

232:         for (uint256 i = 0; i < accruedRewards.length; i++) {

235:             uint256 amountToClaim = accruedRewards[i].amount + unclaimedRewards;

292:         for (uint256 i = 0; i < _programIds.length; i++) {

307:         for (uint256 i = 0; i < _programNames.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

4: import {IERC20} from "openzeppelin5/token/ERC20/IERC20.sol";

5: import {IERC20Metadata} from "openzeppelin5/token/ERC20/extensions/IERC20Metadata.sol";

6: import {Math} from "openzeppelin5/utils/math/Math.sol";

8: import {Ownable2Step, Ownable} from "openzeppelin5/access/Ownable2Step.sol";

9: import {EnumerableSet} from "openzeppelin5/utils/structs/EnumerableSet.sol";

11: import {ISiloIncentivesController} from "../interfaces/ISiloIncentivesController.sol";

12: import {IDistributionManager} from "../interfaces/IDistributionManager.sol";

13: import {DistributionTypes} from "../lib/DistributionTypes.sol";

14: import {TokenHelper} from "../../lib/TokenHelper.sol";

29:     address public immutable NOTIFIER; // solhint-disable-line var-name-mixedcase

32:     uint256 public constant TEN_POW_PRECISION = 10 ** PRECISION;

107:         for (uint256 i = 0; i < length; i++) {

223:         for (uint256 i = 0; i < length; i++) {

282:         rewards = Math.mulDiv(principalUserBalance, (reserveIndex - userIndex), TEN_POW_PRECISION);

312:         uint256 timeDelta = currentTimestamp - lastUpdateTimestamp;

314:         newIndex = Math.mulDiv(emissionPerSecond * timeDelta, TEN_POW_PRECISION, totalBalance);

315:         newIndex += currentIndex;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/IDistributionManager.sol

4: import {DistributionTypes} from "../lib/DistributionTypes.sol";

9:         address rewardToken; // can't be updated after creation

10:         uint104 emissionPerSecond; // configured by owner

12:         uint40 distributionEnd; // configured by owner

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/IDistributionManager.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol

4: import {IDistributionManager} from "./IDistributionManager.sol";

5: import {DistributionTypes} from "../lib/DistributionTypes.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol)

```solidity
File: ./silo-vaults/contracts/IdleVault.sol

4: import {ERC20, ERC4626} from "openzeppelin5/token/ERC20/extensions/ERC4626.sol";

5: import {IERC4626, IERC20} from "openzeppelin5/interfaces/IERC4626.sol";

7: import {ErrorsLib} from "./libraries/ErrorsLib.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVault.sol)

```solidity
File: ./silo-vaults/contracts/IdleVaultsFactory.sol

4: import {Clones} from "openzeppelin5/proxy/Clones.sol";

5: import {IERC4626, IERC20Metadata} from "openzeppelin5/interfaces/IERC4626.sol";

7: import {ISiloVault} from "./interfaces/ISiloVault.sol";

8: import {ISiloVaultsFactory} from "./interfaces/ISiloVaultsFactory.sol";

10: import {EventsLib} from "./libraries/EventsLib.sol";

12: import {SiloVault} from "./SiloVault.sol";

13: import {IdleVault} from "./IdleVault.sol";

14: import {VaultIncentivesModule} from "./incentives/VaultIncentivesModule.sol";

24:             string.concat("IV-", IERC20Metadata(address(_vault)).symbol())

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

4: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

5: import {UtilsLib} from "morpho-blue/libraries/UtilsLib.sol";

7: import {RevertLib} from "silo-core/contracts/lib/RevertLib.sol";

9: import {FlowCaps, FlowCapsConfig, Withdrawal, MAX_SETTABLE_FLOW_CAP, IPublicAllocatorStaticTyping, IPublicAllocatorBase} from "./interfaces/IPublicAllocator.sol";

10: import {ISiloVault, MarketAllocation} from "./interfaces/ISiloVault.sol";

12: import {ErrorsLib} from "./libraries/ErrorsLib.sol";

13: import {EventsLib} from "./libraries/EventsLib.sol";

64:         for (uint256 i = 0; i < config.length; i++) {

100:         if (msg.value > 0) accruedFee[vault] += msg.value;

106:         MarketAllocation[] memory allocations = new MarketAllocation[](withdrawals.length + 1);

112:         for (uint256 i = 0; i < withdrawals.length; i++) {

128:             flowCaps[vault][market].maxIn += withdrawal.amount;

129:             flowCaps[vault][market].maxOut -= withdrawal.amount;

131:             allocations[i].assets = assets - withdrawal.amount;

133:             totalWithdrawn += withdrawal.amount;

140:         flowCaps[vault][supplyMarket].maxIn -= totalWithdrawn;

141:         flowCaps[vault][supplyMarket].maxOut += totalWithdrawn;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

4: import {SafeCast} from "openzeppelin5/utils/math/SafeCast.sol";

5: import {ERC4626, Math} from "openzeppelin5/token/ERC20/extensions/ERC4626.sol";

6: import {IERC4626, IERC20, IERC20Metadata} from "openzeppelin5/interfaces/IERC4626.sol";

7: import {Ownable2Step, Ownable} from "openzeppelin5/access/Ownable2Step.sol";

8: import {ERC20Permit} from "openzeppelin5/token/ERC20/extensions/ERC20Permit.sol";

9: import {Multicall} from "openzeppelin5/utils/Multicall.sol";

10: import {ERC20} from "openzeppelin5/token/ERC20/ERC20.sol";

11: import {SafeERC20} from "openzeppelin5/token/ERC20/utils/SafeERC20.sol";

12: import {UtilsLib} from "morpho-blue/libraries/UtilsLib.sol";

14: import {TokenHelper} from "silo-core/contracts/lib/TokenHelper.sol";

16: import {MarketConfig, PendingUint192, PendingAddress, MarketAllocation, ISiloVaultBase, ISiloVaultStaticTyping, ISiloVault} from "./interfaces/ISiloVault.sol";

18: import {INotificationReceiver} from "./interfaces/INotificationReceiver.sol";

19: import {IVaultIncentivesModule} from "./interfaces/IVaultIncentivesModule.sol";

20: import {IIncentivesClaimingLogic} from "./interfaces/IIncentivesClaimingLogic.sol";

22: import {PendingUint192, PendingAddress, PendingLib} from "./libraries/PendingLib.sol";

23: import {ConstantsLib} from "./libraries/ConstantsLib.sol";

24: import {ErrorsLib} from "./libraries/ErrorsLib.sol";

25: import {EventsLib} from "./libraries/EventsLib.sol";

26: import {SiloVaultActionsLib} from "./libraries/SiloVaultActionsLib.sol";

122:         DECIMALS_OFFSET = uint8(UtilsLib.zeroFloorSub(18 + 6, decimals));

277:         config[_market].removableAt = uint64(block.timestamp + timelock);

292:         for (uint256 i; i < length; ++i) {

314:         for (uint256 i; i < newLength; ++i) {

325:         for (uint256 i; i < currLength; ++i) {

357:         for (uint256 i; i < _allocations.length; ++i) {

399:                 totalWithdrawn += withdrawnAssets;

410:                 if (supplyAssets + suppliedAssets > supplyCap) revert ErrorsLib.SupplyCapExceeded(allocation.market);

412:                 uint256 newBalance = balanceTracker[allocation.market] + suppliedAssets;

423:                 totalSupplied += suppliedAssets;

648:         for (uint256 i; i < withdrawQueue.length; ++i) {

650:             assets += _expectedSupplyAssets(market, address(this));

668:         newTotalSupply = totalSupply() + feeShares;

671:         assets -= SiloVaultActionsLib.simulateWithdrawERC4626(assets, withdrawQueue);

676:         for (uint256 i; i < supplyQueue.length; ++i) {

696:                 internalSuppliable = supplyCap - internalBalance;

699:             totalSuppliable += Math.min(suppliable, internalSuppliable);

711:         return _convertToSharesWithTotals(_assets, totalSupply() + feeShares, newTotalAssets, _rounding);

722:         return _convertToAssetsWithTotals(_shares, totalSupply() + feeShares, newTotalAssets, _rounding);

733:         return _assets.mulDiv(_newTotalSupply + 10 ** _decimalsOffset(), _newTotalAssets + 1, _rounding);

757:         return _shares.mulDiv(_newTotalAssets + 1, _newTotalSupply + 10 ** _decimalsOffset(), _rounding);

783:         _updateLastTotalAssets(lastTotalAssets + _assets);

861:             _updateLastTotalAssets(lastTotalAssets + _expectedSupplyAssets(_market, address(this)));

869:         for (uint256 i; i < supplyQueue.length; ++i) {

882:                 uint256 newBalance = balanceTracker[market] + toSupply;

888:                         _assets -= toSupply;

902:         for (uint256 i; i < withdrawQueue.length; ++i) {

915:                     _assets -= toWithdraw;

965:                 newTotalAssets - feeAssets,

1001:         for (uint256 i; i < receivers.length; i++) {

1017:         for (uint256 i; i < logics.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/SiloVaultsFactory.sol

4: import {Clones} from "openzeppelin5/proxy/Clones.sol";

6: import {ISiloVault} from "./interfaces/ISiloVault.sol";

7: import {ISiloVaultsFactory} from "./interfaces/ISiloVaultsFactory.sol";

9: import {EventsLib} from "./libraries/EventsLib.sol";

11: import {SiloVault} from "./SiloVault.sol";

12: import {VaultIncentivesModule} from "./incentives/VaultIncentivesModule.sol";

45:             abi.encodePacked(counter[msg.sender]++, msg.sender, initialOwner, initialTimelock, asset, name, symbol)

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

4: import {Ownable2StepUpgradeable, OwnableUpgradeable} from "openzeppelin5-upgradeable/access/Ownable2StepUpgradeable.sol";

5: import {EnumerableSet} from "openzeppelin5/utils/structs/EnumerableSet.sol";

6: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

8: import {IVaultIncentivesModule} from "../interfaces/IVaultIncentivesModule.sol";

9: import {IIncentivesClaimingLogic} from "../interfaces/IIncentivesClaimingLogic.sol";

10: import {INotificationReceiver} from "../interfaces/INotificationReceiver.sol";

11: import {ErrorsLib} from "../libraries/ErrorsLib.sol";

12: import {ISiloVault} from "silo-vaults/contracts/interfaces/ISiloVault.sol";

60:             pendingClaimingLogics[_market][_logic] = block.timestamp + timelock;

168:         for (uint256 i = 0; i < _marketsInput.length; i++) {

171:                 totalLogics += _claimingLogics[IERC4626(_marketsInput[i])].length();

178:         for (uint256 i = 0; i < _marketsInput.length; i++) {

181:             for (uint256 j = 0; j < marketLogics.length; j++) {

184:                     logics[index++] = marketLogics[j];

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

4: import {ISiloIncentivesController, IDistributionManager} from "silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol";

6: import {IIncentivesClaimingLogic} from "../../interfaces/IIncentivesClaimingLogic.sol";

28:         for (uint256 i = 0; i < accruedRewards.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol

4: import {ISiloIncentivesControllerCLFactory} from "../../interfaces/ISiloIncentivesControllerCLFactory.sol";

5: import {SiloIncentivesControllerCL} from "./SiloIncentivesControllerCL.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

4: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

6: import {ISiloVault} from "./ISiloVault.sol";

10: uint128 constant MAX_SETTABLE_FLOW_CAP = type(uint128).max / 2;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloIncentivesControllerCLFactory.sol

4: import {SiloIncentivesControllerCL} from "../incentives/claiming-logics/SiloIncentivesControllerCL.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloIncentivesControllerCLFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

4: import {IERC20Permit} from "openzeppelin5/token/ERC20/extensions/ERC20Permit.sol";

5: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

7: import {MarketConfig, PendingUint192, PendingAddress} from "../libraries/PendingLib.sol";

8: import {IVaultIncentivesModule} from "./IVaultIncentivesModule.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol

4: import {ISiloVault} from "./ISiloVault.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol

4: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

6: import {IIncentivesClaimingLogic} from "./IIncentivesClaimingLogic.sol";

7: import {INotificationReceiver} from "./INotificationReceiver.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/libraries/ErrorsLib.sol

4: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/ErrorsLib.sol)

```solidity
File: ./silo-vaults/contracts/libraries/EventsLib.sol

4: import {IERC4626} from "openzeppelin5/interfaces/IERC4626.sol";

6: import {PendingAddress} from "./PendingLib.sol";

7: import {ISiloVault} from "../interfaces/ISiloVault.sol";

8: import {FlowCapsConfig} from "../interfaces/IPublicAllocator.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/EventsLib.sol)

```solidity
File: ./silo-vaults/contracts/libraries/PendingLib.sol

38:         _pending.validAt = uint64(block.timestamp + _timelock);

46:         _pending.validAt = uint64(block.timestamp + _timelock);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/PendingLib.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

4: import {IERC4626, IERC20} from "openzeppelin5/interfaces/IERC4626.sol";

5: import {UtilsLib} from "morpho-blue/libraries/UtilsLib.sol";

6: import {SafeERC20} from "openzeppelin5/token/ERC20/utils/SafeERC20.sol";

8: import {ErrorsLib} from "./ErrorsLib.sol";

9: import {EventsLib} from "./EventsLib.sol";

10: import {PendingUint192, MarketConfig} from "./PendingLib.sol";

11: import {ConstantsLib} from "./ConstantsLib.sol";

73:         for (uint256 i; i < _withdrawQueue.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="GAS-6"></a>[GAS-6] Avoid contract existence checks by using low level calls
Prior to 0.8.10 the compiler inserted extra code, including `EXTCODESIZE` (**100 gas**), to check for contract existence for external function calls. In more recent solidity versions, the compiler will not insert these checks if the external call has a return value. Similar behavior can be achieved in earlier versions by using low-level calls, since low level calls never check for contract existence

*Instances (5)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

124:         IERC20(_rewardToken).safeTransfer(msg.sender, IERC20(_rewardToken).balanceOf(address(this)));

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

325:         userBalance = _shareToken().balanceOf(_user);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

152:         assets = _market.convertToAssets(_market.balanceOf(_user));

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

1018:             (bool success, ) = logics[i].delegatecall(data);

1034:         balance = IERC20(_token).balanceOf(_account);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

### <a name="GAS-7"></a>[GAS-7] Functions guaranteed to revert when called by normal users can be marked `payable`
If a function modifier such as `onlyOwner` is used, the function will revert if a normal user tries to pay the function. Marking the function as `payable` will lower the gas cost for legitimate callers because the compiler will not include checks for whether a payment was provided.

*Instances (23)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

93:     function immediateDistribution(address _tokenToDistribute, uint104 _amount) external virtual onlyNotifier {

123:     function rescueRewards(address _rewardToken) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol

53:     function killGauge() external virtual onlyOwner {

59:     function unkillGauge() external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

170:     function setClaimer(address _user, address _caller) external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

46:     function setAdmin(ISiloVault vault, address newAdmin) external virtual onlyAdminOrVaultOwner(vault) {

53:     function setFee(ISiloVault vault, uint256 newFee) external virtual onlyAdminOrVaultOwner(vault) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

179:     function setCurator(address _newCurator) external virtual onlyOwner {

188:     function setIsAllocator(address _newAllocator, bool _newIsAllocator) external virtual onlyOwner {

193:     function submitTimelock(uint256 _newTimelock) external virtual onlyOwner {

209:     function setFee(uint256 _newFee) external virtual onlyOwner {

224:     function setFeeRecipient(address _newFeeRecipient) external virtual onlyOwner {

237:     function submitGuardian(address _newGuardian) external virtual onlyOwner {

253:     function submitCap(IERC4626 _market, uint256 _newSupplyCap) external virtual onlyCuratorRole {

270:     function submitMarketRemoval(IERC4626 _market) external virtual onlyCuratorRole {

285:     function setSupplyQueue(IERC4626[] calldata _newSupplyQueue) external virtual onlyAllocatorRole {

305:     function updateWithdrawQueue(uint256[] calldata _indexes) external virtual onlyAllocatorRole {

352:     function reallocate(MarketAllocation[] calldata _allocations) external virtual onlyAllocatorRole {

435:     function revokePendingTimelock() external virtual onlyGuardianRole {

442:     function revokePendingGuardian() external virtual onlyGuardianRole {

449:     function revokePendingCap(IERC4626 _market) external virtual onlyCuratorOrGuardianRole {

456:     function revokePendingMarketRemoval(IERC4626 _market) external virtual onlyCuratorOrGuardianRole {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

109:     function addNotificationReceiver(INotificationReceiver _notificationReceiver) external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="GAS-8"></a>[GAS-8] `++i` costs less gas compared to `i++` or `i += 1` (same for `--i` vs `i--` or `i -= 1`)
Pre-increments and pre-decrements are cheaper.

For a `uint256 i` variable, the following is true with the Optimizer enabled at 10k:

**Increment:**

- `i += 1` is the most expensive form
- `i++` costs 6 gas less than `i += 1`
- `++i` costs 5 gas less than `i++` (11 gas less than `i += 1`)

**Decrement:**

- `i -= 1` is the most expensive form
- `i--` costs 11 gas less than `i -= 1`
- `--i` costs 5 gas less than `i--` (16 gas less than `i -= 1`)

Note that post-increments (or post-decrements) return the old value before incrementing or decrementing, hence the name *post-increment*:

```solidity
uint i = 1;  
uint j = 2;
require(j == i++, "This will be false as i is incremented after the comparison");
```
  
However, pre-increments (or pre-decrements) return the new value:
  
```solidity
uint i = 1;  
uint j = 2;
require(j == ++i, "This will be true as i is incremented before the comparison");
```

In the pre-increment case, the compiler has to create a temporary variable (when used) for returning `1` instead of `2`.

Consider using pre-increments and pre-decrements where they are relevant (meaning: not where post-increments/decrements logic are relevant).

*Saves 5 gas per instance*

*Instances (15)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

79:         for (uint256 i = 0; i < numberOfPrograms; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

100:         for (uint256 i = 0; i < _programNames.length; i++) {

232:         for (uint256 i = 0; i < accruedRewards.length; i++) {

292:         for (uint256 i = 0; i < _programIds.length; i++) {

307:         for (uint256 i = 0; i < _programNames.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

107:         for (uint256 i = 0; i < length; i++) {

223:         for (uint256 i = 0; i < length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

64:         for (uint256 i = 0; i < config.length; i++) {

112:         for (uint256 i = 0; i < withdrawals.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

1001:         for (uint256 i; i < receivers.length; i++) {

1017:         for (uint256 i; i < logics.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

168:         for (uint256 i = 0; i < _marketsInput.length; i++) {

178:         for (uint256 i = 0; i < _marketsInput.length; i++) {

181:             for (uint256 j = 0; j < marketLogics.length; j++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

28:         for (uint256 i = 0; i < accruedRewards.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)

### <a name="GAS-9"></a>[GAS-9] Using `private` rather than `public` for constants, saves gas
If needed, the values can be read from the verified contract source code, or if there are multiple values there can be a single getter function that [returns a tuple](https://github.com/code-423n4/2022-08-frax/blob/90f55a9ce4e25bceed3a74290b854341d8de6afa/src/contracts/FraxlendPair.sol#L156-L178) of the values of all currently-public constants. Saves **3406-3606 gas** in deployment gas due to the compiler not having to create non-payable getter functions for deployment calldata, not having to store the bytes of the value outside of where it's used, and not adding another entry to the method ID table

*Instances (3)*:
```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

21:     uint256 public constant MAX_EMISSION_PER_SECOND = 1e30;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

31:     uint8 public constant PRECISION = 36;

32:     uint256 public constant TEN_POW_PRECISION = 10 ** PRECISION;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

### <a name="GAS-10"></a>[GAS-10] Use shift right/left instead of division/multiplication if possible
While the `DIV` / `MUL` opcode uses 5 gas, the `SHR` / `SHL` opcode only uses 3 gas. Furthermore, beware that Solidity's division operation also includes a division-by-0 prevention which is bypassed using shifting. Eventually, overflow checks are never performed for shift operations as they are done for arithmetic operations. Instead, the result is always truncated, so the calculation can be unchecked in Solidity version `0.8+`
- Use `>> 1` instead of `/ 2`
- Use `>> 2` instead of `/ 4`
- Use `<< 3` instead of `* 8`
- ...
- Use `>> 5` instead of `/ 2^5 == / 32`
- Use `<< 6` instead of `* 2^6 == * 64`

TL;DR:
- Shifting left by N is like multiplying by 2^N (Each bits to the left is an increased power of 2)
- Shifting right by N is like dividing by 2^N (Each bits to the right is a decreased power of 2)

*Saves around 2 gas + 20 for unchecked per instance*

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

10: uint128 constant MAX_SETTABLE_FLOW_CAP = type(uint128).max / 2;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

### <a name="GAS-11"></a>[GAS-11] Splitting require() statements that use && saves gas

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

69:         require(validAt != 0 && validAt < block.timestamp, CantAcceptLogic());

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="GAS-12"></a>[GAS-12] Increments/decrements can be unchecked in for-loops
In Solidity 0.8+, there's a default overflow check on unsigned integers. It's possible to uncheck this in for-loops and save some gas at each iteration, but at the cost of some code readability, as this uncheck cannot be made inline.

[ethereum/solidity#10695](https://github.com/ethereum/solidity/issues/10695)

The change would be:

```diff
- for (uint256 i; i < numIterations; i++) {
+ for (uint256 i; i < numIterations;) {
 // ...  
+   unchecked { ++i; }
}  
```

These save around **25 gas saved** per instance.

The same can be applied with decrements (which should use `break` when `i == 0`).

The risk of overflow is non-existent for `uint256`.

*Instances (24)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

79:         for (uint256 i = 0; i < numberOfPrograms; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

100:         for (uint256 i = 0; i < _programNames.length; i++) {

232:         for (uint256 i = 0; i < accruedRewards.length; i++) {

292:         for (uint256 i = 0; i < _programIds.length; i++) {

307:         for (uint256 i = 0; i < _programNames.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

107:         for (uint256 i = 0; i < length; i++) {

223:         for (uint256 i = 0; i < length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

64:         for (uint256 i = 0; i < config.length; i++) {

112:         for (uint256 i = 0; i < withdrawals.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

292:         for (uint256 i; i < length; ++i) {

314:         for (uint256 i; i < newLength; ++i) {

325:         for (uint256 i; i < currLength; ++i) {

357:         for (uint256 i; i < _allocations.length; ++i) {

648:         for (uint256 i; i < withdrawQueue.length; ++i) {

676:         for (uint256 i; i < supplyQueue.length; ++i) {

869:         for (uint256 i; i < supplyQueue.length; ++i) {

902:         for (uint256 i; i < withdrawQueue.length; ++i) {

1001:         for (uint256 i; i < receivers.length; i++) {

1017:         for (uint256 i; i < logics.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

168:         for (uint256 i = 0; i < _marketsInput.length; i++) {

178:         for (uint256 i = 0; i < _marketsInput.length; i++) {

181:             for (uint256 j = 0; j < marketLogics.length; j++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

28:         for (uint256 i = 0; i < accruedRewards.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

73:         for (uint256 i; i < _withdrawQueue.length; ++i) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="GAS-13"></a>[GAS-13] Use != 0 instead of > 0 for unsigned integer comparison

*Instances (11)*:
```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

68:             if (!vault.config(market).enabled && (cfg.caps.maxIn > 0 || cfg.caps.maxOut > 0)) {

100:         if (msg.value > 0) accruedFee[vault] += msg.value;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

367:             if (withdrawn > 0) {

912:             if (toWithdraw > 0) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IIncentivesClaimingLogic.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IIncentivesClaimingLogic.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/INotificationReceiver.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/INotificationReceiver.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

40:         if (_supplyCap > 0) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)


## Non Critical Issues


| |Issue|Instances|
|-|:-|:-:|
| [NC-1](#NC-1) | Replace `abi.encodeWithSignature` and `abi.encodeWithSelector` with `abi.encodeCall` which keeps the code typo/type safe | 1 |
| [NC-2](#NC-2) | Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked` | 3 |
| [NC-3](#NC-3) | `constant`s should be defined rather than using magic numbers | 7 |
| [NC-4](#NC-4) | Control structures do not follow the Solidity Style Guide | 114 |
| [NC-5](#NC-5) | Critical Changes Should Use Two-step Procedure | 2 |
| [NC-6](#NC-6) | Default Visibility for constants | 2 |
| [NC-7](#NC-7) | Consider disabling `renounceOwnership()` | 4 |
| [NC-8](#NC-8) | Functions should not be longer than 50 lines | 160 |
| [NC-9](#NC-9) | Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor | 3 |
| [NC-10](#NC-10) | Consider using named mappings | 17 |
| [NC-11](#NC-11) | Take advantage of Custom Error's return value property | 51 |
| [NC-12](#NC-12) | Constants should be defined rather than using magic numbers | 1 |
| [NC-13](#NC-13) | Variables need not be initialized to zero | 14 |
### <a name="NC-1"></a>[NC-1] Replace `abi.encodeWithSignature` and `abi.encodeWithSelector` with `abi.encodeCall` which keeps the code typo/type safe
When using `abi.encodeWithSignature`, it is possible to include a typo for the correct function signature.
When using `abi.encodeWithSignature` or `abi.encodeWithSelector`, it is also possible to provide parameters that are not of the correct type for the function.

To avoid these pitfalls, it would be best to use [`abi.encodeCall`](https://solidity-by-example.org/abi-encode/) instead.

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/SiloVault.sol

1015:         bytes memory data = abi.encodeWithSelector(IIncentivesClaimingLogic.claimRewardsAndDistribute.selector);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

### <a name="NC-2"></a>[NC-2] Use `string.concat()` or `bytes.concat()` instead of `abi.encodePacked`
Solidity version 0.8.4 introduces `bytes.concat()` (vs `abi.encodePacked(<bytes>,<bytes>)`)

Solidity version 0.8.12 introduces `string.concat()` (vs `abi.encodePacked(<str>,<str>), which catches concatenation errors (in the event of a `bytes` data mixed in the concatenation)`)

*Instances (3)*:
```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

116:         return bytes32(abi.encodePacked(_programName));

125:         return string(TokenHelper.removeZeros(abi.encodePacked(_programId)));

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/SiloVaultsFactory.sol

45:             abi.encodePacked(counter[msg.sender]++, msg.sender, initialOwner, initialTimelock, asset, name, symbol)

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVaultsFactory.sol)

### <a name="NC-3"></a>[NC-3] `constant`s should be defined rather than using magic numbers
Even [assembly](https://github.com/code-423n4/2022-05-opensea-seaport/blob/9d7ce4d08bf3c3010304a0476a785c70c0e90ae7/contracts/lib/TokenTransferrer.sol#L35-L39) can benefit from using readable constants instead of hex/numeric literals

*Instances (7)*:
```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

49:         require(bytes(_incentivesProgramInput.name).length <= 32, TooLongProgramName());

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-vaults/contracts/IdleVault.sol

56:         return 18;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVault.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

121:         require(decimals <= 18, ErrorsLib.NotSupportedDecimals());

122:         DECIMALS_OFFSET = uint8(UtilsLib.zeroFloorSub(18 + 6, decimals));

513:         return 18;

733:         return _assets.mulDiv(_newTotalSupply + 10 ** _decimalsOffset(), _newTotalAssets + 1, _rounding);

757:         return _shares.mulDiv(_newTotalAssets + 1, _newTotalSupply + 10 ** _decimalsOffset(), _rounding);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

### <a name="NC-4"></a>[NC-4] Control structures do not follow the Solidity Style Guide
See the [control structures](https://docs.soliditylang.org/en/latest/style-guide.html#control-structures) section of the Solidity Style Guide

*Instances (114)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

94:         if (_amount == 0) return;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol

14:         controller = address(new SiloIncentivesController(_owner, _notifier));

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol

25:         address _notifier,

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol

14:         address _notifier,

17:         gaugeLike = address(new SiloIncentivesControllerGaugeLike(_owner, _notifier, _shareToken));

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

31:         if (_authorizedClaimers[user] != claimer) revert ClaimerUnauthorized();

37:         if (_user == address(0)) revert InvalidUserAddress();

38:         if (_to == address(0)) revert InvalidToAddress();

108:                 revert DifferentRewardsTokens();

128:         if (_to == address(0)) revert InvalidToAddress();

139:         if (_to == address(0)) revert InvalidToAddress();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

29:     address public immutable NOTIFIER; // solhint-disable-line var-name-mixedcase

35:         if (msg.sender != NOTIFIER) revert OnlyNotifier();

40:         if (msg.sender != NOTIFIER && msg.sender != owner()) revert OnlyNotifierOrOwner();

47:         require(_notifier != address(0), ZeroAddress());

49:         NOTIFIER = _notifier;

302:         if (

319:         shareToken = IERC20(NOTIFIER);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/IDistributionManager.sol

36:     error OnlyNotifier();

39:     error OnlyNotifierOrOwner();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/IDistributionManager.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol

32:     error DifferentRewardsTokens();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerFactory.sol

11:     function create(address _owner, address _notifier) external returns (address);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerGaugeLikeFactory.sol

12:     function createGaugeLike(address _owner, address _notifier, address _shareToken) external returns (address);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerGaugeLikeFactory.sol)

```solidity
File: ./silo-vaults/contracts/IdleVault.sol

24:         if (onlyDepositor == address(0)) revert ErrorsLib.ZeroAddress();

41:         if (_receiver != ONLY_DEPOSITOR) revert();

48:         if (_receiver != ONLY_DEPOSITOR) revert();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVault.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

47:         if (admin[vault] == newAdmin) revert ErrorsLib.AlreadySet();

54:         if (fee[vault] == newFee) revert ErrorsLib.AlreadySet();

86:         if (!success) RevertLib.revertBytes(data, "fee transfer failed");

99:         if (msg.value != fee[vault]) revert ErrorsLib.IncorrectFee();

100:         if (msg.value > 0) accruedFee[vault] += msg.value;

102:         if (withdrawals.length == 0) revert ErrorsLib.EmptyWithdrawals();

104:         if (!vault.config(supplyMarket).enabled) revert ErrorsLib.MarketNotEnabled(supplyMarket);

117:             if (!vault.config(market).enabled) revert ErrorsLib.MarketNotEnabled(market);

118:             if (withdrawal.amount == 0) revert ErrorsLib.WithdrawZero(market);

120:             if (address(market) <= address(prevMarket)) revert ErrorsLib.InconsistentWithdrawals();

121:             if (address(market) == address(supplyMarket)) revert ErrorsLib.DepositMarketInWithdrawals();

125:             if (flowCaps[vault][market].maxOut < withdrawal.amount) revert ErrorsLib.MaxOutflowExceeded(market);

126:             if (assets < withdrawal.amount) revert ErrorsLib.NotEnoughSupply(market);

138:         if (flowCaps[vault][supplyMarket].maxIn < totalWithdrawn) revert ErrorsLib.MaxInflowExceeded(supplyMarket);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

18: import {INotificationReceiver} from "./interfaces/INotificationReceiver.sol";

134:         if (sender != curator && sender != owner()) revert ErrorsLib.NotCuratorRole();

151:         if (_msgSender() != owner() && _msgSender() != guardian) revert ErrorsLib.NotGuardianRole();

170:         if (_validAt == 0) revert ErrorsLib.NoPendingValue();

171:         if (block.timestamp < _validAt) revert ErrorsLib.TimelockNotElapsed();

180:         if (_newCurator == curator) revert ErrorsLib.AlreadySet();

194:         if (_newTimelock == timelock) revert ErrorsLib.AlreadySet();

195:         if (pendingTimelock.validAt != 0) revert ErrorsLib.AlreadyPending();

210:         if (_newFee == fee) revert ErrorsLib.AlreadySet();

211:         if (_newFee > ConstantsLib.MAX_FEE) revert ErrorsLib.MaxFeeExceeded();

212:         if (_newFee != 0 && feeRecipient == address(0)) revert ErrorsLib.ZeroFeeRecipient();

225:         if (_newFeeRecipient == feeRecipient) revert ErrorsLib.AlreadySet();

226:         if (_newFeeRecipient == address(0) && fee != 0) revert ErrorsLib.ZeroFeeRecipient();

238:         if (_newGuardian == guardian) revert ErrorsLib.AlreadySet();

239:         if (pendingGuardian.validAt != 0) revert ErrorsLib.AlreadyPending();

254:         if (_market.asset() != asset()) revert ErrorsLib.InconsistentAsset(_market);

255:         if (pendingCap[_market].validAt != 0) revert ErrorsLib.AlreadyPending();

256:         if (config[_market].removableAt != 0) revert ErrorsLib.PendingRemoval();

258:         if (_newSupplyCap == supplyCap) revert ErrorsLib.AlreadySet();

271:         if (config[_market].removableAt != 0) revert ErrorsLib.AlreadyPending();

272:         if (config[_market].cap != 0) revert ErrorsLib.NonZeroCap();

273:         if (!config[_market].enabled) revert ErrorsLib.MarketNotEnabled(_market);

274:         if (pendingCap[_market].validAt != 0) revert ErrorsLib.PendingCap(_market);

290:         if (length > ConstantsLib.MAX_QUEUE_LENGTH) revert ErrorsLib.MaxQueueLengthExceeded();

294:             if (config[market].cap == 0) revert ErrorsLib.UnauthorizedMarket(market);

319:             if (seen[prevIndex]) revert ErrorsLib.DuplicateMarket(market);

329:                 if (config[market].cap != 0) revert ErrorsLib.InvalidMarketRemovalNonZeroCap(market);

330:                 if (pendingCap[market].validAt != 0) revert ErrorsLib.PendingCap(market);

333:                     if (config[market].removableAt == 0) revert ErrorsLib.InvalidMarketRemovalNonZeroSupply(market);

368:                 if (!config[allocation.market].enabled) revert ErrorsLib.MarketNotEnabled(allocation.market);

405:                 if (suppliedAssets == 0) continue;

408:                 if (supplyCap == 0) revert ErrorsLib.UnauthorizedMarket(allocation.market);

410:                 if (supplyAssets + suppliedAssets > supplyCap) revert ErrorsLib.SupplyCapExceeded(allocation.market);

414:                 if (newBalance > supplyCap) revert ErrorsLib.InternalSupplyCapExceeded(allocation.market);

427:         if (totalWithdrawn != totalSupplied) revert ErrorsLib.InconsistentReallocation();

680:             if (supplyCap == 0) continue;

686:             if (suppliable == 0) continue;

691:             if (internalBalance >= supplyCap) continue;

776:         if (_shares == 0) revert ErrorsLib.InputZeroShares();

827:         if (_newTimelock > ConstantsLib.MAX_TIMELOCK) revert ErrorsLib.AboveMaxTimelock();

828:         if (_newTimelock < ConstantsLib.MIN_TIMELOCK) revert ErrorsLib.BelowMinTimelock();

873:             if (supplyCap == 0) continue;

894:             if (_assets == 0) return;

897:         if (_assets != 0) revert ErrorsLib.AllCapsReached();

925:             if (_assets == 0) return;

928:         if (_assets != 0) revert ErrorsLib.NotEnoughLiquidity();

946:         if (feeShares != 0) _mint(feeRecipient, feeShares);

989:         if (_value == 0) return;

995:         address[] memory receivers = INCENTIVES_MODULE.getNotificationReceivers();

1019:             if (!success) revert ErrorsLib.ClaimRewardsFailed();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

10: import {INotificationReceiver} from "../interfaces/INotificationReceiver.sol";

21:     EnumerableSet.AddressSet internal _notificationReceivers;

35:         if (_msgSender() != owner() && _msgSender() != guardian) revert ErrorsLib.NotGuardianRole();

110:         require(address(_notificationReceiver) != address(0), AddressZero());

111:         require(_notificationReceivers.add(address(_notificationReceiver)), NotificationReceiverAlreadyAdded());

113:         emit NotificationReceiverAdded(address(_notificationReceiver));

117:     function removeNotificationReceiver(

118:         INotificationReceiver _notificationReceiver,

124:         require(_notificationReceivers.remove(address(_notificationReceiver)), NotificationReceiverNotFound());

126:         emit NotificationReceiverRemoved(address(_notificationReceiver));

145:         receivers = _notificationReceivers.values();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

29:             if (accruedRewards[i].amount == 0) continue;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol

7: import {INotificationReceiver} from "./INotificationReceiver.sol";

15:     event NotificationReceiverAdded(address notificationReceiver);

16:     event NotificationReceiverRemoved(address notificationReceiver);

24:     error NotificationReceiverAlreadyAdded();

25:     error NotificationReceiverNotFound();

53:     function addNotificationReceiver(INotificationReceiver _notificationReceiver) external;

60:     function removeNotificationReceiver(INotificationReceiver _notificationReceiver, bool _allProgramsStopped) external;

75:     function getNotificationReceivers() external view returns (address[] memory _notificationReceivers);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/libraries/ErrorsLib.sol

22:     error NotificationDispatchError();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/ErrorsLib.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

21:         if (_isAllocator[_newAllocator] == _newIsAllocator) revert ErrorsLib.AlreadySet();

44:                 if (_withdrawQueue.length > ConstantsLib.MAX_QUEUE_LENGTH) revert ErrorsLib.MaxQueueLengthExceeded();

78:             if (_assets == 0) break;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="NC-5"></a>[NC-5] Critical Changes Should Use Two-step Procedure
The critical procedures should be two step process.

See similar findings in previous Code4rena contests for reference: <https://code4rena.com/reports/2022-06-illuminate/#2-critical-changes-should-use-two-step-procedure>

**Recommended Mitigation Steps**

Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (2)*:
```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

46:     function setAdmin(ISiloVault vault, address newAdmin) external virtual onlyAdminOrVaultOwner(vault) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

72:     function setAdmin(ISiloVault _vault, address _newAdmin) external;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

### <a name="NC-6"></a>[NC-6] Default Visibility for constants
Some constants are using the default visibility. For readability, consider explicitly declaring them as `internal`.

*Instances (2)*:
```solidity
File: ./silo-vaults/contracts/SiloVault.sol

34:     uint256 constant WAD = 1e18;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

10: uint128 constant MAX_SETTABLE_FLOW_CAP = type(uint128).max / 2;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

### <a name="NC-7"></a>[NC-7] Consider disabling `renounceOwnership()`
If the plan for your project does not include eventually giving up all ownership control, consider overwriting OpenZeppelin's `Ownable`'s `renounceOwnership()` function in order to disable it.

*Instances (4)*:
```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

20: contract DistributionManager is IDistributionManager, Ownable2Step {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

33: contract SiloVault is ERC4626, ERC20Permit, Ownable2Step, Multicall, ISiloVaultStaticTyping {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

15: contract VaultIncentivesModule is IVaultIncentivesModule, Ownable2StepUpgradeable {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

198: interface ISiloVault is ISiloVaultBase, IERC4626, IERC20Permit, IOwnable, IMulticall {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

### <a name="NC-8"></a>[NC-8] Functions should not be longer than 50 lines
Overly complex code can make understanding functionality more difficult, try to further modularize your code to ensure readability 

*Instances (160)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

93:     function immediateDistribution(address _tokenToDistribute, uint104 _amount) external virtual onlyNotifier {

123:     function rescueRewards(address _rewardToken) external onlyOwner {

130:     function _getOrCreateImmediateDistributionProgram(

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol

13:     function create(address _owner, address _notifier) external returns (address controller) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol

59:     function unkillGauge() external virtual onlyOwner {

66:     function share_token() external view returns (address) {

72:     function is_killed() external view returns (bool) {

76:     function _shareToken() internal view override returns (IERC20 shareToken) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

127:     function claimRewards(address _to) external virtual returns (AccruedRewards[] memory accruedRewards) {

170:     function setClaimer(address _user, address _caller) external virtual onlyOwner {

179:     function getClaimer(address _user) external view virtual returns (address) {

291:     function _requireExistingPrograms(bytes32[] memory _programIds) internal view virtual {

318:     function _transferRewards(address rewardToken, address to, uint256 amount) internal virtual {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

73:     function getDistributionEnd(string calldata _incentivesProgram) external view virtual override returns (uint256) {

103:     function getAllProgramsNames() external view virtual returns (string[] memory programsNames) {

113:     function getProgramId(string memory _programName) public pure virtual returns (bytes32) {

124:     function getProgramName(bytes32 _programId) public pure virtual returns (string memory) {

204:     function _accrueRewards(address _user) internal virtual returns (AccruedRewards[] memory accruedRewards) {

318:     function _shareToken() internal view virtual returns (IERC20 shareToken) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/IDistributionManager.sol

47:     function setDistributionEnd(string calldata _incentivesProgram, uint40 _distributionEnd) external;

54:     function getDistributionEnd(string calldata _incentivesProgram) external view returns (uint256);

62:     function getUserData(address _user, string calldata _incentivesProgram) external view returns (uint256);

81:     function getProgramId(string calldata _programName) external pure returns (bytes32 programId);

87:     function getAllProgramsNames() external view returns (string[] memory programsNames);

94:     function getProgramName(bytes32 _programName) external pure returns (string memory programName);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/IDistributionManager.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol

59:     function immediateDistribution(address _tokenToDistribute, uint104 _amount) external;

63:     function rescueRewards(address _rewardToken) external;

70:     function setClaimer(address _user, address _claimer) external;

98:     function claimRewards(address _to) external returns (AccruedRewards[] memory accruedRewards);

131:     function getClaimer(address _user) external view returns (address);

161:     function getUserUnclaimedRewards(address _user, string calldata _programName) external view returns (uint256);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerFactory.sol

11:     function create(address _owner, address _notifier) external returns (address);

16:     function isSiloIncentivesController(address _controller) external view returns (bool);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerGaugeLikeFactory.sol

12:     function createGaugeLike(address _owner, address _notifier, address _shareToken) external returns (address);

15:     function createdInFactory(address _gaugeLike) external view returns (bool);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerGaugeLikeFactory.sol)

```solidity
File: ./silo-vaults/contracts/IdleVault.sol

30:     function maxDeposit(address _depositor) public view virtual override returns (uint256) {

35:     function maxMint(address _depositor) public view virtual override returns (uint256) {

40:     function deposit(uint256 _assets, address _receiver) public virtual override returns (uint256 shares) {

47:     function mint(uint256 _shares, address _receiver) public virtual override returns (uint256 assets) {

55:     function _decimalsOffset() internal view virtual override returns (uint8) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVault.sol)

```solidity
File: ./silo-vaults/contracts/IdleVaultsFactory.sol

19:     function createIdleVault(IERC4626 _vault) external virtual returns (IdleVault idleVault) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

46:     function setAdmin(ISiloVault vault, address newAdmin) external virtual onlyAdminOrVaultOwner(vault) {

53:     function setFee(ISiloVault vault, uint256 newFee) external virtual onlyAdminOrVaultOwner(vault) {

82:     function transferFee(ISiloVault vault, address payable feeRecipient) external virtual onlyAdminOrVaultOwner(vault) {

151:     function _expectedSupplyAssets(IERC4626 _market, address _user) internal view virtual returns (uint256 assets) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

179:     function setCurator(address _newCurator) external virtual onlyOwner {

188:     function setIsAllocator(address _newAllocator, bool _newIsAllocator) external virtual onlyOwner {

193:     function submitTimelock(uint256 _newTimelock) external virtual onlyOwner {

209:     function setFee(uint256 _newFee) external virtual onlyOwner {

224:     function setFeeRecipient(address _newFeeRecipient) external virtual onlyOwner {

237:     function submitGuardian(address _newGuardian) external virtual onlyOwner {

253:     function submitCap(IERC4626 _market, uint256 _newSupplyCap) external virtual onlyCuratorRole {

270:     function submitMarketRemoval(IERC4626 _market) external virtual onlyCuratorRole {

285:     function setSupplyQueue(IERC4626[] calldata _newSupplyQueue) external virtual onlyAllocatorRole {

305:     function updateWithdrawQueue(uint256[] calldata _indexes) external virtual onlyAllocatorRole {

352:     function reallocate(MarketAllocation[] calldata _allocations) external virtual onlyAllocatorRole {

435:     function revokePendingTimelock() external virtual onlyGuardianRole {

442:     function revokePendingGuardian() external virtual onlyGuardianRole {

449:     function revokePendingCap(IERC4626 _market) external virtual onlyCuratorOrGuardianRole {

456:     function revokePendingMarketRemoval(IERC4626 _market) external virtual onlyCuratorOrGuardianRole {

465:     function supplyQueueLength() external view virtual returns (uint256) {

470:     function withdrawQueueLength() external view virtual returns (uint256) {

475:     function acceptTimelock() external virtual afterTimelock(pendingTimelock.validAt) {

480:     function acceptGuardian() external virtual afterTimelock(pendingGuardian.validAt) {

485:     function acceptCap(IERC4626 _market) external virtual afterTimelock(pendingCap[_market].validAt) {

505:     function reentrancyGuardEntered() external view virtual returns (bool entered) {

512:     function decimals() public view virtual override(ERC20, ERC4626) returns (uint8) {

518:     function maxDeposit(address) public view virtual override returns (uint256) {

524:     function maxMint(address) public view virtual override returns (uint256) {

533:     function maxWithdraw(address _owner) public view virtual override returns (uint256 assets) {

540:     function maxRedeem(address _owner) public view virtual override returns (uint256) {

547:     function transfer(address _to, uint256 _value) public virtual override(ERC20, IERC20) returns (bool success) {

569:     function deposit(uint256 _assets, address _receiver) public virtual override returns (uint256 shares) {

586:     function mint(uint256 _shares, address _receiver) public virtual override returns (uint256 assets) {

647:     function totalAssets() public view virtual override returns (uint256 assets) {

657:     function _decimalsOffset() internal view virtual override returns (uint8) {

675:     function _maxDeposit() internal view virtual returns (uint256 totalSuppliable) {

775:     function _deposit(address _caller, address _receiver, uint256 _assets, uint256 _shares) internal virtual override {

807:     function _updateInternalBalanceForMarket(IERC4626 _market) internal virtual returns (uint256 marketBalance) {

819:     function _supplyBalance(IERC4626 _market) internal view virtual returns (uint256 assets, uint256 shares) {

826:     function _checkTimelockBounds(uint256 _newTimelock) internal pure virtual {

832:     function _setTimelock(uint256 _newTimelock) internal virtual {

841:     function _setGuardian(address _newGuardian) internal virtual {

850:     function _setCap(IERC4626 _market, uint184 _supplyCap) internal virtual {

868:     function _supplyERC4626(uint256 _assets) internal virtual {

901:     function _withdrawERC4626(uint256 _assets) internal virtual {

934:     function _updateLastTotalAssets(uint256 _updatedTotalAssets) internal virtual {

942:     function _accrueFee() internal virtual returns (uint256 newTotalAssets) {

953:     function _accruedFeeShares() internal view virtual returns (uint256 feeShares, uint256 newTotalAssets) {

972:     function _expectedSupplyAssets(IERC4626 _market, address _user) internal view virtual returns (uint256 assets) {

976:     function _update(address _from, address _to, uint256 _value) internal virtual override {

994:     function _afterTokenTransfer(address _from, address _to, uint256 _value) internal virtual {

1033:     function _ERC20BalanceOf(address _token, address _account) internal view returns (uint256 balance) {

1037:     function _previewRedeem(IERC4626 _market, uint256 _shares) internal view returns (uint256 assets) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

40:     function __VaultIncentivesModule_init(address _owner, ISiloVault _vault) external virtual initializer {

67:     function acceptIncentivesClaimingLogic(IERC4626 _market, IIncentivesClaimingLogic _logic) external virtual {

109:     function addNotificationReceiver(INotificationReceiver _notificationReceiver) external virtual onlyOwner {

130:     function getAllIncentivesClaimingLogics() external view virtual returns (address[] memory logics) {

144:     function getNotificationReceivers() external view virtual returns (address[] memory receivers) {

149:     function getConfiguredMarkets() external view virtual returns (address[] memory markets) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

23:     function claimRewardsAndDistribute() external virtual {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

37:     function admin(ISiloVault _vault) external view returns (address);

40:     function fee(ISiloVault _vault) external view returns (uint256);

43:     function accruedFee(ISiloVault _vault) external view returns (uint256);

72:     function setAdmin(ISiloVault _vault, address _newAdmin) external;

75:     function setFee(ISiloVault _vault, uint256 _newFee) external;

78:     function transferFee(ISiloVault _vault, address payable _feeRecipient) external;

83:     function setFlowCaps(ISiloVault _vault, FlowCapsConfig[] calldata _config) external;

90:     function flowCaps(ISiloVault _vault, IERC4626 _market) external view returns (uint128, uint128);

102:     function flowCaps(ISiloVault _vault, IERC4626 _market) external view returns (FlowCaps memory);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloIncentivesControllerCLFactory.sol

23:     function createdInFactory(address _logic) external view returns (bool createdInFactory);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloIncentivesControllerCLFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

18:     function multicall(bytes[] calldata) external returns (bytes[] memory);

26:     function pendingOwner() external view returns (address);

32:     function DECIMALS_OFFSET() external view returns (uint8);

34:     function INCENTIVES_MODULE() external view returns (IVaultIncentivesModule);

40:     function reentrancyGuardEntered() external view returns (bool);

43:     function curator() external view returns (address);

46:     function isAllocator(address _target) external view returns (bool);

49:     function guardian() external view returns (address);

55:     function feeRecipient() external view returns (address);

58:     function timelock() external view returns (uint256);

62:     function supplyQueue(uint256) external view returns (IERC4626);

65:     function supplyQueueLength() external view returns (uint256);

70:     function withdrawQueue(uint256) external view returns (IERC4626);

73:     function withdrawQueueLength() external view returns (uint256);

79:     function lastTotalAssets() external view returns (uint256);

84:     function submitTimelock(uint256 _newTimelock) external;

97:     function submitCap(IERC4626 _market, uint256 _newSupplyCap) external;

104:     function revokePendingCap(IERC4626 _market) external;

115:     function submitMarketRemoval(IERC4626 _market) external;

119:     function revokePendingMarketRemoval(IERC4626 _market) external;

126:     function submitGuardian(address _newGuardian) external;

135:     function setIsAllocator(address _newAllocator, bool _newIsAllocator) external;

138:     function setCurator(address _newCurator) external;

144:     function setFeeRecipient(address _newFeeRecipient) external;

149:     function setSupplyQueue(IERC4626[] calldata _newSupplyQueue) external;

161:     function updateWithdrawQueue(uint256[] calldata _indexes) external;

174:     function reallocate(MarketAllocation[] calldata _allocations) external;

181:     function config(IERC4626) external view returns (uint184 cap, bool enabled, uint64 removableAt);

184:     function pendingGuardian() external view returns (address guardian, uint64 validAt);

187:     function pendingCap(IERC4626) external view returns (uint192 value, uint64 validAt);

190:     function pendingTimelock() external view returns (uint192 value, uint64 validAt);

200:     function config(IERC4626) external view returns (MarketConfig memory);

203:     function pendingGuardian() external view returns (PendingAddress memory);

206:     function pendingCap(IERC4626) external view returns (PendingUint192 memory);

209:     function pendingTimelock() external view returns (PendingUint192 memory);

212:     function balanceTracker(IERC4626) external view returns (uint256);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol

13:     function isSiloVault(address _target) external view returns (bool);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol

34:     function submitIncentivesClaimingLogic(IERC4626 _market, IIncentivesClaimingLogic _logic) external;

39:     function acceptIncentivesClaimingLogic(IERC4626 _market, IIncentivesClaimingLogic _logic) external;

44:     function removeIncentivesClaimingLogic(IERC4626 _market, IIncentivesClaimingLogic _logic) external;

49:     function revokePendingClaimingLogic(IERC4626 _market, IIncentivesClaimingLogic _logic) external;

53:     function addNotificationReceiver(INotificationReceiver _notificationReceiver) external;

60:     function removeNotificationReceiver(INotificationReceiver _notificationReceiver, bool _allProgramsStopped) external;

64:     function getAllIncentivesClaimingLogics() external view returns (address[] memory logics);

75:     function getNotificationReceivers() external view returns (address[] memory _notificationReceivers);

80:     function getMarketIncentivesClaimingLogics(IERC4626 _market) external view returns (address[] memory logics);

84:     function getConfiguredMarkets() external view returns (address[] memory markets);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/libraries/PendingLib.sol

35:     function update(PendingUint192 storage _pending, uint184 _newValue, uint256 _timelock) internal {

43:     function update(PendingAddress storage _pending, address _newValue, uint256 _timelock) internal {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/PendingLib.sol)

### <a name="NC-9"></a>[NC-9] Use a `modifier` instead of a `require/if` statement for a special `msg.sender` actor
If a function is supposed to be access-controlled, a `modifier` should be used instead of a `require/if` statement for more readability.

*Instances (3)*:
```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

35:         if (msg.sender != NOTIFIER) revert OnlyNotifier();

40:         if (msg.sender != NOTIFIER && msg.sender != owner()) revert OnlyNotifierOrOwner();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

37:         if (msg.sender != admin[vault] && msg.sender != ISiloVault(vault).owner()) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

### <a name="NC-10"></a>[NC-10] Consider using named mappings
Consider moving to solidity version 0.8.18 or later, and using [named mappings](https://ethereum.stackexchange.com/questions/51629/how-to-name-the-arguments-in-mapping/145555#145555) to make it easier to understand the purpose of each mapping

*Instances (17)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol

10:     mapping(address => bool) public isSiloIncentivesController;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol

9:     mapping(address => bool) public createdInFactory;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

25:     mapping(bytes32 => IncentivesProgram) public incentivesPrograms;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/IdleVaultsFactory.sol

17:     mapping(address => bool) public isIdleVault;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

25:     mapping(ISiloVault => address) public admin;

27:     mapping(ISiloVault => uint256) public fee;

29:     mapping(ISiloVault => uint256) public accruedFee;

31:     mapping(ISiloVault => mapping(IERC4626 => FlowCaps)) public flowCaps;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

56:     mapping(address => bool) public isAllocator;

62:     mapping(IERC4626 => MarketConfig) public config;

71:     mapping(IERC4626 => PendingUint192) public pendingCap;

81:     mapping(IERC4626 => uint256) public balanceTracker;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/SiloVaultsFactory.sol

24:     mapping(address => bool) public isSiloVault;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol

9:     mapping(address => bool) public createdInFactory;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

19:         mapping(address => bool) storage _isAllocator

33:         mapping(IERC4626 => MarketConfig) storage _config,

34:         mapping(IERC4626 => PendingUint192) storage _pendingCap,

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="NC-11"></a>[NC-11] Take advantage of Custom Error's return value property
An important feature of Custom Error is that values such as address, tokenID, msg.value can be written inside the () sign, this kind of approach provides a serious advantage in debugging and examining the revert details of dapps such as tenderly.

*Instances (51)*:
```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

31:         if (_authorizedClaimers[user] != claimer) revert ClaimerUnauthorized();

37:         if (_user == address(0)) revert InvalidUserAddress();

38:         if (_to == address(0)) revert InvalidToAddress();

108:                 revert DifferentRewardsTokens();

128:         if (_to == address(0)) revert InvalidToAddress();

139:         if (_to == address(0)) revert InvalidToAddress();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

35:         if (msg.sender != NOTIFIER) revert OnlyNotifier();

40:         if (msg.sender != NOTIFIER && msg.sender != owner()) revert OnlyNotifierOrOwner();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/IdleVault.sol

24:         if (onlyDepositor == address(0)) revert ErrorsLib.ZeroAddress();

41:         if (_receiver != ONLY_DEPOSITOR) revert();

48:         if (_receiver != ONLY_DEPOSITOR) revert();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVault.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

38:             revert ErrorsLib.NotAdminNorVaultOwner();

47:         if (admin[vault] == newAdmin) revert ErrorsLib.AlreadySet();

54:         if (fee[vault] == newFee) revert ErrorsLib.AlreadySet();

72:                 revert ErrorsLib.MaxSettableFlowCapExceeded();

99:         if (msg.value != fee[vault]) revert ErrorsLib.IncorrectFee();

102:         if (withdrawals.length == 0) revert ErrorsLib.EmptyWithdrawals();

120:             if (address(market) <= address(prevMarket)) revert ErrorsLib.InconsistentWithdrawals();

121:             if (address(market) == address(supplyMarket)) revert ErrorsLib.DepositMarketInWithdrawals();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

134:         if (sender != curator && sender != owner()) revert ErrorsLib.NotCuratorRole();

143:             revert ErrorsLib.NotAllocatorRole();

151:         if (_msgSender() != owner() && _msgSender() != guardian) revert ErrorsLib.NotGuardianRole();

159:             revert ErrorsLib.NotCuratorNorGuardianRole();

170:         if (_validAt == 0) revert ErrorsLib.NoPendingValue();

171:         if (block.timestamp < _validAt) revert ErrorsLib.TimelockNotElapsed();

180:         if (_newCurator == curator) revert ErrorsLib.AlreadySet();

194:         if (_newTimelock == timelock) revert ErrorsLib.AlreadySet();

195:         if (pendingTimelock.validAt != 0) revert ErrorsLib.AlreadyPending();

210:         if (_newFee == fee) revert ErrorsLib.AlreadySet();

211:         if (_newFee > ConstantsLib.MAX_FEE) revert ErrorsLib.MaxFeeExceeded();

212:         if (_newFee != 0 && feeRecipient == address(0)) revert ErrorsLib.ZeroFeeRecipient();

225:         if (_newFeeRecipient == feeRecipient) revert ErrorsLib.AlreadySet();

226:         if (_newFeeRecipient == address(0) && fee != 0) revert ErrorsLib.ZeroFeeRecipient();

238:         if (_newGuardian == guardian) revert ErrorsLib.AlreadySet();

239:         if (pendingGuardian.validAt != 0) revert ErrorsLib.AlreadyPending();

255:         if (pendingCap[_market].validAt != 0) revert ErrorsLib.AlreadyPending();

256:         if (config[_market].removableAt != 0) revert ErrorsLib.PendingRemoval();

258:         if (_newSupplyCap == supplyCap) revert ErrorsLib.AlreadySet();

271:         if (config[_market].removableAt != 0) revert ErrorsLib.AlreadyPending();

272:         if (config[_market].cap != 0) revert ErrorsLib.NonZeroCap();

290:         if (length > ConstantsLib.MAX_QUEUE_LENGTH) revert ErrorsLib.MaxQueueLengthExceeded();

427:         if (totalWithdrawn != totalSupplied) revert ErrorsLib.InconsistentReallocation();

776:         if (_shares == 0) revert ErrorsLib.InputZeroShares();

827:         if (_newTimelock > ConstantsLib.MAX_TIMELOCK) revert ErrorsLib.AboveMaxTimelock();

828:         if (_newTimelock < ConstantsLib.MIN_TIMELOCK) revert ErrorsLib.BelowMinTimelock();

897:         if (_assets != 0) revert ErrorsLib.AllCapsReached();

928:         if (_assets != 0) revert ErrorsLib.NotEnoughLiquidity();

1019:             if (!success) revert ErrorsLib.ClaimRewardsFailed();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

35:         if (_msgSender() != owner() && _msgSender() != guardian) revert ErrorsLib.NotGuardianRole();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol

21:         if (_isAllocator[_newAllocator] == _newIsAllocator) revert ErrorsLib.AlreadySet();

44:                 if (_withdrawQueue.length > ConstantsLib.MAX_QUEUE_LENGTH) revert ErrorsLib.MaxQueueLengthExceeded();

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/libraries/SiloVaultActionsLib.sol)

### <a name="NC-12"></a>[NC-12] Constants should be defined rather than using magic numbers

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/SiloVault.sol

122:         DECIMALS_OFFSET = uint8(UtilsLib.zeroFloorSub(18 + 6, decimals));

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

### <a name="NC-13"></a>[NC-13] Variables need not be initialized to zero
The default value for variables is zero, so initializing them to zero is superfluous.

*Instances (14)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

79:         for (uint256 i = 0; i < numberOfPrograms; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

100:         for (uint256 i = 0; i < _programNames.length; i++) {

232:         for (uint256 i = 0; i < accruedRewards.length; i++) {

292:         for (uint256 i = 0; i < _programIds.length; i++) {

307:         for (uint256 i = 0; i < _programNames.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

107:         for (uint256 i = 0; i < length; i++) {

182:         uint256 accruedRewards = 0;

223:         for (uint256 i = 0; i < length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

64:         for (uint256 i = 0; i < config.length; i++) {

112:         for (uint256 i = 0; i < withdrawals.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

168:         for (uint256 i = 0; i < _marketsInput.length; i++) {

178:         for (uint256 i = 0; i < _marketsInput.length; i++) {

181:             for (uint256 j = 0; j < marketLogics.length; j++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol

28:         for (uint256 i = 0; i < accruedRewards.length; i++) {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol)


## Low Issues


| |Issue|Instances|
|-|:-|:-:|
| [L-1](#L-1) | Use a 2-step ownership transfer pattern | 1 |
| [L-2](#L-2) | External call recipient may consume all transaction gas | 1 |
| [L-3](#L-3) | Initializers could be front-run | 3 |
| [L-4](#L-4) | Signature use at deadlines should be allowed | 4 |
| [L-5](#L-5) | Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership` | 4 |
| [L-6](#L-6) | `symbol()` is not a part of the ERC-20 standard | 1 |
| [L-7](#L-7) | Unsafe ERC20 operation(s) | 2 |
| [L-8](#L-8) | Unspecific compiler version pragma | 6 |
| [L-9](#L-9) | Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions | 2 |
| [L-10](#L-10) | Upgradeable contract not initialized | 6 |
### <a name="L-1"></a>[L-1] Use a 2-step ownership transfer pattern
Recommend considering implementing a two step process where the owner or admin nominates an account and the nominated account needs to call an `acceptOwnership()` function for the transfer of ownership to fully succeed. This ensures the nominated EOA account is a valid and active account. Lack of two-step procedure for critical operations leaves them error-prone. Consider adding two step procedure on the critical functions.

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

198: interface ISiloVault is ISiloVaultBase, IERC4626, IERC20Permit, IOwnable, IMulticall {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

### <a name="L-2"></a>[L-2] External call recipient may consume all transaction gas
There is no limit specified on the amount of gas used, so the recipient can use up all of the transaction's gas, causing it to revert. Use `addr.call{gas: <amount>}("")` or [this](https://github.com/nomad-xyz/ExcessivelySafeCall) library instead.

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/PublicAllocator.sol

85:         (bool success, bytes memory data) = feeRecipient.call{value: claimed}("");

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/PublicAllocator.sol)

### <a name="L-3"></a>[L-3] Initializers could be front-run
Initializers could be front-run, allowing an attacker to either set their own values, take ownership of the contract, and in the best case forcing a re-deployment

*Instances (3)*:
```solidity
File: ./silo-vaults/contracts/SiloVaultsFactory.sol

56:         vaultIncentivesModule.__VaultIncentivesModule_init(initialOwner, siloVault);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

40:     function __VaultIncentivesModule_init(address _owner, ISiloVault _vault) external virtual initializer {

41:         __Ownable_init(_owner);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="L-4"></a>[L-4] Signature use at deadlines should be allowed
According to [EIP-2612](https://github.com/ethereum/EIPs/blob/71dc97318013bf2ac572ab63fab530ac9ef419ca/EIPS/eip-2612.md?plain=1#L58), signatures used on exactly the deadline timestamp are supposed to be allowed. While the signature may or may not be used for the exact EIP-2612 use case (transfer approvals), for consistency's sake, all deadlines should follow this semantic. If the timestamp is an expiration rather than a deadline, consider whether it makes more sense to include the expiration timestamp as a valid timestamp, as is done for deadlines.

*Instances (4)*:
```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

51:         require(_incentivesProgramInput.distributionEnd >= block.timestamp, InvalidDistributionEnd());

62:         require(_distributionEnd >= block.timestamp, InvalidDistributionEnd());

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

57:         require(_distributionEnd >= block.timestamp, ISiloIncentivesController.InvalidDistributionEnd());

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

69:         require(validAt != 0 && validAt < block.timestamp, CantAcceptLogic());

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="L-5"></a>[L-5] Use `Ownable2Step.transferOwnership` instead of `Ownable.transferOwnership`
Use [Ownable2Step.transferOwnership](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol) which is safer. Use it as it is more secure due to 2-stage ownership transfer.

**Recommended Mitigation Steps**

Use <a href="https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol">Ownable2Step.sol</a>
  
  ```solidity
      function acceptOwnership() external {
          address sender = _msgSender();
          require(pendingOwner() == sender, "Ownable2Step: caller is not the new owner");
          _transferOwnership(sender);
      }
```

*Instances (4)*:
```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

8: import {Ownable2Step, Ownable} from "openzeppelin5/access/Ownable2Step.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

7: import {Ownable2Step, Ownable} from "openzeppelin5/access/Ownable2Step.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

4: import {Ownable2StepUpgradeable, OwnableUpgradeable} from "openzeppelin5-upgradeable/access/Ownable2StepUpgradeable.sol";

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

23:     function transferOwnership(address) external;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

### <a name="L-6"></a>[L-6] `symbol()` is not a part of the ERC-20 standard
The `symbol()` function is not a part of the [ERC-20 standard](https://eips.ethereum.org/EIPS/eip-20), and was added later as an [optional extension](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/IERC20Metadata.sol). As such, some valid ERC20 tokens do not support this interface, so it is unsafe to blindly cast all tokens to this interface, and then call this function.

*Instances (1)*:
```solidity
File: ./silo-vaults/contracts/IdleVaultsFactory.sol

24:             string.concat("IV-", IERC20Metadata(address(_vault)).symbol())

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/IdleVaultsFactory.sol)

### <a name="L-7"></a>[L-7] Unsafe ERC20 operation(s)

*Instances (2)*:
```solidity
File: ./silo-vaults/contracts/SiloVault.sol

550:         success = ERC20.transfer(_to, _value);

563:         success = ERC20.transferFrom(_from, _to, _value);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

### <a name="L-8"></a>[L-8] Unspecific compiler version pragma

*Instances (6)*:
```solidity
File: ./silo-vaults/contracts/interfaces/IIncentivesClaimingLogic.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IIncentivesClaimingLogic.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/INotificationReceiver.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/INotificationReceiver.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IPublicAllocator.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IPublicAllocator.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol

2: pragma solidity >=0.5.0;

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol)

### <a name="L-9"></a>[L-9] Upgradeable contract is missing a `__gap[50]` storage variable to allow for new storage variables in later versions
See [this](https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps) link for a description of this storage variable. While some contracts may not currently be sub-classed, adding the variable now protects against forgetting to add it in the future.

*Instances (2)*:
```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

4: import {Ownable2StepUpgradeable, OwnableUpgradeable} from "openzeppelin5-upgradeable/access/Ownable2StepUpgradeable.sol";

15: contract VaultIncentivesModule is IVaultIncentivesModule, Ownable2StepUpgradeable {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

### <a name="L-10"></a>[L-10] Upgradeable contract not initialized
Upgradeable contracts are initialized via an initializer function rather than by a constructor. Leaving such a contract uninitialized may lead to it being taken over by a malicious user

*Instances (6)*:
```solidity
File: ./silo-vaults/contracts/SiloVaultsFactory.sol

56:         vaultIncentivesModule.__VaultIncentivesModule_init(initialOwner, siloVault);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVaultsFactory.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

4: import {Ownable2StepUpgradeable, OwnableUpgradeable} from "openzeppelin5-upgradeable/access/Ownable2StepUpgradeable.sol";

15: contract VaultIncentivesModule is IVaultIncentivesModule, Ownable2StepUpgradeable {

28:         _disableInitializers();

40:     function __VaultIncentivesModule_init(address _owner, ISiloVault _vault) external virtual initializer {

41:         __Ownable_init(_owner);

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)


## Medium Issues


| |Issue|Instances|
|-|:-|:-:|
| [M-1](#M-1) | Centralization Risk for trusted owners | 25 |
### <a name="M-1"></a>[M-1] Centralization Risk for trusted owners

#### Impact:
Contracts have owners with privileged rights to perform admin tasks and need to be trusted to not perform malicious updates or drain funds.

*Instances (25)*:
```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesController.sol

123:     function rescueRewards(address _rewardToken) external onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol

53:     function killGauge() external virtual onlyOwner {

59:     function unkillGauge() external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol)

```solidity
File: ./silo-core/contracts/incentives/base/BaseIncentivesController.sol

48:     ) external virtual onlyOwner {

61:     ) external virtual onlyOwner {

170:     function setClaimer(address _user, address _caller) external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/BaseIncentivesController.sol)

```solidity
File: ./silo-core/contracts/incentives/base/DistributionManager.sol

8: import {Ownable2Step, Ownable} from "openzeppelin5/access/Ownable2Step.sol";

20: contract DistributionManager is IDistributionManager, Ownable2Step {

46:     constructor(address _owner, address _notifier) Ownable(_owner) {

56:     ) external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-core/contracts/incentives/base/DistributionManager.sol)

```solidity
File: ./silo-vaults/contracts/SiloVault.sol

7: import {Ownable2Step, Ownable} from "openzeppelin5/access/Ownable2Step.sol";

33: contract SiloVault is ERC4626, ERC20Permit, Ownable2Step, Multicall, ISiloVaultStaticTyping {

116:     ) ERC4626(IERC20(_asset)) ERC20Permit(_name) ERC20(_name, _symbol) Ownable(_owner) {

179:     function setCurator(address _newCurator) external virtual onlyOwner {

188:     function setIsAllocator(address _newAllocator, bool _newIsAllocator) external virtual onlyOwner {

193:     function submitTimelock(uint256 _newTimelock) external virtual onlyOwner {

209:     function setFee(uint256 _newFee) external virtual onlyOwner {

224:     function setFeeRecipient(address _newFeeRecipient) external virtual onlyOwner {

237:     function submitGuardian(address _newGuardian) external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/SiloVault.sol)

```solidity
File: ./silo-vaults/contracts/incentives/VaultIncentivesModule.sol

52:     ) external virtual onlyOwner {

86:     ) external virtual onlyOwner {

109:     function addNotificationReceiver(INotificationReceiver _notificationReceiver) external virtual onlyOwner {

120:     ) external virtual onlyOwner {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/incentives/VaultIncentivesModule.sol)

```solidity
File: ./silo-vaults/contracts/interfaces/ISiloVault.sol

21: interface IOwnable {

198: interface ISiloVault is ISiloVaultBase, IERC4626, IERC20Permit, IOwnable, IMulticall {

```
[Link to code](https://github.com/code-423n4/2025-03-silo-finance/blob/main/./silo-vaults/contracts/interfaces/ISiloVault.sol)

