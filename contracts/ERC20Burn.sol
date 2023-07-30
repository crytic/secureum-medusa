pragma solidity 0.8.19;
import "./ERC20.sol";

// ERC20 token with a burn function
contract ERC20Burn is ERC20("MyToken", "MT", 18) {

    constructor(){
        _mint(msg.sender, 10**18);
    }

    function burn(uint amount) public{
        _burn(msg.sender, amount);
    }

}