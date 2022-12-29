// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract LearnerContract {

    uint public count;
    bool public aBool; 
    address payable public MY_ADDRESS;
    address public immutable NOT_MY_ADDRESS = 0x777788889999AaAAbBbbCcccddDdeeeEfFFfCcCc; 
    bool private locked; 

    // storage is stored on the blockchain
    // memory is like ram and exists while a function is being called 
    // calldata is like cache where function args are 

    // Gas optimizations: 
    // - Replacing memory with calldata
    // - Loading state variable to memory
    // - Replace for loop i++ with ++i
    // - Caching array elements
    // - Short circuit

    constructor() payable {
        MY_ADDRESS = payable(msg.sender);
    }

    enum Order {
        Pending,
        Fulfilled, 
        Cancelled, 
        Stuck
    }

    Order public order; 

    function getOrder() public view returns(Order)
    {
        return order; 
    }

    function setOrder(Order orderType) public {
        order = orderType;
    }

    function setToPending() public {
        order = Order.Pending;
    }

    struct orderEntry {
        string ticker; 
        uint price; // doubles? floats? 
    }

    function createOrder(string calldata tix, uint price) public pure
    {
        orderEntry memory entry; 
        entry.ticker = tix; 
        entry.price = price;  
    }

    mapping(address => uint) public ledger; 


    modifier noReentrancy() 
    {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }
    function incBal(address addr) public
    {
        ledger[addr] += 1; 
    }

    function getBal(address addr) public view returns (uint)
    {
        return ledger[addr];
    }

    // Function to get the current count
    function get() public view returns (uint) {
        return count;
    }

    // Function to increment count by 1
    function inc() public {
        count += 1;
    }

    // Function to decrement count by 1
    function dec() public {
        // This function will fail if count = 0
        count -= 1;
    }

    function double() public {
        uint localVar = 2 wei; 
        count= count * localVar; 
    }

    function makeTrue() public {
        aBool = true; 
    }

    function makeFalse() public {
        aBool = false; 
    }

    function getABool() public view returns (bool)
    {
        return aBool; 
    }

    function getStamp() public view returns (uint)
    {
        return block.timestamp;
    }

    function whois() public view returns (address)
    {
        return msg.sender; 
    }

    function transactMe(uint updoot) public returns (uint) // what is view and why can't it be used if the state is being messed with? (view ensures the state is not modified)
    {
        count = updoot; 
        return count; 
    }

        function ternary(uint _x) public pure returns (uint) {
        // if (_x < 10) {
        //     return 1;
        // }
        // return 2;

        // shorthand way to write if / else statement
        // the "?" operator is called the ternary operator
        return _x < 10 ? 1 : 2;
    }

    function loopUp() public { // better to use this cuz gas, not while loops cuz that could run out of gas 
        for(uint i = 0; i < 16; i++)
        {
            count += 1; 
        }
    }

    function maybeRandom() public view returns (uint)
    {
        uint time = block.timestamp; 
        return time % 10; 
    }

    function getNumbers() public view returns (uint[4] memory)
    {
        uint[4] memory nums; 
        for(uint i = 0; i < 4; i++)
        {
            nums[i] = maybeRandom(); 
        }
        return nums; 
    }

    function testRequire(uint _in) public
    {
        require(_in > 16, "Input must be greater than 16");
        loopUp();
    }

     error InsufficientBalance(uint balance, uint withdrawAmount);

    function withdraw(uint amount) public view returns (uint)
    {
        uint bal = address(this).balance; 
        if(bal < amount)
        {
            revert InsufficientBalance({balance: bal, withdrawAmount: amount});
        }
        else 
        {
            return 1; 
        }
    }

    event Log(address indexed sender, string message);
    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
    }

    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
