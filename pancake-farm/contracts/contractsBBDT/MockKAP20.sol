pragma solidity 0.6.12;

// import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
import "./KAP20.sol";

contract MockKAP20 is KAP20 {
    constructor(
        string memory name,
        string memory symbol,
        uint256 supply
    ) public KAP20(name, symbol) {
        _mint(msg.sender, supply);

    }
}