pragma solidity 0.8.19;
import {SignedWadMath} from "./SignedWadMath.sol";
import "./helper.sol";

// Run with medusa fuzz --target contracts/SignedWadMathTest.sol --deployment-order SignedWadMathTest

contract SignedWadMathTest is PropertiesAsserts{

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

    function testunsafeWadMul(uint256 x, uint256 y, int256 divSeed) public {
        x = clampLte(x, 10**18);
        x = clampGt(x, 0);
        y = clampLte(y, 10**18);
        y = clampGt(y, 0);
        divSeed = clampLte(divSeed, int(x));
        divSeed = clampLte(divSeed, int(y));

        int x2 = SignedWadMath.toWadUnsafe(x) / divSeed;
        int y2 = SignedWadMath.toWadUnsafe(y) / divSeed;

        int256 z = SignedWadMath.unsafeWadMul(x2, y2);

        // Ensure that z >= x * y / divSeed
        assertGte(z, int(x * y) / divSeed, "Z should be greater or equal to X * Y / divSeed");
    }

    function testunsafeWadDiv(int256 x, int256 y) public {
        x = clampLte(x, 10**18);
        x = clampGt(x, 0);
        y = clampLte(y, 10**18);
        y = clampGt(y, 0);
        x = clampGte(x, y);

        int256 z = SignedWadMath.unsafeWadDiv(x, y);

        // Ensure that z / 10**18 >= x / y
        assertGte(z / 10**18, x / y, "Z should be greater or equal to X / Y");
    }

    function testwadMul(uint256 x, uint256 y, int256 divSeed) public {
        x = clampLte(x, 10**18);
        x = clampGt(x, 0);
        y = clampLte(y, 10**18);
        y = clampGt(y, 0);
        divSeed = clampLte(divSeed, int(x));
        divSeed = clampLte(divSeed, int(y));

        int x2 = SignedWadMath.toWadUnsafe(x) / divSeed;
        int y2 = SignedWadMath.toWadUnsafe(y) / divSeed;

        int256 z = SignedWadMath.wadMul(x2, y2);

        // Ensure that z >= x * y / divSeed
        assertGte(z, int(x * y) / divSeed, "Z should be greater or equal to X * Y / divSeed");
    }

    function testwadDiv(int256 x, int256 y) public {
        x = clampLte(x, 10**18);
        x = clampGt(x, 0);
        y = clampLte(y, 10**18);
        y = clampGt(y, 0);
        x = clampGte(x, y);

        int256 z = SignedWadMath.wadDiv(x, y);

        // Ensure that z / 10**18 >= x / y
        assertGte(z / 10**18, x / y, "Z should be greater or equal to X / Y");
    }

    function testwadPow(uint256 x, uint256 y) public {
        // Will not work with negative bases, only use when x is positive.
        x = clampLte(x, 10);
        x = clampGt(x, 0);
        y = clampLte(y, 17);
        y = clampGt(y, 0);

        int256 z = SignedWadMath.wadPow(int(x), int(y));

        // Ensure that z / 10**18 >= x ** y
        assertGte(uint(z), x ** y, "Z should be greater or equal to X ** Y");
    }

}