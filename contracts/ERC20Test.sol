pragma solidity 0.8.19;
import "./ERC20Burn.sol";
import "./helper.sol";


// Run with medusa fuzz --target contracts/ERC20Test.sol --deployment-order MyToken

contract MyToken is ERC20Burn {

    // Test that the total supply is always below or equal to 10**18
    function fuzz_Supply() public returns(bool){
        return totalSupply <= 10**18;
    }
}

