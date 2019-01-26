pragma solidity >=0.4.22 <0.6.0;

import "./ERC20.sol";
import "./ERC223.sol";
import "./ERC223ReceivingContract.sol";

contract FatNerdToken is ERC20Interface, ERC223Interface {
    string public constant symbol = "FNT";
    string public constant name = "Fat Nerd Token";
    uint8 public constant decimal = 6;

    uint private constant total = 666;
    mapping (address => uint) private balance;
    mapping (address => mapping (address => uint)) approved;

    constructor() public {
        balance[msg.sender] = total;
    }

    function totalSupply() public view returns (uint) {
        return total;
    }

    function balanceOf(address tokenOwner) public view returns (uint) {
        return balance[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint) {
        return approved[tokenOwner][spender];
    }

    function transfer(address to, uint tokens) public returns (bool) {
        if (tokens > 0 &&
            tokens <= balanceOf(msg.sender)) {
            balance[msg.sender] -= tokens;
            balance[to] += tokens;
            return true;
        }
        return false;
    }

    function approve(address spender, uint tokens) public returns (bool) {
        approved[msg.sender][spender] = tokens;
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool) {
        if (tokens > 0 &&
            approved[from][to] >= tokens) {
            approved[from][to] -= tokens;
            balance[from] -= tokens;
            balance[to] += tokens;
            return true;
        }
        return false;
    }

    function transfer(address to, uint value, bytes memory data) public {
        if (transfer(to, value)) {
            ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
            receiver.tokenFallback(msg.sender, value, data);
        }
    }
}
