// Sources flattened with hardhat v2.2.0 https://hardhat.org

// File contracts/interfaces/IAdmin.sol
//Arg [0] (address) : 0x2c8abd9c61d4e973ca8db5545c54c90e44a2445c admin.sol
//
pragma solidity 0.6.6;

interface IAdmin {
    function isSuperAdmin(address _addr) external view returns (bool);

    function isAdmin(address _addr) external view returns (bool);
}


// File contracts/KYCBitkubChain.sol

pragma solidity 0.6.6;

contract KYCBitkubChain {
    IAdmin public admin;
    enum KYC_LEVEL {NULL_LEVEL, NO_KYC, LEVEL0, LEVEL1, LEVEL2, LEVEL3, LEVEL4, LEVEL5}

    mapping(address => uint256) public kycsLevel;

    event KycCompleted(address indexed addr, address indexed caller, KYC_LEVEL level);
    event KycRevoked(address indexed addr, address indexed caller, KYC_LEVEL level);

    modifier onlyAdmin() {
        require(
            admin.isSuperAdmin(msg.sender) || admin.isAdmin(msg.sender),
            "Restrict only address is admin smart contract"
        );
        _;
    }

    constructor(address _admin) public {
        admin = IAdmin(_admin);
    }

    function setAdmin(address _admin) external {
        require(admin.isSuperAdmin(msg.sender) == true, "Only Super Admin Can change");

        admin = IAdmin(_admin);
    }

    function setKycCompleted(address _addr, uint256 _level) public onlyAdmin {
        if (_level > 1) {
            kycsLevel[_addr] = _level;
            emit KycCompleted(_addr, msg.sender, KYC_LEVEL(_level));
        }
    }

    function batchSetKycCompleted(address[] calldata _addrs, uint256 level) external onlyAdmin {
        require(level > uint256(KYC_LEVEL.NO_KYC), "KEY LEVEL ERROR");
        for (uint256 i = 0; i < _addrs.length; i++) {
            setKycCompleted(_addrs[i], level);
        }
    }

    // No kyc level set to no kyc
    function setKycRevoked(address _addr) public onlyAdmin {
        kycsLevel[_addr] = uint256(KYC_LEVEL.NO_KYC);
        emit KycRevoked(_addr, msg.sender, KYC_LEVEL.NO_KYC);
    }

    function batchSetKycRevoked(address[] calldata _addrs) external onlyAdmin {
        for (uint256 i = 0; i < _addrs.length; i++) {
            setKycRevoked(_addrs[i]);
        }
    }

    function batchSetInitKYC(address[] calldata _addrs) external onlyAdmin {
        for (uint256 i = 0; i < _addrs.length; i++) {
            if (kycsLevel[_addrs[i]] == uint256(KYC_LEVEL.NULL_LEVEL)) kycsLevel[_addrs[i]] = uint256(KYC_LEVEL.NO_KYC);
        }
    }
}