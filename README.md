# Silo Finance audit details
- Total Prize Pool: $50,000 in USDC
  - HM awards: $33,500 in USDC
  - QA awards: $1,400 in USDC
  - Judge awards: $4,000 in USDC
  - Validator awards: $2,600 in USDC 
  - Scout awards: $500 in USDC
  - Mitigation Review: $8,000 in USDC
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts March 24, 2025 20:00 UTC
- Ends March 31, 2025 20:00 UTC

**Note re: risk level upgrades/downgrades**

Two important notes about judging phase risk adjustments: 
- High- or Medium-risk submissions downgraded to Low-risk (QA) will be ineligible for awards.
- Upgrading a Low-risk finding from a QA report to a Medium- or High-risk finding is not supported.

As such, wardens are encouraged to select the appropriate risk level carefully during the submission phase.

## Automated Findings / Publicly Known Issues

The 4naly3er report can be found [here](https://github.com/code-423n4/2025-01-silo-finance/blob/main/4naly3er-report.md).



_Note for C4 wardens: Anything included in this `Automated Findings / Publicly Known Issues` section is considered a publicly known issue and is ineligible for awards._

- Donation/first deposit attack is possible but unprofitable because of decimal offset.
- Acknowledged issues from previous audits.

# Overview

Silo Finance is a non-custodial money protocol that implements permissionless, isolated lending markets, known as silos. Silo Vault serves as the managed liquidity layer, channeling liquidity into Silo’s lending markets (silos) or any 4626 lending vaults.

## Links

- **Previous audits:** See [Drive folder](https://drive.google.com/drive/folders/1WjygQr40wT3-0XnOHcT1Fo9ef8acyRCV?usp=sharing)
- **Documentation:**
  - https://docs.morpho.org/morpho-vaults/overview
  - https://silo-finance.gitbook.io/private-space/silo-vaults
- **Website:** https://www.silo.finance/
- **X/Twitter:** https://x.com/SiloFinance
- **Discord:** https://discord.gg/silo-finance

---

# Scope

*See [scope.txt](https://github.com/code-423n4/2025-03-silo-finance/blob/main/scope.txt)*

### Files in scope


| File   | Logic Contracts | Interfaces | nSLOC | Purpose | Libraries used |
| ------ | --------------- | ---------- | ----- | -----   | ------------ |
| /silo-vaults/contracts/IdleVault.sol | 1| **** | 33 | |openzeppelin5/token/ERC20/extensions/ERC4626.sol<br>openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/IdleVaultsFactory.sol | 1| **** | 22 | |openzeppelin5/proxy/Clones.sol<br>openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/PublicAllocator.sol | 1| **** | 90 | |openzeppelin5/interfaces/IERC4626.sol<br>morpho-blue/libraries/UtilsLib.sol<br>silo-core/contracts/lib/RevertLib.sol|
| /silo-vaults/contracts/SiloVault.sol | 1| **** | 554 | |openzeppelin5/utils/math/SafeCast.sol<br>openzeppelin5/token/ERC20/extensions/ERC4626.sol<br>openzeppelin5/interfaces/IERC4626.sol<br>openzeppelin5/access/Ownable2Step.sol<br>openzeppelin5/token/ERC20/extensions/ERC20Permit.sol<br>openzeppelin5/utils/Multicall.sol<br>openzeppelin5/token/ERC20/ERC20.sol<br>openzeppelin5/token/ERC20/utils/SafeERC20.sol<br>morpho-blue/libraries/UtilsLib.sol<br>silo-core/contracts/lib/TokenHelper.sol|
| /silo-vaults/contracts/SiloVaultsFactory.sol | 1| **** | 37 | |openzeppelin5/proxy/Clones.sol|
| /silo-vaults/contracts/incentives/VaultIncentivesModule.sol | 1| **** | 106 | |openzeppelin5-upgradeable/access/Ownable2StepUpgradeable.sol<br>openzeppelin5/utils/structs/EnumerableSet.sol<br>openzeppelin5/interfaces/IERC4626.sol<br>silo-vaults/contracts/interfaces/ISiloVault.sol|
| /silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCL.sol | 1| **** | 25 | |silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol|
| /silo-vaults/contracts/incentives/claiming-logics/SiloIncentivesControllerCLFactory.sol | 1| **** | 11 | ||
| /silo-vaults/contracts/interfaces/IIncentivesClaimingLogic.sol | ****| 1 | 5 | ||
| /silo-vaults/contracts/interfaces/INotificationReceiver.sol | ****| 1 | 3 | ||
| /silo-vaults/contracts/interfaces/IPublicAllocator.sol | ****| 3 | 20 | |openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/interfaces/ISiloIncentivesControllerCLFactory.sol | ****| 1 | 5 | ||
| /silo-vaults/contracts/interfaces/ISiloVault.sol | ****| 5 | 15 | |openzeppelin5/token/ERC20/extensions/ERC20Permit.sol<br>openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/interfaces/ISiloVaultsFactory.sol | ****| 1 | 4 | ||
| /silo-vaults/contracts/interfaces/IVaultIncentivesModule.sol | ****| 1 | 23 | |openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/libraries/ConstantsLib.sol | 1| **** | 7 | ||
| /silo-vaults/contracts/libraries/ErrorsLib.sol | 1| **** | 52 | |openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/libraries/EventsLib.sol | 1| **** | 64 | |openzeppelin5/interfaces/IERC4626.sol|
| /silo-vaults/contracts/libraries/PendingLib.sol | 1| **** | 24 | ||
| /silo-vaults/contracts/libraries/SiloVaultActionsLib.sol | 1| **** | 43 | |openzeppelin5/interfaces/IERC4626.sol<br>morpho-blue/libraries/UtilsLib.sol<br>openzeppelin5/token/ERC20/utils/SafeERC20.sol|
| /silo-core/contracts/incentives/SiloIncentivesController.sol | 1| **** | 78 | |openzeppelin5/token/ERC20/utils/SafeERC20.sol<br>openzeppelin5/token/ERC20/IERC20.sol<br>openzeppelin5/utils/structs/EnumerableSet.sol<br>openzeppelin5/utils/Strings.sol|
| /silo-core/contracts/incentives/SiloIncentivesControllerFactory.sol | 1| **** | 11 | ||
| /silo-core/contracts/incentives/SiloIncentivesControllerGaugeLike.sol | 1| **** | 44 | |openzeppelin5/token/ERC20/IERC20.sol|
| /silo-core/contracts/incentives/SiloIncentivesControllerGaugeLikeFactory.sol | 1| **** | 11 | ||
| /silo-core/contracts/incentives/base/BaseIncentivesController.sol | 1| **** | 159 | |openzeppelin5/token/ERC20/IERC20.sol<br>openzeppelin5/token/ERC20/utils/SafeERC20.sol<br>openzeppelin5/utils/structs/EnumerableSet.sol|
| /silo-core/contracts/incentives/base/DistributionManager.sol | 1| **** | 162 | |openzeppelin5/token/ERC20/IERC20.sol<br>openzeppelin5/token/ERC20/extensions/IERC20Metadata.sol<br>openzeppelin5/utils/math/Math.sol<br>openzeppelin5/access/Ownable2Step.sol<br>openzeppelin5/utils/structs/EnumerableSet.sol|
| /silo-core/contracts/incentives/interfaces/IDistributionManager.sol | ****| 1 | 34 | ||
| /silo-core/contracts/incentives/interfaces/ISiloIncentivesController.sol | ****| 1 | 28 | ||
| /silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerFactory.sol | ****| 1 | 4 | ||
| /silo-core/contracts/incentives/interfaces/ISiloIncentivesControllerGaugeLikeFactory.sol | ****| 1 | 4 | ||
| /silo-core/contracts/incentives/lib/DistributionTypes.sol | 1| **** | 19 | ||
| **Totals** | **20** | **17** | **1697** | | |

### Files out of scope

*See [out_of_scope.txt](https://github.com/code-423n4/2025-03-silo-finance/blob/main/out_of_scope.txt)*

## Scoping Q &amp; A

### General questions

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| ERC20 used by the protocol              |       Any              |
| Test coverage                           | ~90% on average (see [coverage folder](https://github.com/code-423n4/2025-01-silo-finance/blob/main/coverage) for details)                          |
| ERC721 used  by the protocol            |            None              |
| ERC777 used by the protocol             |           None                |
| ERC1155 used by the protocol            |              None            |
| Chains the protocol will be deployed on | Ethereum,Arbitrum,Base,Optimism,Polygon,OtherSonic  |

### ERC20 token behaviors in scope

| Question                                                                                                                                                   | Answer |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| [Missing return values](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#missing-return-values)                                                      |   In scope  |
| [Fee on transfer](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#fee-on-transfer)                                                                  |  Out of scope  |
| [Balance changes outside of transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#balance-modifications-outside-of-transfers-rebasingairdrops) | Out of scope    |
| [Upgradeability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#upgradable-tokens)                                                                 |   Out of scope  |
| [Flash minting](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#flash-mintable-tokens)                                                              | Out of scope    |
| [Pausability](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#pausable-tokens)                                                                      | Out of scope    |
| [Approval race protections](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#approval-race-protections)                                              | Out of scope    |
| [Revert on approval to zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-approval-to-zero-address)                            | In scope    |
| [Revert on zero value approvals](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-approvals)                                    | In scope    |
| [Revert on zero value transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                    | In scope    |
| [Revert on transfer to the zero address](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-transfer-to-the-zero-address)                    | In scope    |
| [Revert on large approvals and/or transfers](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-large-approvals--transfers)                  | In scope    |
| [Doesn't revert on failure](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#no-revert-on-failure)                                                   |  In scope   |
| [Multiple token addresses](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#revert-on-zero-value-transfers)                                          | Out of scope    |
| [Low decimals ( < 6)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#low-decimals)                                                                 |   In scope  |
| [High decimals ( > 18)](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#high-decimals)                                                              | Out of scope    |
| [Blocklists](https://github.com/d-xo/weird-erc20?tab=readme-ov-file#tokens-with-blocklists)                                                                | Out of scope    |

### External integrations (e.g., Uniswap) behavior in scope:


| Question                                                  | Answer |
| --------------------------------------------------------- | ------ |
| Enabling/disabling fees (e.g. Blur disables/enables fees) | Yes   |
| Pausability (e.g. Uniswap pool gets paused)               |  Yes   |
| Upgradeability (e.g. Uniswap gets upgraded)               |   No  |


### EIP compliance checklist

| Question                                | Answer                       |
| --------------------------------------- | ---------------------------- |
| silo-vaults/contracts/SiloVault.sol                         | ERC4626                |
| silo-vaults/contracts/IdleVault.sol                        | ERC4626                       |


# Additional context

## Main invariants

See [Certora prover specs files](https://github.com/silo-finance/silo-contracts-v2/tree/develop/certora/specs/vaults)


## Attack ideas (where to focus for bugs)
Forked code: SiloVault is a fork of MorphoVault. Original code only supported deploying capital to Morpho protocol while SiloVault was changed to support any ERC4626 vault and highly configurable rewards. Admin role stayed unchanged. New admin function were added to manage rewards setup. It is a good start to make sure that code integrity is kept and no bugs were introduced during forking.

Rewards: SiloVault supports custom rewards distribution. It is important that rewards do not compromise the SiloVault logic in any way and are distributed correctly.

## All trusted roles in the protocol

* Owner
* Curator
* Allocator
* Guardian

Same as MorphoVault with addition to new privileges for owner to manage the rewards. For details, see Morpho docs.
See also more details in [the following doc](https://silo-finance.gitbook.io/private-space/silo-vaults#roles-management)

## Describe any novel or unique curve logic or mathematical models implemented in the contracts:
N/A


## Running tests

See docs: https://github.com/silo-finance/silo-contracts-v2/blob/develop/MOREDOCS.md 


```bash
git clone --recurse-submodules https://github.com/code-423n4/2025-03-silo-finance.git
cd 2025-03-silo-finance

# Create the file ".env" in a root of this folder. ".env.example" is an example.
# RPC_MAINNET, RPC_ARBITRUM, RPC_ANVIL, PRIVATE_KEY are required to run the tests.

#  Build Silo foundry utils to prepare tools for Silo deployment and testing
$ cd ./gitmodules/silo-foundry-utils && cargo build --release && cp target/release/silo-foundry-utils ../../silo-foundry-utils && cd -


# ensure foundry is set to v0.3.0
foundryup -i 0.3.0
forge -V
# Should output `forge 0.3.0 (5a8bd89 2024-12-19T17:17:08.560665000Z)`

# Core tests:
FOUNDRY_PROFILE=core-test forge test --no-match-test "_skip_" --nmc "SiloIntegrationTest|MaxBorrow|MaxLiquidationTest|MaxLiquidationBadDebt|PreviewTest|PreviewDepositTest|PreviewMintTest" --ffi -vv

# Vaults tests:
FOUNDRY_PROFILE=vaults-with-tests forge test  --no-match-test "_skip_" --no-match-contract "SiloIntegrationTest"
```

## Miscellaneous
Employees of Silo Finance and employees' family members are ineligible to participate in this audit.

Code4rena's rules cannot be overridden by the contents of this README. In case of doubt, please check with C4 staff.
