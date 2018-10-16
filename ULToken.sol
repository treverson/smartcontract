/* 
 source code generate by Bui Dinh Ngoc aka ngocbd<buidinhngoc.aiti@gmail.com> for smartcontract ULToken at 0x09617f6fd6cf8a71278ec86e23bbab29c04353a7
*/
pragma solidity ^0.4.13;

library SafeMath {
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a * b;
    assert(a == 0 || c / a == b);
    return c;
  }

  function div(uint256 a, uint256 b) internal constant returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  function sub(uint256 a, uint256 b) internal constant returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  function add(uint256 a, uint256 b) internal constant returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}

contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}

contract Pausable is Ownable {
  event Pause();
  event Unpause();

  bool public paused = false;


  /**
   * @dev Modifier to make a function callable only when the contract is not paused.
   */
  modifier whenNotPaused() {
    require(!paused);
    _;
  }

  /**
   * @dev Modifier to make a function callable only when the contract is paused.
   */
  modifier whenPaused() {
    require(paused);
    _;
  }

  /**
   * @dev called by the owner to pause, triggers stopped state
   */
  function pause() onlyOwner whenNotPaused public {
    paused = true;
    Pause();
  }

  /**
   * @dev called by the owner to unpause, returns to normal state
   */
  function unpause() onlyOwner whenPaused public {
    paused = false;
    Unpause();
  }
}

contract ERC20Basic {
  uint256 public totalSupply;
  function balanceOf(address who) public constant returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
}

