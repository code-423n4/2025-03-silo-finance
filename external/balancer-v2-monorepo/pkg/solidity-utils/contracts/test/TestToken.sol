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

import "../openzeppelin/ERC20Burnable.sol";
import "../openzeppelin/ERC20Permit.sol";
import "../openzeppelin/ERC20.sol";

contract TestToken is ERC20, ERC20Burnable, ERC20Permit {
    constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol) ERC20Permit(name) {
        _setupDecimals(decimals);
    }

    function mint(address recipient, uint256 amount) external {
        _mint(recipient, amount);
    }

    // burnWithoutAllowance was created to allow burn of token without approval. Example of use:
    //
    // MockGearboxVault.sol can't use burnFrom function (from ERC20Burnable) in unit tests, since
    // MockGearboxVault doesn't have permission to burn relayer wrapped tokens and relayer is not a Signer
    function burnWithoutAllowance(address sender, uint256 amount) external {
        _burn(sender, amount);
    }
}
