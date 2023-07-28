import "./SignedWadMath.sol";
import "./helper.sol";

// Run with medusa fuzz --target contracts/SignedWadMathTest.sol --deployment-order SignedWadMathTest

contract SignedWadMathTest is PropertiesAsserts{

    // The following is an example of invariant
    // It test that if x < 10**18
    // Then x <= uint(toWadUnsafe(x))
    function testtoWadUnsafe(uint256 x) public{

        x = clampLte(x, 10**18);

        int256 y = toWadUnsafe(x);

        // Ensure that x <= uint(y)
        assertLte(x, uint(y), "X should be less or equal to Y");
    }

}