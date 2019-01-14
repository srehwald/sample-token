// adopted parts from https://github.com/bokkypoobah/Tokens/blob/master/contracts/FixedSupplyToken.sol (accessed Dec 30, 2018)

pragma solidity ^0.5.0;


// ----------------------------------------------------------------------------
// Safe maths
// ----------------------------------------------------------------------------
library SafeMath {
    function add(uint a, uint b) internal pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function sub(uint a, uint b) internal pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
    function mul(uint a, uint b) internal pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
    function div(uint a, uint b) internal pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}

contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract SampleToken is ERC20Interface {
    using SafeMath for uint;

    string public symbol;
    string public  name;
    uint _totalSupply;

    address public minter;

    event Burn(address indexed from, uint tokens);

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "SAMPLE";
        name = "Sample Token";
        _totalSupply = 1000000;
        minter = msg.sender;
        balances[minter] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    // only contract owner can mint tokens!
    function mint(address receiver, uint amount) public returns (bool success) {
        if (msg.sender != minter) {
            return false;
        } else {
            _totalSupply = _totalSupply.add(amount);
            balances[receiver] = balances[receiver].add(amount);
            emit Transfer(address(0), receiver, amount);
            return true;   
        }
    }

    function burn(uint amount) public returns (bool success) {
        require(balances[msg.sender] >= amount, "Balance of sender not high enough.");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        _totalSupply = _totalSupply.sub(amount);
        emit Burn(msg.sender, amount);
        return true;
    }
}