contract BasicToken is ERC20Basic {
  using SafeMath for uint256;

  mapping(address => uint256) balances;

  /**
  * @dev transfer token for a specified address
  * @param _to The address to transfer to.
  * @param _value The amount to be transferred.
  */
  function transfer(address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));

    // SafeMath.sub will throw if there is not enough balance.
    balances[msg.sender] = balances[msg.sender].sub(_value);
    balances[_to] = balances[_to].add(_value);
    Transfer(msg.sender, _to, _value);
    return true;
  }

  /**
  * @dev Gets the balance of the specified address.
  * @param _owner The address to query the the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
  }

}

contract ERC20 is ERC20Basic {
  function allowance(address owner, address spender) public constant returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract StandardToken is ERC20, BasicToken {

  mapping (address => mapping (address => uint256)) allowed;


  /**
   * @dev Transfer tokens from one address to another
   * @param _from address The address which you want to send tokens from
   * @param _to address The address which you want to transfer to
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
    require(_to != address(0));

    uint256 _allowance = allowed[_from][msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);

    balances[_from] = balances[_from].sub(_value);
    balances[_to] = balances[_to].add(_value);
    allowed[_from][msg.sender] = _allowance.sub(_value);
    Transfer(_from, _to, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public returns (bool) {
    allowed[msg.sender][_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _owner address The address which owns the funds.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
    return allowed[_owner][_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval (address _spender, uint _addedValue)
    returns (bool success) {
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval (address _spender, uint _subtractedValue)
    returns (bool success) {
    uint oldValue = allowed[msg.sender][_spender];
    if (_subtractedValue > oldValue) {
      allowed[msg.sender][_spender] = 0;
    } else {
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

}

contract PausableToken is StandardToken, Pausable {

  function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}

contract ULToken is PausableToken {

    string public name;                             // fancy name: eg Simon Bucks

    uint8 public decimals;                          // How many decimals to show.

    string public symbol;                           // An identifier: eg SBX



    bool public ownerBurnOccurred;                   // Changes when ownerBurn is called

    uint256 public licenseCostNumerator;            // Numerator of the %(totalSupply) cost of a license

    uint256 public licenseCostDenominator;          // Denominator of the %(totalSupply) cost of a license

    uint256 public totalLicensePurchases;           // Total number of licenses purchased

    mapping (address => bool) public ownsLicense;   // Tracks addresses that have purchased a license



    /**

    * Modifier to make a function callable only after ownerBurn has been called

    */

    modifier afterOwnerBurn() {

        require(ownerBurnOccurred == true);

        _;

    }



    // This notifies clients when ownerBurn is called

    event LogOwnerBurn(address indexed owner, uint256 value);

    // This notifies clients when a license is purchased

    event LogPurchaseLicense(address indexed purchaser, uint256 indexed license_num, uint256 value, bytes32 indexed data);

    // This notifies clients when the %(totalSupply) cost of a license has changed

    event LogChangedLicenseCost(uint256 numerator, uint256 denominator);



    // Override Ownable.sol fn

    function transferOwnership(address newOwner) onlyOwner public {

        revert();

    }



    // Constructor

    function ULToken(

        uint256 _initialAmount,

        string _tokenName,

        uint8 _decimalUnits,

        string _tokenSymbol

    ) public {

        balances[msg.sender] = _initialAmount;      // Give the creator all initial tokens

        totalSupply = _initialAmount;               // Update total supply

        name = _tokenName;                          // Set the name for display purposes

        decimals = _decimalUnits;                   // Amount of decimals for display purposes

        symbol = _tokenSymbol;                      // Set the symbol for display purposes



        owner = msg.sender;                         // Save the contract creators address as the owner



        ownerBurnOccurred = false;                   // Ensure ownerBurn has not been called



        licenseCostNumerator = 0;                   // Initialize license cost to 0

        licenseCostDenominator = 1;

        totalLicensePurchases = 0;

    }



    /**

     * Burns all remaining tokens in the owners account and sets license cost

     * Can only be called once by contract owner

     *

     * @param _numerator Numerator of the %(totalSupply) cost of a license

     * @param _denominator Denominator of the %(totalSupply) cost of a license

     */

    function ownerBurn(

        uint256 _numerator,

        uint256 _denominator

    ) public

        whenNotPaused

        onlyOwner

    returns (bool) {

        // Ensure first time

        require(ownerBurnOccurred == false);

        // Set license cost

        changeLicenseCost(_numerator, _denominator);

        // Burn remaining owner tokens

        uint256 value = balances[msg.sender];

        balances[msg.sender] -= value;

        totalSupply -= value;

        ownerBurnOccurred = true;

        LogOwnerBurn(msg.sender, value);

        return true;

    }



    /**

     * Change the %(totalSupply) cost of a license

     * Can only be called by contract owner

     *

     * Sets licenseCostNumerator to _numerator

     * Sets licenseCostDenominator to _denominator

     *

     * @param _numerator Numerator of the %(totalSupply) cost of a license

     * @param _denominator Denominator of the %(totalSupply) cost of a license

     */

    function changeLicenseCost(

        uint256 _numerator,

        uint256 _denominator

    ) public

        whenNotPaused

        onlyOwner

    returns (bool) {

        require(_numerator >= 0);

        require(_denominator > 0);

        require(_numerator < _denominator);

        licenseCostNumerator = _numerator;

        licenseCostDenominator = _denominator;

        LogChangedLicenseCost(licenseCostNumerator, licenseCostDenominator);

        return true;

    }



    /**

     * Purchase a license

     * Can only be called once per account

     *

     * Burns a percentage of tokens from the callers account

     * Sets the callers address to true in the ownsLicense mapping

     *

     */

    function purchaseLicense(bytes32 _data) public

        whenNotPaused

        afterOwnerBurn

    returns (bool) {

        require(ownsLicense[msg.sender] == false);

        // Calculate cost of license

        uint256 costNumerator = totalSupply * licenseCostNumerator;

        uint256 cost = costNumerator / licenseCostDenominator;

        require(balances[msg.sender] >= cost);

        // Burn the tokens

        balances[msg.sender] -= cost;

        totalSupply -= cost;

        // Add msg.sender to license owners

        ownsLicense[msg.sender] = true;

        totalLicensePurchases += 1;

        LogPurchaseLicense(msg.sender, totalLicensePurchases, cost, _data);

        return true;

    }

}