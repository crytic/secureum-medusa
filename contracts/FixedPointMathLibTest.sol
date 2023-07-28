import {FixedPointMathLib} from "./FixedPointMathLib.sol";
import "./helper.sol";

// Run with medusa fuzz --target contracts/FixedPointMathLibTest.sol --deployment-order FixedPointMathLibTest


contract FixedPointMathLibTest is PropertiesAsserts{

    // The following is an example of invariant
    // It test that if z = x / y, then z <= x
    // For any x and y greater than 1 unit
    function testmulDivDown(uint256 x, uint256 y) public{

        // We work with a decimals of 18
        uint decimals = 10**18; 

        // Ensure x and y are geater than 1
        x = clampGte(x, decimals);
        y = clampGte(y, decimals);

        // compute z = x / y
        uint z = FixedPointMathLib.mulDivDown(x, y, decimals);

        // Ensure that z <= x
        assertLte(z, x, "Z should be less or equal to X");
    }

}