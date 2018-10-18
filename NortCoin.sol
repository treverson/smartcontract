/* 
 source code generate by Bui Dinh Ngoc aka ngocbd<buidinhngoc.aiti@gmail.com> for smartcontract NortCoin at 0xCa12bc7Cc906e962AD7CBBB195fddfd18B9959eb
*/
pragma solidity ^0.4.24;

contract NortCoin {
  address public owner;
  string public name;
  string public symbol;
  uint public decimals;
  uint256 public totalSupply;

  event Transfer(address indexed from, address indexed to, uint256 value);

  /* This creates an array with all balances */
  mapping (address => uint256) public balanceOf;

  constructor(uint256 initialSupply, string tokenName, string tokenSymbol, uint decimalUnits) public {
    owner = msg.sender;
    name = tokenName;
    symbol = tokenSymbol;
    decimals = decimalUnits;
    totalSupply = initialSupply * 8 ** uint256(decimals);
    balanceOf[msg.sender] = totalSupply;
  }

  /* Send coins */
  function transfer(address _to, uint256 _value) public {
    /* Check if the sender has balance and for overflows */
    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);

    /* Add and subtract new balances */
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;

    /* Notify anyone listening that this transfer took place */
    emit Transfer(msg.sender, _to, _value);
  }
}