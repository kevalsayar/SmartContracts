module IDO::ido_contract{
    use sui::object::{Self, UID};
    use sui::object_table::{Self, ObjectTable};
    use sui::coin::{Self, Coin};
    use sui::balance::{Self, Balance};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::clock::{Self, Clock};

    // Errors
      
    // For when the IDO begins in the future.
    const EIdoFuture: u64 = 0;
    // For when the IDO times are non-sequential.
    const ESeqTimes: u64 = 1;
    // For when the IDO has not started.
    const EStartIdoTime: u64 = 2;
    // For when the Deposits period has ended.
    const EEndDepositsTime: u64 = 3;
    // For when the IDO has not finished yet.
    const EIdoNotOver : u64 = 4;
    // For when supplied Coin is zero.
    const EZeroAmount: u64 = 5;
    // For when the Pool's already initialized.
    const EPoolInitialized: u64 = 6;
    // For when the Pool's not initialized.
    const EPoolNotInitialized: u64 = 7;
    // For when the Pool's USDC is at it's maximum capacity.
    const EPoolUSDCMaxCapReached: u64 = 8;
    // For when the Pool's IDO Token is at it's maximum capacity.
    const EPoolIDOTokenMaxCapReached: u64 = 9;
    /// For when there's nothing to withdraw.
    const ENoProfits: u64 = 10;
    /// For when no USDC investment is found for a wallet address.
    const ENoUSDCInvestment: u64 = 11;
    /// For when IDO tokens are already claimed.
    const EIdoTokensClaimed: u64 = 12;
    /// For when a USDC investment is found for a wallet address.
    const EUSDCInvestment: u64 = 13;

    // 1000000000 MIST = 1 SUI

    /// Capability that grants only the Pool Owner access to specific functionalities.
    struct PoolOwnerCap has key { id: UID }

    // Object which contains an id (Globally Unique) & a boolean constant which indicates if the pool's been initialized.
    struct PoolInitialized has key {
        id: UID,
        pool_init: bool
    }

    // Object which contains an id (Globally Unique) and various constants pertaining to the Pool Account in question.
    struct PoolConstants has key {
        id: UID,
        usdc_cap: u64,
        idoToken_cap: u64,
        start_ido_ts: u64,
        end_deposits_ts: u64,
        end_ido_ts: u64
    }

    // Object which contains an id (Globally Unique) and various other fields pertaining to the Pool Account in question.
    struct Pool<phantom IDOTOKEN, phantom USDC> has key {
        id: UID, 
        investorInfos: ObjectTable<address, InvestedUSDCAmount>,
        usdcBalanceStruct: Balance<USDC>,
        idoTokenUnallocatedBalanceStruct: Balance<IDOTOKEN>,
        idoTokenAllocatedBalanceStruct: Balance<IDOTOKEN>
    }

    struct InvestedUSDCAmount has key, store {
        id: UID,
        usdcInvestmentAmount: u64,
        idoTokensClaimed: bool   
    }

    struct UserInvestedUSDCAmt has key, store {
        id: UID,
        usdcInvestmentAmount: u64
    }

    /// Special function that gets executed only once - when the associated module is published.
    /// Initializing a PoolOwnerCap object and transferring it to the transaction's sender.
    /// Initializing a PoolInitialized object and transferring it to the transaction's sender.
    fun init(ctx: &mut TxContext) {
        // Transfer ownership of obj to recipient. obj must have the 'key' attribute, which ensures it has a globally unique ID and PoolOwnerCap should be an object defined in the module where transfer is invoked.
        // Use public_transfer to transfer an object with 'store' outside of its module.
        transfer::transfer(PoolOwnerCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));

        // Turns the given object into a mutable shared object that everyone can access and mutate and is irreversible.
        // PoolInitialized should be an object defined in the module where share_object is invoked. 
        // Use public_share_object to share an object with 'store' outside of its module.
        transfer::share_object(PoolInitialized {
            id: object::new(ctx),
            pool_init: false,
        });
    }

    /// Requires authorization with `PoolOwnerCap`.
    entry fun initialize_pool<IDOTOKEN, USDC>(_: &PoolOwnerCap, poolinitialized: &mut PoolInitialized, inputIdoToken: Coin<IDOTOKEN>, usdc_cap: u64, idoToken_cap: u64, start_ido_ts: u64, end_deposits_ts: u64, end_ido_ts: u64, clock: &Clock, ctx: &mut TxContext){
        // Constraints:
        // 1. Can be executed only by the Pool Owner.
        // 2. An IDO cannot be initialized twice.
        // 3. An IDO cannot be initialised on the past date.
        // 4. IDO Start timestamp should be less than deposits end timestamp.
        // 5. Deposits end timestamp should be less than end IDO timestamp.
        assert!(poolinitialized.pool_init == false, EPoolInitialized);
        assert!(start_ido_ts > clock::timestamp_ms(clock) && end_deposits_ts > clock::timestamp_ms(clock) && end_ido_ts > clock::timestamp_ms(clock), EIdoFuture);
        assert!(start_ido_ts < end_deposits_ts && end_deposits_ts < end_ido_ts, ESeqTimes);

        assert!(coin::value(&inputIdoToken) == idoToken_cap, EPoolIDOTokenMaxCapReached);
        
        transfer::share_object(Pool {
            /// Create a new object. Returns the `UID` that must be stored in a Sui object.
            id: object::new(ctx),
            // Creates a new, empty table.
            investorInfos: object_table::new(ctx),
            // Initializing a zero Balance for type USDC.
            usdcBalanceStruct: balance::zero<USDC>(),
            // 'coin::into_balance' destructs a Coin wrapper and keeps the balance.
            idoTokenUnallocatedBalanceStruct: coin::into_balance(inputIdoToken),
            // Initializing a zero Balance for type IDOTOKEN.
            idoTokenAllocatedBalanceStruct: balance::zero<IDOTOKEN>()
        });

        // After freezing 'obj' becomes immutable and can no longer be transferred or mutated & object SHOULD BE defined in the module where freeze_object is invoked. 
        transfer::freeze_object(PoolConstants {
            id: object::new(ctx),
            usdc_cap: usdc_cap,
            idoToken_cap: idoToken_cap,
            start_ido_ts: start_ido_ts,
            end_deposits_ts: end_deposits_ts,
            end_ido_ts: end_ido_ts
        });
        
        poolinitialized.pool_init = true;
    }

    entry fun deposit_USDC<IDOTOKEN, USDC>(poolinitialized: &mut PoolInitialized, pool: &mut Pool<IDOTOKEN, USDC>, poolConstants: &PoolConstants,  clock: &Clock, inputUsdc: Coin<USDC>,  ctx: &mut TxContext) {
        // Constraints:
        // 1. Can be executed only after the pool's initialized.
        // 2. Can be executed only after the start timestamp
        // 3. Cannot be executed once pool cap's breached OR once at the end timestamp.
        assert!(poolinitialized.pool_init == true, EPoolNotInitialized);
        assert!(clock::timestamp_ms(clock) > poolConstants.start_ido_ts, EStartIdoTime);
        assert!(clock::timestamp_ms(clock) < poolConstants.end_deposits_ts, EEndDepositsTime);
        assert!(!object_table::contains(&pool.investorInfos, tx_context::sender(ctx)), EUSDCInvestment);

        let inputUsdcValue = coin::value(&inputUsdc);

        assert!(inputUsdcValue > 0, EZeroAmount);

        let (currUsdcValue, _, _) = get_amounts<IDOTOKEN, USDC>(pool);
        
        assert!(currUsdcValue + inputUsdcValue <= poolConstants.usdc_cap, EPoolUSDCMaxCapReached);

        balance::join(&mut pool.usdcBalanceStruct, coin::into_balance(inputUsdc));

        balance::join(&mut pool.idoTokenAllocatedBalanceStruct, coin::into_balance(coin::take(&mut pool.idoTokenUnallocatedBalanceStruct, inputUsdcValue * 10, ctx)));

        object_table::add(&mut pool.investorInfos, tx_context::sender(ctx), InvestedUSDCAmount {
            id: object::new(ctx),
            usdcInvestmentAmount: inputUsdcValue,
            idoTokensClaimed: false
        });

        transfer::public_transfer(UserInvestedUSDCAmt {
            id: object::new(ctx),
            usdcInvestmentAmount: inputUsdcValue
        }, tx_context::sender(ctx));
        
        //if (object_table::contains(&pool.investorInfos, tx_context::sender(ctx))) {
        //    let a = object_table::borrow_mut(&mut pool.investorInfos, tx_context::sender(ctx));
        //   a.usdcInvestmentAmount = a.usdcInvestmentAmount + inputUsdcValue;
        //} else {
        //   object_table::add(&mut pool.investorInfos, tx_context::sender(ctx), InvestedUSDCAmount {
        //        id: object::new(ctx),
        //        usdcInvestmentAmount: inputUsdcValue,
        //       idoTokensClaimed: false
        //    });
        
    }
   
    entry fun claim_ido_token<IDOTOKEN, USDC> (poolinitialized: &mut PoolInitialized, pool: &mut Pool<IDOTOKEN, USDC>, poolConstants: &PoolConstants, clock: &Clock, ctx: &mut TxContext) {
        // Constraints:
        // 1. Can be executed only after the pool's initialized.
        // 2. Can be executed only after the end IDO timestamp.
        // 3. Can be executed only if the wallet address is an active investor.
        assert!(poolinitialized.pool_init == true, EPoolNotInitialized);
        assert!(clock::timestamp_ms(clock) >= poolConstants.end_ido_ts, EIdoNotOver);
        assert!(object_table::contains(&pool.investorInfos, tx_context::sender(ctx)), ENoUSDCInvestment);

        let a = object_table::borrow_mut(&mut pool.investorInfos, tx_context::sender(ctx));

        assert!(a.idoTokensClaimed == false, EIdoTokensClaimed);

        transfer::public_transfer(coin::take(&mut pool.idoTokenAllocatedBalanceStruct, a.usdcInvestmentAmount * 10, ctx), tx_context::sender(ctx));

        a.idoTokensClaimed = true;
    }

    /// Requires authorization with `PoolOwnerCap`.
    entry fun withdraw_pool_usdc<IDOTOKEN, USDC> (_: &PoolOwnerCap, poolinitialized: &PoolInitialized, pool: &mut Pool<IDOTOKEN, USDC>, poolConstants: &PoolConstants, clock: &Clock, ctx: &mut TxContext) {
        // Constraints:
        // 1. Can be executed only by the Pool Owner.
        // 2. Can be executed only after the pool's initialized.
        // 3. Can be executed only after the end IDO timestamp.
        assert!(poolinitialized.pool_init == true, EPoolNotInitialized);
        assert!(clock::timestamp_ms(clock) >= poolConstants.end_ido_ts, EIdoNotOver);

        let (usdcAmount, _, _) = get_amounts<IDOTOKEN, USDC>(pool);

        assert!(usdcAmount > 0, ENoProfits);

        transfer::public_transfer(coin::take(&mut pool.usdcBalanceStruct, usdcAmount, ctx), tx_context::sender(ctx));
    }

    /// Requires authorization with `PoolOwnerCap`.
    entry fun withdraw_pool_ido_tokens<IDOTOKEN, USDC> (_: &PoolOwnerCap, poolinitialized: &PoolInitialized, pool: &mut Pool<IDOTOKEN, USDC>, poolConstants: &PoolConstants, clock: &Clock, ctx: &mut TxContext) {
        // Constraints:
        // 1. Can be executed only by the Pool Owner.
        // 2. Can be executed only after the pool's initialized.
        // 3. Can be executed only after the end IDO timestamp.
        assert!(poolinitialized.pool_init == true, EPoolNotInitialized);
        assert!(clock::timestamp_ms(clock) >= poolConstants.end_ido_ts, EIdoNotOver);

        let (_, unallocatedIdoTokenAmount, _) = get_amounts<IDOTOKEN, USDC>(pool);

        assert!(unallocatedIdoTokenAmount > 0, ENoProfits);

        transfer::public_transfer(coin::take(&mut pool.idoTokenUnallocatedBalanceStruct, unallocatedIdoTokenAmount, ctx), tx_context::sender(ctx));
    }

    /// Generic function to get the amount stored in a Balance.
    /// - amount of USDC.
    /// - amount of Unallocated IDOToken.
    /// - amount of Allocated IDOToken.
    public fun get_amounts<IDOTOKEN, USDC>(pool: &Pool<IDOTOKEN, USDC>): (u64, u64, u64) {
        (
            balance::value(&pool.usdcBalanceStruct),
            balance::value(&pool.idoTokenUnallocatedBalanceStruct),
            balance::value(&pool.idoTokenAllocatedBalanceStruct)
        )
    }
}