pragma solidity 0.8.19;
import "./ERC20Burn.sol";
import "./helper.sol";


// Example using an external testing
// See https://secure-contracts.com/program-analysis/echidna/basic/common-testing-approaches.html#external-testing
// Run with medusa fuzz --target contracts/ERC20TestAdvanced.sol --deployment-order ExternalTestingToken

// User is used a proxy account to simulate user specific interaction
contract User{
    ERC20Burn token;
    constructor(ERC20Burn token_param) {
        token = token_param;
    }

    function approve(uint amount) public{
        token.approve(msg.sender, amount);
    }

    function transfer(address to, uint amount) public{
        token.transfer(to, amount);
    }

    // More wrapper functions can be added
}

contract ExternalTestingToken is PropertiesAsserts{

    ERC20Burn token;

    User alice;

    constructor() {
        // Deploy the token
        // All the token belong to the contract
        token = new ERC20Burn();

        assert(token.balanceOf(address(this)) == 10**18);

        alice = new User(token);

        // Transfer all the token to alice
        token.transfer(address(alice), 10**18);
        // Approve all the token from Alice to ExternalTestingToken
        alice.approve(10**18);

    }

    // The following test a transfer from
    // Medusa will transfer an arbitrary amount using transferFrom
    // The invariant ensure that the balance was updated by the amount transfered
    function testTransferFrom(uint amount) public{
        
        // Ensure amount is less or equal to alice's balanc
        amount = clampLte(amount, token.balanceOf(address(alice)));
        // Ensure amount is less or equal to alice's approval to this contract
        amount = clampLte(amount, token.allowance(address(alice), address(this)));

        uint balanceBefore = token.balanceOf(address(alice));

        token.transferFrom(address(alice), address(this), amount);

        uint balanceAfter = token.balanceOf(address(alice));

        assertEq(balanceAfter - balanceBefore, amount, "The amount transfered must be equal to the expected amount");

    }
}