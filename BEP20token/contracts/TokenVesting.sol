// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title TokenVesting.
 */
contract TokenVesting is Ownable, ReentrancyGuard {
    using SafeMath for uint256;

    // start time of the vesting period.
    uint256 private immutable vestingStart;
    // cliff period in seconds.
    uint256 private immutable vestingCliff;
    // duration of the vesting period in seconds.
    uint256 private immutable vestingDuration;
    // duration of a slice period for the vesting in seconds.
    uint256 private immutable vestingSlicePeriod;

    struct VestingStructure {
        bool initialized;
        // beneficiary of tokens after they're released.
        address beneficiary;
        // whether or not the vesting is revocable.
        bool revocable;
        // total amount of tokens to be released at the end of the vesting.
        uint256 amountTotal;
        // amount of tokens released.
        uint256 released;
        // whether or not the vesting has been revoked.
        bool revoked;
    }

    // Address of the BEP20 token.
    ERC20 private immutable token;

    mapping(bytes32 => VestingStructure) private vestingIdToVestingStructure;

    uint256 private VestingTotalAmount;

    event Released(bytes32 vestingId, uint256 totalTokenAmountReleased);
    event Revoked(
        bytes32 vestingId,
        uint256 totalTokenAmountReleased,
        bool revoked
    );
    event NewVestingSchedule(
        bytes32 vestingId,
        address beneficiary,
        bool revocable,
        uint256 amountTotal,
        uint256 released,
        bool revoked
    );

    /**
     * @dev Reverts if the vesting schedule does not exist or has been revoked.
     */
    modifier onlyIfVestingNotRevoked(bytes32 vestingId) {
        require(
            vestingIdToVestingStructure[vestingId].initialized == true,
            "TokenVesting: vesting schedule's not initialized"
        );
        require(
            vestingIdToVestingStructure[vestingId].revoked == false,
            "TokenVesting: vesting schedule's revoked"
        );
        _;
    }

    /**
     * @dev Reverts if the address provided is of zero type.
     */
    modifier zeroAddressCheck(address account) {
        require(
            account != address(0),
            "TokenVesting: zero address not permitted!"
        );
        _;
    }

    /**
     * @dev Creates a vesting contract.
     * @param token_ address of the BEP20 token contract
     */
    constructor(
        address token_,
        uint256 _vestingStart,
        uint256 _vestingCliff,
        uint256 _vestingDuration,
        uint256 _vestingSlicePeriod
    ) zeroAddressCheck(token_) {
        require(
            _vestingDuration > 0,
            "TokenVesting: vesting duration must be greater than 0."
        );
        require(
            _vestingSlicePeriod >= 1,
            "TokenVesting: vesting slicePeriodSeconds must be greater than or equal to 1."
        );

        token = ERC20(token_);
        vestingStart = _vestingStart;
        vestingCliff = _vestingStart.add(_vestingCliff);
        vestingDuration = _vestingDuration;
        vestingSlicePeriod = _vestingSlicePeriod;
    }

    /**
     * @notice Returns the vesting information for a given holder.
     * @return the vesting structure information.
     */
    function getVestingScheduleByAddress(address holder)
        external
        view
        zeroAddressCheck(holder)
        returns (VestingStructure memory)
    {
        return getVestingSchedule(computeVestingIdForAddress(holder));
    }

    /**
     * @notice Computes the vesting identifier for an address.
     * @return the vesting schedule identifier in bytes.
     */
    function computeVestingIdForAddress(address holder)
        public
        pure
        zeroAddressCheck(holder)
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(holder));
    }

    /**
     * @notice Returns the vesting schedule information for a given identifier.
     * @return the vesting schedule structure information.
     */
    function getVestingSchedule(bytes32 vestingId)
        internal
        view
        returns (VestingStructure memory)
    {
        return vestingIdToVestingStructure[vestingId];
    }

    /**
     * @notice Returns the total amount of vesting schedules.
     * @return the total amount of vesting schedules.
     */
    function getVestingTokenHoldersTotalAmount()
        external
        view
        returns (uint256)
    {
        return VestingTotalAmount;
    }

    /**
     * @notice Returns the address of the BEP20 token managed by the vesting contract.
     * @return the address of the BEP20 token.
     */
    function getTokenAddress() external view returns (address) {
        return address(token);
    }

    /**
     * @notice Creates a new vesting schedule for a beneficiary.
     * @param _beneficiary address of the beneficiary to whom vested tokens are transferred.
     * @param _revocable whether the vesting is revocable or not.
     * @param _amount total amount of tokens to be released at the end of the vesting.
     */
    function vestingAllocation(
        address _beneficiary,
        bool _revocable,
        uint256 _amount
    ) public onlyOwner zeroAddressCheck(_beneficiary) {
        require(
            getCurrentTime() <= vestingStart,
            "TokenVesting: cannot create schedules since vesting period has begun."
        );
        require(_amount > 0, "TokenVesting: amount must be greater than 0.");
        require(
            getWithdrawableAmount() >= _amount,
            "TokenVesting: cannot create vesting schedule because of insufficient tokens."
        );

        bytes32 vestingId = computeVestingIdForAddress(_beneficiary);

        if (vestingIdToVestingStructure[vestingId].amountTotal > 0) {
            vestingIdToVestingStructure[vestingId].amountTotal =
                vestingIdToVestingStructure[vestingId].amountTotal +
                _amount;

            VestingTotalAmount = VestingTotalAmount.add(_amount);
        } else {
            vestingIdToVestingStructure[vestingId] = VestingStructure(
                true,
                _beneficiary,
                _revocable,
                _amount,
                0,
                false
            );

            emit NewVestingSchedule(
                vestingId,
                _beneficiary,
                _revocable,
                _amount,
                0,
                false
            );

            VestingTotalAmount = VestingTotalAmount.add(_amount);
        }
    }

    /**
     * @notice Revokes the vesting schedule for given identifier.
     * @param beneficiary the vesting token holder.
     */
    function revoke(address beneficiary)
        public
        onlyOwner
        zeroAddressCheck(beneficiary)
        onlyIfVestingNotRevoked(computeVestingIdForAddress(beneficiary))
    {
        bytes32 vestingId = computeVestingIdForAddress(beneficiary);

        require(
            vestingIdToVestingStructure[vestingId].revocable == true,
            "TokenVesting: vesting schedule is not revocable"
        );

        VestingStructure storage vestingStructure = vestingIdToVestingStructure[
            vestingId
        ];

        release(beneficiary);
        vestingStructure.revoked = true;

        uint256 unreleased = vestingStructure.amountTotal.sub(
            vestingStructure.released
        );

        VestingTotalAmount = VestingTotalAmount.sub(unreleased);

        emit Revoked(vestingId, vestingStructure.released, true);
    }

    /**
     * @notice Withdraw all available funds.
     */
    function withdrawAvailableFunds() public nonReentrant onlyOwner {
        require(
            getWithdrawableAmount() > 0,
            "TokenVesting: cannot withdraw because of insufficient tokens"
        );

        token.transfer(owner(), getWithdrawableAmount());
    }

    /**
     * @notice Release vested amount of tokens.
     * @param beneficiary the vesting token holder.
     */
    function release(address beneficiary)
        public
        nonReentrant
        zeroAddressCheck(beneficiary)
        onlyIfVestingNotRevoked(computeVestingIdForAddress(beneficiary))
    {
        bytes32 vestingId = computeVestingIdForAddress(beneficiary);

        VestingStructure storage vestingStructure = vestingIdToVestingStructure[
            vestingId
        ];

        bool isBeneficiary = msg.sender == vestingStructure.beneficiary;
        bool isOwner = msg.sender == owner();

        require(
            isBeneficiary || isOwner,
            "TokenVesting: only beneficiary and owner can release vested tokens."
        );

        uint256 vestedAmount = _computeReleasableAmount(vestingStructure);

        require(
            vestedAmount > 0,
            "TokenVesting: cannot release tokens, not enough vested tokens."
        );

        vestingStructure.released = vestingStructure.released.add(vestedAmount);

        VestingTotalAmount = VestingTotalAmount.sub(vestedAmount);

        token.transfer(vestingStructure.beneficiary, vestedAmount);
        emit Released(vestingId, vestingStructure.released);
    }

    /**
     * @notice Computes the vested amount of tokens for a given holder.
     * @param beneficiary the vesting token holder.
     * @return the vested amount.
     */
    function computeReleasableAmount(address beneficiary)
        public
        view
        zeroAddressCheck(beneficiary)
        onlyIfVestingNotRevoked(computeVestingIdForAddress(beneficiary))
        returns (uint256)
    {
        bytes32 vestingId = computeVestingIdForAddress(beneficiary);

        VestingStructure storage vestingStructure = vestingIdToVestingStructure[
            vestingId
        ];

        return _computeReleasableAmount(vestingStructure);
    }

    /**
     * @dev Returns the amount of tokens that can be withdrawn by the owner.
     * @return the amount of tokens.
     */
    function getWithdrawableAmount() internal view returns (uint256) {
        return token.balanceOf(address(this)).sub(VestingTotalAmount);
    }

    /**
     * @dev Computes the releasable amount of tokens for a vesting schedule.
     * @param vestingStructure vesting information of a specific beneficiary.
     * @return the amount of releasable tokens.
     */
    function _computeReleasableAmount(VestingStructure memory vestingStructure)
        internal
        view
        returns (uint256)
    {
        require(
            getCurrentTime() > vestingCliff,
            "TokenVesting: cliff period isn't over!"
        );
        require(
            vestingStructure.revoked != true,
            "TokenVesting: vesting schedule has already been revoked!"
        );

        if (getCurrentTime() >= vestingStart.add(vestingDuration)) {
            return vestingStructure.amountTotal.sub(vestingStructure.released);
        } else {
            uint256 timeFromStart = getCurrentTime().sub(vestingStart);
            uint256 secondsPerSlice = vestingSlicePeriod;
            uint256 vestedSlicePeriods = timeFromStart.div(secondsPerSlice);
            uint256 vestedSeconds = vestedSlicePeriods.mul(secondsPerSlice);
            return
                vestingStructure
                    .amountTotal
                    .mul(vestedSeconds)
                    .div(vestingDuration)
                    .sub(vestingStructure.released);
        }
    }

    function getCurrentTime() internal view virtual returns (uint256) {
        return block.timestamp;
    }
}
