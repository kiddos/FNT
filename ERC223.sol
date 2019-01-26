pragma solidity >=0.4.22 <0.6.0;

contract ERC223Interface {
    function balanceOf(address who) public view returns (uint);
    function transfer(address to, uint value, bytes memory data) public;
    event Transfer(address indexed from, address indexed to, uint value, bytes data);
}
