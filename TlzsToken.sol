/* 
 source code generate by Bui Dinh Ngoc aka ngocbd<buidinhngoc.aiti@gmail.com> for smartcontract TlzsToken at 0xb3d031000f66e87400E8e4951Eb70c9ee7bb0823
*/
contract owned {
    address public owner;

    function owned() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        if (msg.sender != owner) throw;
        _;
    }

    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
}

contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }

contract token {
    /* ??????? */
    string public standard = 'Token 0.1';
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    /* ??????? */
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    /* ??????????????????? */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /* ????? */
    function token(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
        ) {
        balanceOf[msg.sender] = initialSupply;              // ??????????????????
        totalSupply = initialSupply;                        // ????????
        name = tokenName;                                   // ???????
        symbol = tokenSymbol;                               // ???????
        decimals = decimalUnits;                            // ????????
    }

    /* ???? */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // ???????????????
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // ????
        balanceOf[msg.sender] -= _value;                     // ?????????????
        balanceOf[_to] += _value;                            // ?????????????
        Transfer(msg.sender, _to, _value);                   // ??????????????????
    }

    /* Allow another contract to spend some tokens in your behalf */
    function approve(address _spender, uint256 _value)
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /* Approve and then communicate the approved contract in a single tx */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        returns (bool success) {    
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    /* ?????????????????? */
    function () {
        throw;     
    }
}

contract TlzsToken is owned, token {


    mapping (address => bool) public frozenAccount;

    /* ?????????????????????????????? */
    event FrozenFunds(address target, bool frozen);

    /* ????? */
    function TlzsToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol
    ) token (initialSupply, tokenName, decimalUnits, tokenSymbol) {}

    /* ???? */
    function transfer(address _to, uint256 _value) {
        if (balanceOf[msg.sender] < _value) throw;           // ??????????????
        if (balanceOf[_to] + _value < balanceOf[_to]) throw; // ????
        if (frozenAccount[msg.sender]) throw;                // ??????
        balanceOf[msg.sender] -= _value;                     // ???????????????
        balanceOf[_to] += _value;                            // ???????????????
        Transfer(msg.sender, _to, _value);                   // ????
    }


    /* A contract attempts to get the coins */
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if (frozenAccount[_from]) throw;                        // Check if frozen            
        if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
        if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
        if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
        balanceOf[_from] -= _value;                          // Subtract from the sender
        balanceOf[_to] += _value;                            // Add the same to the recipient
        allowance[_from][msg.sender] -= _value;
        Transfer(_from, _to, _value);
        return true;
    }

    function freezeAccount(address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }
}