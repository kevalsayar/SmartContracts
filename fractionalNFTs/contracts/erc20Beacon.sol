// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

contract ERC20Beacon {
    UpgradeableBeacon beacon;

    address public vLogic;
    address payable public beaconOwner;

    /**
     * @dev Emitted when ownership of the contract's transferred.
     */
    event BeaconOwnershipTransferred(address previousOwner, address newOwner);

    /**
     * @dev Throws if an implementation's preset for this contract.
     */
    modifier initCheck() {
        require(vLogic == address(0x0), "Can't initialize more than once!");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier ownerOnly() {
        require(tx.origin == beaconOwner, "Caller's not the owner!");
        _;
    }

    /**
     * @dev Throws if address passed is not a valid one.
     */
    modifier isAddressValid(address _addr) {
        require(
            _addr.code.length == 0 && _addr != address(0),
            "New owner's a zero address!"
        );
        _;
    }

    /**
     * @dev Sets the address of initial implementation, and the contract's deployer as the
     * initial owner of the contract.
     */
    function initializer(address _vLogic) public initCheck {
        beacon = new UpgradeableBeacon(_vLogic);
        vLogic = _vLogic;
        beaconOwner = payable(tx.origin);
    }

    /**
     * @dev Upgrades the beacon to a new implementation.
     *
     * Requirements:
     *
     * - tx.origin must be owner of the contract.
     * - `_newEscrowImplAddress` must be a contract.
     */
    function update(address _vLogic) public ownerOnly {
        beacon.upgradeTo(_vLogic);
        vLogic = _vLogic;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`_newBeaconOwner`).
     * Can only be called by the current owner.
     *
     * Emits an {OwnershipTransferred} event.
     */
    function transferBeaconOwnership(address payable _newBeaconOwner)
        public
        ownerOnly
        isAddressValid(_newBeaconOwner)
    {
        beaconOwner = _newBeaconOwner;
        emit BeaconOwnershipTransferred(beaconOwner, _newBeaconOwner);
    }

    function implementation() public view returns (address) {
        return beacon.implementation();
    }
}
