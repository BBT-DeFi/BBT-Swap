pragma solidity 0.6.12;
interface IAdminAsset {
    function isSuperAdmin(address _addr, string calldata _token) external view returns (bool);
}
interface IKYC {
    function kycsLevel(address _addr) external view returns (uint256);
}
interface IKAP20 {
    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
    
    function totalSupply() external view returns (uint256);
    function balanceOf(address tokenOwner) external view returns (uint256 balance);
    function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
    function transfer(address to, uint256 tokens) external returns (bool success);
    function approve(address spender, uint256 tokens) external returns (bool success);
    function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
    
    function getOwner() external view returns (address);
    
    function batchTransfer(address[] calldata _from, address[] calldata _to, uint256[] calldata _value) external returns (bool success);
    
    function adminTransfer(address _from, address _to, uint256 _value) external returns (bool success);
}
// BBT DeFi Test with Governance.
contract BBDT is IKAP20 {
    string public name     = "BBT DeFi Test";
    string public symbol   = "BBDT";
    uint8  public decimals = 18;
    
    uint256 private _totalSupply;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed tokenOwner, address indexed spender, uint256 value);
    event Deposit(address indexed dst, uint256 value);
    event Withdrawal(address indexed src, uint256 value);
    event Paused(address account);
    event Unpaused(address account);
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    mapping (address => bool) public blacklist;
    
    IAdminAsset public admin;
    IKYC public kyc;
    bool public paused;
    
    uint256 public kycsLevel;
    
    modifier onlySuperAdmin() {
        require(admin.isSuperAdmin(msg.sender, symbol), "Restricted only super admin");
        _;
    }
    
    modifier whenNotPaused() {
        require(!paused, "Pausable: paused");
        _;
    }
    modifier whenPaused() {
        require(paused, "Pausable: not paused");
        _;
    }
    
    constructor(address _admin, address _kyc) public {
        admin = IAdminAsset(_admin);
        kyc = IKYC(_kyc);
        kycsLevel = 1;
    }
    function setKYC(address _kyc) external onlySuperAdmin {
        kyc = IKYC(_kyc);
    }
    
    function setKYCsLevel(uint256 _kycsLevel) external onlySuperAdmin {
        require(_kycsLevel > 0);
        kycsLevel = _kycsLevel;
    }
    
    function getOwner() external view override returns (address) {
        return address(admin);
    }
    
    fallback() external payable {
        deposit();
    }
    
    receive() external payable {
        deposit();
    }
    
    function deposit() public whenNotPaused payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
        emit Transfer(address(0), msg.sender, msg.value);
    }
    
    function withdraw(uint256 _value) public whenNotPaused  {
        require(!blacklist[msg.sender], "Address is in the blacklist");
        _withdraw(_value, msg.sender);
    }
    
    function withdrawAdmin(uint256 _value, address _addr) public onlySuperAdmin {
        _withdraw(_value, _addr);
    }
    
    function _withdraw(uint256 _value, address _addr) internal {
        require(balances[_addr] >= _value);
        require(kyc.kycsLevel(_addr) > kycsLevel, "only kyc address registered with phone number can withdraw");
        
        balances[_addr] -= _value;
        payable(_addr).transfer(_value);
        emit Withdrawal(_addr, _value);
        emit Transfer(_addr, address(0), _value);
    }
    
    function totalSupply() public view override returns (uint256) {
        return address(this).balance;
    }
    function balanceOf(address _addr) public view override returns (uint256) {
        return balances[_addr];
    }
    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return allowed[_owner][_spender];
    }
    function approve(address _spender, uint256 _value) public override whenNotPaused returns (bool) {
        require(!blacklist[msg.sender], "Address is in the blacklist");
        _approve(msg.sender, _spender, _value);
        return true;
    }
    
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "KAP20: approve from the zero address");
        require(spender != address(0), "KAP20: approve to the zero address");
    
        allowed[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function transfer(address _to, uint256 _value) public override whenNotPaused returns (bool) {
        require(_value <= balances[msg.sender], "Insufficient Balance");
        require(blacklist[msg.sender] == false && blacklist[_to] == false, "Address is in the blacklist");
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
     function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override whenNotPaused returns (bool) {
        require(_value <= balances[_from]);
        require(_value <= allowed[_from][msg.sender]);
        require(blacklist[_from] == false && blacklist[_to] == false, "Address is in the blacklist");
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function batchTransfer(
        address[] calldata _from,
        address[] calldata _to,
        uint256[] calldata _value
    ) external override onlySuperAdmin returns (bool) {
        require(_from.length == _to.length && _to.length == _value.length, "Need all input in same length");
        for (uint256 i = 0; i < _from.length; i++) {
            if(blacklist[_from[i]] == true || blacklist[_to[i]] == true){
                  continue;
            }
            
            if (balances[_from[i]] >= _value[i]) {
                balances[_from[i]] -= _value[i];
                balances[_to[i]] += _value[i];
                emit Transfer(_from[i], _to[i], _value[i]);
            }
        }
        return true;
    }
    function adminTransfer(
        address _from,
        address _to,
        uint256 _value
    ) external override onlySuperAdmin returns (bool) {
        require(balances[_from] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function pause() external onlySuperAdmin whenNotPaused {
        paused = true;
        emit Paused(msg.sender);
    }
    function unpause() external onlySuperAdmin whenPaused {
        paused = false;
        emit Unpaused(msg.sender);
    }
    
    function addBlacklist(address _addr) external onlySuperAdmin {
        blacklist[_addr] = true;
    }
    
    function revokeBlacklist(address _addr) external onlySuperAdmin {
        blacklist[_addr] = false;
    }
    //fork part(PancakeSwap)
    /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
    function mint(address _to, uint256 _amount) public onlySuperAdmin {
        _mint(_to, _amount);
        _moveDelegates(address(0), _delegates[_to], _amount);
    }
    
    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: mint to the zero address');
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), 'BEP20: burn from the zero address');
        _balances[account] = _balances[account].sub(amount, 'BEP20: burn amount exceeds balance');
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    
    // Copied and modified from YAM code:
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
    // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
    // Which is copied and modified from COMPOUND:
    // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
    /// @notice A record of each accounts delegate
    mapping (address => address) internal _delegates;
    /// @notice A checkpoint for marking number of votes from a given block
    struct Checkpoint {
        uint32 fromBlock;
        uint256 votes;
    }
    /// @notice A record of votes checkpoints for each account, by index
    mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
    /// @notice The number of checkpoints for each account
    mapping (address => uint32) public numCheckpoints;
    /// @notice The EIP-712 typehash for the contract's domain
    bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
    /// @notice The EIP-712 typehash for the delegation struct used by the contract
    bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
    /// @notice A record of states for signing / validating signatures
    mapping (address => uint) public nonces;
      /// @notice An event thats emitted when an account changes its delegate
    event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
    /// @notice An event thats emitted when a delegate account's vote balance changes
    event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
    /**
     * @notice Delegate votes from `msg.sender` to `delegatee`
     * @param delegator The address to get delegatee for
     */
    function delegates(address delegator)
        external
        view
        returns (address)
    {
        return _delegates[delegator];
    }
   /**
    * @notice Delegate votes from `msg.sender` to `delegatee`
    * @param delegatee The address to delegate votes to
    */
    function delegate(address delegatee) external {
        return _delegate(msg.sender, delegatee);
    }
    /**
     * @notice Delegates votes from signatory to `delegatee`
     * @param delegatee The address to delegate votes to
     * @param nonce The contract state required to match the signature
     * @param expiry The time at which to expire the signature
     * @param v The recovery byte of the signature
     * @param r Half of the ECDSA signature pair
     * @param s Half of the ECDSA signature pair
     */
    function delegateBySig(
        address delegatee,
        uint nonce,
        uint expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
        external
    {
        bytes32 domainSeparator = keccak256(
            abi.encode(
                DOMAIN_TYPEHASH,
                keccak256(bytes(name())),
                getChainId(),
                address(this)
            )
        );
        bytes32 structHash = keccak256(
            abi.encode(
                DELEGATION_TYPEHASH,
                delegatee,
                nonce,
                expiry
            )
        );
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                domainSeparator,
                structHash
            )
        );
        address signatory = ecrecover(digest, v, r, s);
        require(signatory != address(0), "BBDT::delegateBySig: invalid signature");
        require(nonce == nonces[signatory]++, "BBDT::delegateBySig: invalid nonce");
        require(now <= expiry, "BBDT::delegateBySig: signature expired");
        return _delegate(signatory, delegatee);
    }
    /**
     * @notice Gets the current votes balance for `account`
     * @param account The address to get votes balance
     * @return The number of current votes for `account`
     */
    function getCurrentVotes(address account)
        external
        view
        returns (uint256)
    {
        uint32 nCheckpoints = numCheckpoints[account];
        return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
    }
    /**
     * @notice Determine the prior number of votes for an account as of a block number
     * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
     * @param account The address of the account to check
     * @param blockNumber The block number to get the vote balance at
     * @return The number of votes the account had as of the given block
     */
    function getPriorVotes(address account, uint blockNumber)
        external
        view
        returns (uint256)
    {
        require(blockNumber < block.number, "BBDT::getPriorVotes: not yet determined");
        uint32 nCheckpoints = numCheckpoints[account];
        if (nCheckpoints == 0) {
            return 0;
        }
        // First check most recent balance
        if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
            return checkpoints[account][nCheckpoints - 1].votes;
        }
        // Next check implicit zero balance
        if (checkpoints[account][0].fromBlock > blockNumber) {
            return 0;
        }
        uint32 lower = 0;
        uint32 upper = nCheckpoints - 1;
        while (upper > lower) {
            uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
            Checkpoint memory cp = checkpoints[account][center];
            if (cp.fromBlock == blockNumber) {
                return cp.votes;
            } else if (cp.fromBlock < blockNumber) {
                lower = center;
            } else {
                upper = center - 1;
            }
        }
        return checkpoints[account][lower].votes;
    }
    function _delegate(address delegator, address delegatee)
        internal
    {
        address currentDelegate = _delegates[delegator];
        uint256 delegatorBalance = balanceOf(delegator); // balance of underlying CAKEs (not scaled);
        _delegates[delegator] = delegatee;
        emit DelegateChanged(delegator, currentDelegate, delegatee);
        _moveDelegates(currentDelegate, delegatee, delegatorBalance);
    }
    function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
        if (srcRep != dstRep && amount > 0) {
            if (srcRep != address(0)) {
                // decrease old representative
                uint32 srcRepNum = numCheckpoints[srcRep];
                uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
                uint256 srcRepNew = srcRepOld.sub(amount);
                _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
            }
            if (dstRep != address(0)) {
                // increase new representative
                uint32 dstRepNum = numCheckpoints[dstRep];
                uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
                uint256 dstRepNew = dstRepOld.add(amount);
                _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
            }
        }
    }
    function _writeCheckpoint(
        address delegatee,
        uint32 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    )
        internal
    {
        uint32 blockNumber = safe32(block.number, "BBDT::_writeCheckpoint: block number exceeds 32 bits");
        if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
            checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
        } else {
            checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
            numCheckpoints[delegatee] = nCheckpoints + 1;
        }
        emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
    }
    function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
        require(n < 2**32, errorMessage);
        return uint32(n);
    }
    function getChainId() internal pure returns (uint) {
        uint256 chainId;
        assembly { chainId := chainid() }
        return chainId;
    }
}