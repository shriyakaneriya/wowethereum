pragma solidity ^0.4.2;

import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "openzeppelin-solidity/contracts/lifecycle/Destructible.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";

/** @title WoW */

contract WoW is StandardToken, Destructible, Pausable {

    string public constant NAME = "WoW";
    string public constant SYMBOL = "WoW";
    uint8 public constant  DECIMALS = 0;
    uint256 public constant INITIAL_SUPPLY = 18446744073709551616;
    address public owner;

    constructor() public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        owner = msg.sender;
    }

    // transfer that sends using the contract owner
    // note onlyOwner is inherited from StandardToken
    function godTransfer(
        address _from,
        address[] _to,
        uint256[] _amounts
    ) public onlyOwner returns (bool)
    {
        require(_to.length == _amounts.length, "all recipients must have a defined amount");

        uint256 totalAmount = 0;
        for (uint256 i = 0; i < _amounts.length; i++) {
            totalAmount = totalAmount.add(_amounts[i]);
            require(_to[i] != address(0), "to address cannot be empty address");
        }
        require(totalAmount <= balances[_from], "insufficient funds");

        for (i = 0; i < _amounts.length; i++) {
            uint256 value = _amounts[i];
            balances[_from] = balances[_from].sub(value);
            balances[_to[i]] = balances[_to[i]].add(value);
            emit Transfer(_from, _to[i], value);
        }
        return true;
    }

}
