// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./escrow.sol";
import "./escrowbeacon.sol";

contract EscrowFactory {
    address payable private factoryOwner;
    mapping(string => mapping(string => address)) private userInfo;
    EscrowBeacon beacon;

    /**
     * @dev Emitted when a new proxy address for Escrow's deployed.
     */
    event NewProxyAddress(address NewProxyAddress, string dealId);
    
    /**
     * @dev Emitted when ownership of the contract's transferred.
     */
    event OwnershipTransferred(address previousOwner, address newOwner);

    /**
     * @dev Throws if an owner's preset for this contract.
     */
    modifier initCheck() {
        require(factoryOwner == address(0x0), "Contract's previously initialised!");
        _;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier ownerOnly(){
        require(msg.sender == factoryOwner, "Caller's not the owner!");
        _;
    }

    /**
     * @dev Throws if address passed is not a valid one.
     */
    modifier isAddressValid(address _addr) {
        require(_addr.code.length == 0 && _addr != address(0) , "New owner's a zero address!");
        _;
    } 
    
    /**
     * @dev Sets the address of initial implementation, and the contract's deployer as the 
     * initial owner of the contract.
     */
    function initialize(address _vLogic) 
        public 
        initCheck
    {
        factoryOwner = payable(msg.sender);
        beacon = new EscrowBeacon();
        beacon.initializer(_vLogic);
    }

    /**
     * @dev Creates a beacon proxy, sets user's details and deposits ether into
     * the beacon proxy.
     *
     * Emits a {NewProxyAddress} event.
     */
    function createEscrowProxy(
        string memory _userId,
        string memory _dealId,
        address payable _commissionWallet,
        uint256 _minimumEscrowAmount,
        uint256 _commissionRate,
        address payable _seller
    ) 
        payable
        external
    {
        BeaconProxy proxy = new BeaconProxy(address(beacon), 
            abi.encodeWithSelector(Escrow(address(0)).initializeDeal.selector, _commissionWallet, _minimumEscrowAmount, _commissionRate, factoryOwner)
        );
        emit NewProxyAddress(address(proxy), _dealId);
        setUserDealDetails(_userId, _dealId, address(proxy)); 
        Escrow(address(proxy)).escrowParties(_seller);
        Escrow(address(proxy)).deposit{value: msg.value}();
    }

    /**
     * @dev Sets proxy contract address against the user's specific dealId.
     * Private function without access restriction.
     */
    function setUserDealDetails(
        string memory _userId,
        string memory _dealId, 
        address _escrowAddress
    ) 
        private
    {
        userInfo[_userId][_dealId] = _escrowAddress;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`_newFactoryOwner`).
     * Can only be called by the current owner.
     */
    function transferFactoryOwnership(
        address payable _newFactoryOwner
    ) 
        public
        ownerOnly
        isAddressValid (_newFactoryOwner)
    {
        factoryOwner = _newFactoryOwner;
        emit OwnershipTransferred(factoryOwner, _newFactoryOwner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function getFactoryOwner() public view returns (address) {
        return factoryOwner;
    }

    /**
     * @dev Returns proxy address of a particular user's deal.
     */
    function escrowProxyAddress(
        string memory _userId,
        string memory _dealId
    ) 
        public 
        view 
        returns (address) 
    {
        return userInfo[_userId][_dealId];
    }
    
    /**
     * @dev Returns implementation address for a particular beacon.
     */
    function escrowImplAddress() public view returns (address) {
        return beacon.implementation();
    }

    /**
     * @dev Returns beacon address to which proxy address's point to.
     */
    function escrowBeaconAddress() public view returns (address) {
        return address (beacon);
    }
}
