pragma solidity 0.8.19;
import {SignedWadMath} from "./SignedWadMath.sol";
import "./helper.sol";

// Run with medusa fuzz --target contracts/SignedWadMathTest.sol --deployment-order SignedWadMathTest

contract SWM is PropertiesAsserts{

    // The following is an example of invariant
    // It test that if x < 10**18
    // Then x <= uint(toWadUnsafe(x))
    function testtoWadUnsafe(uint256 x) public {

        x = clampLte(x, 10**18);

        int256 y = SignedWadMath.toWadUnsafe(x);

        // Ensure that x <= uint(y)
        assertLte(x, uint(y), "X should be less or equal to Y");
    }

    function testtoDaysWadUnsafe(uint256 x) public {
            
        x = clampLte(x, 10**18);
        // ignore zero so there is at least one day
        x = clampGt(x, 0);

        int256 y = SignedWadMath.toDaysWadUnsafe(x);

        int256 z = SignedWadMath.toWadUnsafe(x);

        // Ensure that y >= 86400 * z
        assertGte(z, 86400 * y, "Z should be greater or equal to 86400 * Y");
    }

    function testfromDaysWadUnsafe(uint256 x) public {
        x = clampLte(x, 10**18);
        // ignore zero so there is at least one day
        x = clampGt(x, 0);

        int256 y = SignedWadMath.toDaysWadUnsafe(x);

        uint256 z = uint256(SignedWadMath.fromDaysWadUnsafe(y));

        // Ensure that x == z || x == z + 1
        assertGte(x, z, "X should be greater or equal to Z");
        assertLte(x, z + 1, "X should be less or equal to Z + 1");
    }

}