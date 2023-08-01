pragma solidity 0.8.19;
import {SignedWadMath} from "./SignedWadMath.sol";
import "./helper.sol";

import "./IVM.sol";

// Run with medusa fuzz --target contracts/SignedWadMathTest.sol --deployment-order SignedWadMathTest

contract SignedWadMathTest is PropertiesAsserts{
    IVM vm = IVM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // The following is an example of invariant
    // It test that if x < 10**18
    // Then x <= uint(toWadUnsafe(x))
    function testtoWadUnsafe(uint256 x) public{
        x = clampLte(x, 10**18);

        int256 y = SignedWadMath.toWadUnsafe(x);

        // Ensure that x <= uint(y)
        assertLte(x, uint(y), "X should be less or equal to Y");
    }

}