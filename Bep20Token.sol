// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

interface iBEP20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Mint(address indexed sender, uint amount0, uint amount1);

}


contract BEP20Amazie is iBEP20 {
    string public constant name = "Amazie Holding";
    string public constant symbol = "AHIG";
    uint8 public constant decimals = 18;


    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 20000000 ether;


    constructor() {
        balances[msg.sender] = totalSupply_;
    }
    
    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function mint(address account, uint256 amount) public {
        require(account != address(0), "AmazieHolding: cannot mint to zero address");

        // Increase total supply
        totalSupply_ = totalSupply_ + (amount);
        // Add amount to the account balance using the balance mapping
        balances[account] = balances[account] + amount;
        // Emit our event to log the action
        emit Transfer(address(0), account, amount);
    }

    function burn(address account, uint256 amount) public {
        require(account != address(0), "AmazieHolding: cannot burn from zero address");
        require(balances[account] >= amount, "AmazieHolding: Cannot burn more than the account owns");

        // Remove the amount from the account balance
        balances[account] = balances[account] - amount;
        // Decrease totalSupply
        totalSupply_ = totalSupply_ - amount;
        // Emit event, use zero address as reciever
        emit Transfer(account, address(0), amount);
    }


}